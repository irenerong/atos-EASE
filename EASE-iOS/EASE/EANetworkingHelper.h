//
//  EANetworkingHelper.h
//  EASE
//
//  Created by Aladin TALEB on 12/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "Socket_IO_Client_Swift-Swift.h"
#import "AFNetworking.h"
#import "Wit.h"
#import "EAUser.h"


extern NSString* const EAPendingTaskAdd;
extern NSString* const EAPendingTaskRemove;

extern NSString* const EAWorkingTaskAdd;
extern NSString* const EAWorkingTaskRemove;
extern NSString* const EAWorkingTaskUpdate;


@class EAMetaworkflow;
@class EAWorkflow;
@class EADateInterval;
@class EATask;
@class EAPendingTask;
@class EAWorkingTask;
@class EASearchResults;
@class EALoginViewController;

@protocol EANetworkingHelperDelegate <NSObject>

@end

@interface EANetworkingHelper : NSObject <WitDelegate>
{
    EAWorkflow *workflowTest;
    NSArray *colors;
}

@property(nonatomic, weak) id <EANetworkingHelperDelegate> delegate;

@property(nonatomic, strong) NSString *easeServerAdress;

@property(nonatomic, readonly) EAUser *currentUser;

@property(nonatomic, readonly) NSMutableArray *currentWorkflows;

@property(nonatomic, readonly) NSMutableArray *pendingTasks;

@property(nonatomic, readonly) NSMutableArray *workingTasks;


@property(nonatomic, readonly) NSMutableArray *completedTasks;

@property(nonatomic, weak) EALoginViewController *loginViewController;

@property(nonatomic, readwrite) BOOL displayNotificationPopup;

+ (EANetworkingHelper *)sharedHelper;

-(void)witProcessed:(NSString*)string completionBlock:(void (^)(NSDictionary* results, NSError* error))completionBlock;


//EASE SERVER NETWORKING

-(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password completionBlock:(void (^) (NSError *error) )completionBlock;

-(void)logout;

-(void)searchWorkflowsWithConstraints:(NSDictionary*)constraints completionBlock:(void (^) (int totalNumberOfWorkflows, EASearchResults* searchResults, NSError* error))completionBlock;

-(void)searchWorklowsBetweenId:(int)id1 andId:(int)id2 completionBlock:(void (^) (NSArray* workflows, NSError* error))completionBlock;

-(void)retrieveWorkflow:(EAWorkflow*)workflow completionBlock:(void (^) (NSError *error))completionBlock;

-(void)retrieveMetaworkflowWithID:(int)metaworkflowID completionBlock:(void (^) (EAMetaworkflow* metaworkflow, NSError *error))completionBlock;


-(void)modifyWorkflow:(EAWorkflow*)workflow withParams:(NSDictionary*)params completionBlock:(void (^) (EAWorkflow *newWorkflow, NSError *error))completionBlock;

-(void)validateWorkflow:(EAWorkflow*)workflow completionBlock:(void (^)  (NSError *error) )completionBlock;

-(void)tasksAtDay:(NSDate*)date completionBlock:(void (^) (NSArray *tasks)) completionBlock;

-(void)workflowsAtDay:(NSDate*)date completionBlock:(void (^) (NSArray *workflows)) completionBlock;

//EASE NOTIFICATIONS

-(void)startPendingTask:(EAPendingTask*)task completionBlock:(void (^) (BOOL ok, EAWorkingTask *workingTask) )completionBlock;

-(void)endWorkingTask:(EAWorkingTask*)task completionBlock:(void (^) (BOOL ok) )completionBlock;


@end
