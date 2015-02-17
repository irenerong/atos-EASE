//
//  EANetworkingHelper.m
//  EASE
//
//  Created by Aladin TALEB on 12/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EANetworkingHelper.h"


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


@end

@implementation EANetworkingHelper

static NSString* witServerAdress = @"https://api.wit.ai/";
static NSString *witHeader = @"Authorization";

static NSString *witToken = @"Bearer Z6RAMHMFQLP6FG2KSPTT4F23XH5GK5L4";

static NSString *witAPIVersion = @"20150212";



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
        [Wit sharedInstance].accessToken = @"Z6RAMHMFQLP6FG2KSPTT4F23XH5GK5L4";
        [Wit sharedInstance].delegate = self;
        
        self.witServerManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:witServerAdress]];
        self.witServerManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [self.witServerManager.requestSerializer setValue:witToken forHTTPHeaderField:witHeader];
        
        self.witServerManager.responseSerializer = [AFJSONResponseSerializer serializer];

    
        
        
        
    }
    
    return self;
}

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
            
            dictionary[@"fromDate"] = fromDate;
            
        }
        else
        {
            NSString *fromDateString = dates[@"from"][@"value"];
            NSString *toDateString = dates[@"to"][@"value"];
            
            NSDate *fromDate = [self witStringToDate:fromDateString];
            NSDate *toDate = [self witStringToDate:toDateString];
            
            dictionary[@"fromDate"] = fromDate;
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
    

    dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange(dateString.length-3, 3)];
    
    
   
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    
    NSDate *date = [dateFormat dateFromString:dateString];
    
    return date;
}

-(void)witDidGraspIntent:(NSArray *)outcomes messageId:(NSString *)messageId customData:(id)customData error:(NSError *)e
{
    NSLog(@"\n%@ \n%@ \n%@ \n%@", outcomes, messageId, customData, e);
   
}


-(void)searchForWorkflowsWithConstraints:(NSDictionary*)constraints completionBlock:(void (^) (NSArray*, NSError*))completionBlock
{
    
    NSLog(@"%@", [constraints bv_jsonStringWithPrettyPrint:true]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        workflow = [EAWorkflow new];
        workflow.imageURL = [NSURL URLWithString:@"http://www.supermarchesmatch.fr/userfiles/images/Poulet%20au%20curry.jpg"];
        
        workflow.title = @"Poulet au curry";
        EADateInterval *dateInterval;
        
        EATask *task1 = [EATask new];
        task1.title = @"Préparer le poulet";
        task1.taskDescription = @"Task1 - Description";
        dateInterval = [EADateInterval new];
        dateInterval.startDate = [NSDate date];
        dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
        task1.dateInterval = dateInterval;
        
        EATask *task2 = [EATask new];
        task2.title = @"Task2";
        task2.taskDescription = @"Task2 - Description";
        dateInterval = [EADateInterval new];
        dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:10*60];
        dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
        task2.dateInterval = dateInterval;
        
        EATask *task3 = [EATask new];
        task3.title = @"Task3";
        task3.taskDescription = @"Task3 - Description";
        dateInterval = [EADateInterval new];
        dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:30*60];
        dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:70*60];
        task3.dateInterval = dateInterval;
        
        EATask *task4 = [EATask new];
        task4.title = @"Task4";
        task4.taskDescription = @"Task4 - Description";
        dateInterval = [EADateInterval new];
        dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:75*60];
        dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:100*60];
        task4.dateInterval = dateInterval;
        
        EATask *task5 = [EATask new];
        task5.title = @"Cuire le poulet";
        task5.taskDescription = @"Task5 - Description";
        dateInterval = [EADateInterval new];
        dateInterval.startDate = [NSDate dateWithTimeIntervalSinceNow:25*60];
        dateInterval.endDate = [NSDate dateWithTimeIntervalSinceNow:45*60];
        task5.dateInterval = dateInterval;
        
        workflow.tasks = @[task1, task2, task3, task4, task5];
        completionBlock(@[workflow,workflow,workflow,workflow,workflow,workflow,workflow,workflow], nil);
    });
}


@end
