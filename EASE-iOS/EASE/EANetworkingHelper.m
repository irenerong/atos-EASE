//
//  EANetworkingHelper.m
//  EASE
//
//  Created by Aladin TALEB on 12/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "NSDate+JSParse.h"

#import "EANetworkingHelper.h"
#import "EAWorkflow.h"
#import "EADateInterval.h"
#import "EATask.h"
#import "EAPendingTask.h"
#import "EAWorkingTask.h"
#import "EASearchResults.h"
#import "EAMetaworkflow.h"

#import "EALoginViewController.h"

@interface NSDictionary (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

@implementation NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end

@interface EANetworkingHelper ()


@property(nonatomic, strong) AFHTTPSessionManager *easeServerManager;

@property(nonatomic, strong) AFHTTPSessionManager *witServerManager;

@property(nonatomic, strong) SocketIOClient* easeSocketManager;


@end

@implementation EANetworkingHelper

 NSString* const witServerAddress = @"https://api.wit.ai/";
 NSString* const witHeader = @"Authorization";

NSString* const witToken = @"Bearer Z6RAMHMFQLP6FG2KSPTT4F23XH5GK5L4";
NSString* const witAPIVersion = @"20150212";




NSString* const EAPendingTaskAdd = @"EAPendingTaskAdd";
NSString* const EAPendingTaskRemove = @"EAPendingTaskRemove";

 NSString* const EAWorkingTaskAdd = @"EAWorkingTaskAdd";
 NSString* const EAWorkingTaskRemove = @"EAWorkingTaskRemove";
NSString* const EAWorkingTaskUpdate = @"EAWorkingTaskUpdate";




+ (EANetworkingHelper *)sharedHelper
{
    static EANetworkingHelper *_sharedHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[self alloc] init];
    });
    
    return _sharedHelper;
}


-(id)init
{
    if (self = [super init])
    {
        
        colors = @[[UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0], [UIColor colorWithRed:28/255.0 green:253/255.0 blue:171/255.0 alpha:1.0], [UIColor colorWithRed:252/255.0 green:200/255.0 blue:53/255.0 alpha:1.0], [UIColor colorWithRed:253/255.0 green:101/255.0 blue:107/255.0 alpha:1.0], [UIColor colorWithRed:254/255.0 green:100/255.0 blue:192/255.0 alpha:1.0]];
        self.easeServerAdress = @"localhost:1337";
        
        _pendingTasks = [NSMutableArray array];
        _workingTasks = [NSMutableArray array];
        _completedTasks = [NSMutableArray array];
        
        [Wit sharedInstance].accessToken = @"Z6RAMHMFQLP6FG2KSPTT4F23XH5GK5L4";
        [Wit sharedInstance].delegate = self;
        
        
        
        self.witServerManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:witServerAddress]];
        self.witServerManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.witServerManager.requestSerializer setValue:witToken forHTTPHeaderField:witHeader];
        
        self.witServerManager.responseSerializer = [AFJSONResponseSerializer serializer];

        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(receivedPendingTask) userInfo:nil repeats:true];

        self.displayNotificationPopup = true;
        
        _currentUser = nil;
        

    }
    
    return self;
}

-(void)setEaseServerAdress:(NSString *)easeServerAdress
{
    _easeServerAdress = easeServerAdress;
    self.easeServerManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/", easeServerAdress]]];
    
   
}

-(void)setCookie:(NSHTTPCookie*)cookie
{
    
    
    NSString *cookieString = [NSString stringWithFormat:@"domain=\"%@\";path=\"%@\";name:\"%@\";value=\"%@\"", cookie.domain, cookie.path, cookie.name, cookie.value];
    
    self.easeSocketManager = [[SocketIOClient alloc] initWithSocketURL:_easeServerAdress options:@{@"Cookie": cookieString}];
    
    [self.easeSocketManager on: @"connect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"connected \n %@", data);
        
    }];
    
    [self.easeSocketManager on: @"reconnect" callback: ^(NSArray* data, void (^ack)(NSArray*)) {
        NSLog(@"reconnect \n %@", data);
        
    }];
    
    [self.easeSocketManager on:@"error" callback:^(NSArray *data, void (^ack)(NSArray*))  {
        NSLog(@"error \n %@", data);
        
    }];
    
    [self.easeSocketManager on:@"subtask" callback:^(NSArray *data, void (^ack)(NSArray*)){
        NSLog(@"subtasks \n %@", data);
    }];
    
    [self.easeSocketManager onAny:^{
        NSLog(@"ON !");
    }];
    
    [self.easeSocketManager connect];
}

#pragma mark - WIT



-(void)witProcessed:(NSString*)string completionBlock:(void (^)(NSDictionary*, NSError*))completionBlock
{
    
    if (!string || string.length < 4)
        return;
    
    //[[Wit sharedInstance] interpretString:string customData:nil];
    NSDictionary *parameters = @{ @"v": witAPIVersion, @"q": string};
    
    [self.witServerManager GET:@"message" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"Success : %@", responseObject);
        NSDictionary *constraints = [self parseWitDictionary:responseObject];
        
        completionBlock(constraints, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail : %@", error);
        
        completionBlock(nil, error);
        
    }];
    
}

-(NSDictionary*)parseWitDictionary:(NSDictionary*)witDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDictionary *outcomeDictionary = [((NSArray*)witDictionary[@"outcomes"]) firstObject];
    
    NSString *intent = outcomeDictionary[@"intent"];
    
    
    dictionary[@"intent"] = intent;
    
    
    
    
    NSDictionary *entities = outcomeDictionary[@"entities"];
    
    if (!entities)
        return nil;
    
    
    NSDictionary *dates = ((NSDictionary*)((NSArray*)entities[@"datetime"]).firstObject);
    
    if (dates)
    {
        if ([dates[@"type"] isEqualToString:@"value"])
        {
            NSString *fromDateString = dates[@"value"];
            
            NSDate *fromDate = [self witStringToDate:fromDateString];
            
            NSLog(@"From %@ : %@", fromDateString, fromDate);
            
            if (fromDate)
            dictionary[@"fromDate"] = fromDate;
            
        }
        else
        {
            NSString *fromDateString = dates[@"from"][@"value"];
            NSString *toDateString = dates[@"to"][@"value"];
            
            NSDate *fromDate = [self witStringToDate:fromDateString];
            NSDate *toDate = [self witStringToDate:toDateString];
            if (fromDate)
            dictionary[@"fromDate"] = fromDate;
            
            if (toDate)
            dictionary[@"toDate"] = toDate;
            
            
            NSLog(@"From %@ : %@\nTo %@ : %@", fromDateString, fromDate, toDateString, toDate);
        }
        
        
    }
    
    NSDictionary *searchQuery = ((NSDictionary*)((NSArray*)entities[@"search_query"]).firstObject);
    
    
    if (searchQuery)
    {
        
        NSString *search = searchQuery[@"value"];
        
        dictionary[@"search"] = search;
        
    }
    
    
    
    
    
    return dictionary;
    
}

-(NSDate*)witStringToDate:(NSString*)dateString
{
    
    return [NSDate dateByParsingJSString:dateString];
}

-(void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)e
{
    NSLog(@"\n%@ \n%@ \n%@ \n%@", outcomes, messageId, customData, e);
    
}

#pragma mark - Workflow Login


-(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password completionBlock:(void (^) (NSError *error) )completionBlock
{
    
    
    
    NSDictionary *parameters = @{@"username": username, @"password" : password};
    

    self.easeServerManager.responseSerializer =  [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
 
    
    //[self.easeSocketManager emitObjc:@"get" withItems:@{@"url": @"/user/\"}"}];
    
    /*[[self.easeSocketManager emitWithAckObjc:@"post" withItems: @{@"url" : @"/user/signin/", @"data" : @{ @"username" : username, @"password" : password}} ]  onAck:0 withCallback:^(NSArray *cb) {
        
        
        NSLog(@"cb : %@", cb);

        
        NSDictionary *responseObject = cb[0][@"body"];
        
        NSLog(@"cb : %@", responseObject);
        
        if (responseObject[@"error"])
        {
            completionBlock([NSError errorWithDomain:responseObject[@"error"] code:0 userInfo:nil]);
        }
        else
        {
            _currentUser = [EAUser new];
            _currentUser.username = responseObject[@"user"][@"username"];
            completionBlock(nil);
            
        }
        
    }];
    */
    
    
        [self.easeServerManager POST:@"User/signin" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
            
            if (responseObject[@"error"])
            {
                completionBlock([NSError errorWithDomain:responseObject[@"error"] code:0 userInfo:nil]);
            }
            else
            {
                
                NSHTTPCookie *cookie = [[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"http://localhost:1337/"]] firstObject];
                NSLog(@"%@", cookie.properties);
                
                [self setCookie:cookie];
                _currentUser = [EAUser new];
                _currentUser.username = responseObject[@"user"][@"username"];
            completionBlock(nil);

            }
            
            
          
            
            
            
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            completionBlock(error);
        
        }];
    
    
    
    
}

-(void)logout
{
    _currentUser = nil;
    [self.loginViewController logout];
}

#pragma mark - Workflow Search

-(void)searchWorkflowsWithConstraints:(NSDictionary*)constraints completionBlock:(void (^) (int totalNumberOfWorkflows, EASearchResults* searchResults, NSError* error))completionBlock;
{
    
    NSLog(@"%@", [constraints bv_jsonStringWithPrettyPrint:true]);
    
    NSMutableDictionary *parameters =  [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:@{@"intent": constraints[@"intent"]}];
    
    if (constraints[@"endDate"])
    {
        [parameters addEntriesFromDictionary:@{@"time": constraints[@"endDate"]}];
        [parameters addEntriesFromDictionary:@{@"type": @1}];
        [parameters addEntriesFromDictionary:@{@"option": @0}];

    }
    else if(constraints[@"startDate"])
    {
        [parameters addEntriesFromDictionary:@{@"time": constraints[@"startDate"]}];
        [parameters addEntriesFromDictionary:@{@"type": @0}];
        [parameters addEntriesFromDictionary:@{@"option": @1}];
    }
    
    
    [self.easeServerManager POST:@"workflow/createwf" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
        
        EASearchResults *results = [EASearchResults searchResultsByParsingDictionary:responseObject];
        
        completionBlock(results.workflows.count, results, nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completionBlock(0, nil, error);
        
    }];

    
    
    
}

-(void)searchWorklowsBetweenId:(int)id1 andId:(int)id2 completionBlock:(void (^) (NSArray* workflows, NSError* error))completionBlock
{
    
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        workflowTest = [EAWorkflow new];
        workflowTest.imageURL = [NSURL URLWithString:@"http://www.supermarchesmatch.fr/userfiles/images/Poulet%20au%20curry.jpg"];
        workflowTest.workflowID = 0;
        workflowTest.title = @"Poulet au curry";
        workflowTest.sortTag = @"Hour";
        completionBlock(@[workflowTest,workflowTest,workflowTest,workflowTest], nil);
    });*/
    
}

-(void)retrieveWorkflow:(EAWorkflow*)workflow completionBlock:(void (^) (NSError *error))completionBlock
{
    
    
    EADateInterval *dateInterval;
    
    EATask *task1 = [EATask new];
    task1.title = @"Préparer le poulet";
    task1.taskDescription = @"Task1 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate date];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
    task1.dateInterval = dateInterval;
    task1.workflow = workflowTest;
    
    EATask *task2 = [EATask new];
    task2.title = @"Task2";
    task2.taskDescription = @"Task2 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
    task2.dateInterval = dateInterval;
    task2.workflow = workflowTest;
    
    EATask *task3 = [EATask new];
    task3.title = @"Task3";
    task3.taskDescription = @"Task3 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:70*60];
    task3.dateInterval = dateInterval;
    task3.workflow = workflowTest;
    
    EATask *task4 = [EATask new];
    task4.title = @"Task4";
    task4.taskDescription = @"Task4 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:75*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:100*60];
    task4.dateInterval = dateInterval;
    task4.workflow = workflowTest;
    
    EATask *task5 = [EATask new];
    task5.title = @"Cuire le poulet";
    task5.taskDescription = @"Task5 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:25*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:45*60];
    task5.dateInterval = dateInterval;
    task5.workflow = workflowTest;
    
    workflow.tasks = [NSArray arrayWithObjects:task1, task2, task3, task4, task5, nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        completionBlock(nil);
    });
    
    
}

-(void)retrieveMetaworkflowWithID:(int)metaworkflowID completionBlock:(void (^)(EAMetaworkflow *, NSError *))completionBlock
{
    
    NSDictionary *parameters = @{@"id" : @(metaworkflowID)};
    
    [self.easeServerManager GET:@"metaworkflow/" parameters:parameters success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        
        EAMetaworkflow *metaworkflow = [EAMetaworkflow metaworkflowByParsingDictionary:responseObject];
        completionBlock(metaworkflow, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionBlock(nil, error);
    }];
    
}

-(void)validateWorkflow:(EAWorkflow*)workflow completionBlock:(void (^)  (NSError *error)) completionBlock
{
    
    [self.easeServerManager POST:@"WorkflowGenerator/validate" parameters:@{@"index" : @(workflow.workflowID)} success:^(NSURLSessionDataTask *task, NSDictionary * responseObject) {
        
        NSLog(@"%@", responseObject);
        
        completionBlock(nil);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        completionBlock(error);
        
    }];
    
}


-(void)tasksAtDay:(NSDate*)date completionBlock:(void (^) (NSArray *tasks)) completionBlock
{
    
    EADateInterval *dateInterval;
    
    EATask *task1 = [EATask new];
    task1.title = @"Préparer le poulet";
    task1.taskDescription = @"Task1 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate date];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
    task1.dateInterval = dateInterval;
    task1.workflow = workflowTest;
    
    EATask *task2 = [EATask new];
    task2.title = @"Task2";
    task2.taskDescription = @"Task2 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
    task2.dateInterval = dateInterval;
    task2.workflow = workflowTest;
    
    EATask *task3 = [EATask new];
    task3.title = @"Task3";
    task3.taskDescription = @"Task3 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:70*60];
    task3.dateInterval = dateInterval;
    task3.workflow = workflowTest;
    
    EATask *task4 = [EATask new];
    task4.title = @"Task4";
    task4.taskDescription = @"Task4 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:75*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:100*60];
    task4.dateInterval = dateInterval;
    task4.workflow = workflowTest;
    
    EATask *task5 = [EATask new];
    task5.title = @"Cuire le poulet";
    task5.taskDescription = @"Task5 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:25*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:45*60];
    task5.dateInterval = dateInterval;
    task5.workflow = workflowTest;
    
  
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        completionBlock( [NSArray arrayWithObjects:task1, task2, task3, task4, task5, nil]);
    });

}

-(void)workflowsAtDay:(NSDate*)date completionBlock:(void (^) (NSArray *workflows)) completionBlock
{
    
    EADateInterval *dateInterval;
    
    EATask *task1 = [EATask new];
    task1.title = @"Préparer le poulet";
    task1.taskDescription = @"Task1 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate date];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
    task1.dateInterval = dateInterval;
    task1.workflow = workflowTest;
    
    EATask *task2 = [EATask new];
    task2.title = @"Task2";
    task2.taskDescription = @"Task2 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
    task2.dateInterval = dateInterval;
    task2.workflow = workflowTest;
    
    EATask *task3 = [EATask new];
    task3.title = @"Task3";
    task3.taskDescription = @"Task3 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:70*60];
    task3.dateInterval = dateInterval;
    task3.workflow = workflowTest;
    
    EATask *task4 = [EATask new];
    task4.title = @"Task4";
    task4.taskDescription = @"Task4 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:75*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:100*60];
    task4.dateInterval = dateInterval;
    task4.workflow = workflowTest;
    
    EATask *task5 = [EATask new];
    task5.title = @"Cuire le poulet";
    task5.taskDescription = @"Task5 - Description";
    dateInterval = [EADateInterval new];
    dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:25*60];
    dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:45*60];
    task5.dateInterval = dateInterval;
    task5.workflow = workflowTest;
    
    workflowTest = [[EAWorkflow alloc] init];
    //workflowTest.title = @"Poulet au Curry";
    workflowTest.tasks = @[task1, task2, task3, task4, task5];
    workflowTest.color = colors[arc4random()%5];
    workflowTest.imageURL = [NSURL URLWithString:@"http://www.supermarchesmatch.fr/userfiles/images/Poulet%20au%20curry.jpg"];
    workflowTest.metaworkflow = [EAMetaworkflow metaworkflowByParsingDictionary:@{@"title": @"Poulet Curry"}];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        
        completionBlock( [NSArray arrayWithObjects:workflowTest, nil]);
    });
    
}

#pragma mark - Notifications

-(void)receivedPendingTask {
    
    
    //if (!workflowTest || !workflowTest.tasks || ! workflowTest.tasks.count)
      //  return;
    
    
    

    
    EAPendingTask *pendingTask = [EAPendingTask new];
    pendingTask.alertMessage = @"Check up the oven !";
   // pendingTask.task = workflowTest.tasks[arc4random()%workflowTest.tasks.count];
    
    
    pendingTask.color = colors[arc4random()%5];
    
    
    [self.pendingTasks addObject:pendingTask];
    
    if (self.displayNotificationPopup)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pop" message:@"Plop" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //[alert show];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EAPendingTaskAdd object:nil];

    }
}

-(void)receivedWorkingTask:(EAWorkingTask*)workingTask {
    
    
    [self.workingTasks addObject:workingTask];
    
    if (self.displayNotificationPopup)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pop" message:@"Plop" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //[alert show];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EAWorkingTaskAdd object:nil];
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:arc4random()%5 target:self selector:@selector(updateWorkingTask:) userInfo:workingTask repeats:NO];
}

-(void)updateWorkingTask:(NSTimer*)timer
{
    EAWorkingTask *task = timer.userInfo;
    task.completionPercentage += 0.1;
    [[NSNotificationCenter defaultCenter] postNotificationName:EAWorkingTaskUpdate object:self userInfo:@{@"workingTask": task}];
    
    if (task.completionPercentage < 1)
        [NSTimer scheduledTimerWithTimeInterval:arc4random()%5 target:self selector:@selector(updateWorkingTask:) userInfo:task repeats:NO];
}


-(void)startPendingTask:(EAPendingTask*)task completionBlock:(void (^) (BOOL ok, EAWorkingTask *workingTask) )completionBlock
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pendingTasks removeObject:task];
        EAWorkingTask *workingTask = [EAWorkingTask new];
        workingTask.status = @"Cooking";
        workingTask.color = task.color;
        
        
        [self receivedWorkingTask:workingTask];

        completionBlock(YES, workingTask);
    });
    
    
}

-(void)endWorkingTask:(EAWorkingTask*)task completionBlock:(void (^) (BOOL ok) )completionBlock
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.workingTasks removeObject:task];
        completionBlock(YES);
    });
}


@end
