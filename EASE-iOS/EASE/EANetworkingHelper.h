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
#import "EAAgent.h"

#import "AFNetworking+PromiseKit.h"


extern NSString* const EATaskUpdate;


@class EAMetaworkflow;
@class EAWorkflow;
@class EADateInterval;
@class EATask;

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

@property(nonatomic, weak) EALoginViewController *loginViewController;

@property(nonatomic, readwrite) BOOL displayNotificationPopup;

+ (EANetworkingHelper *)sharedHelper;

-(void)witProcessed:(NSString*)string completionBlock:(void (^)(NSDictionary* results, NSError* error))completionBlock;


//EASE SERVER NETWORKING

-(void)loginWithUsername:(NSString*)username andPassword:(NSString*)password completionBlock:(void (^) (NSError *error) )completionBlock;

-(void)logout;

-(void)searchWorkflowsWithConstraints:(NSDictionary*)constraints completionBlock:(void (^) (int totalNumberOfWorkflows, EASearchResults* searchResults, NSError* error))completionBlock;

-(void)searchWorklowsBetweenId:(int)id1 andId:(int)id2 completionBlock:(void (^) (NSArray* workflows, NSError* error))completionBlock;

-(void)retrieveWorkflowWithID:(int)workflowID completionBlock:(void (^) (EAWorkflow* workflow, int metaworkflowID, NSError *error))completionBlock;

-(void)retrieveMetaworkflowWithID:(int)metaworkflowID completionBlock:(void (^) (EAMetaworkflow* metaworkflow, NSError *error))completionBlock;

-(void)retrieveTaskWithID:(int)taskID completionBlock:(void (^) (EATask* task, NSError *error))completionBlock;

-(void)retrieveWorkflowIDWithTaskID:(int)taskID completionBlock:(void (^) (int workflowID, NSError *error))completionBlock;


-(void)retrieveStartConditionWithID:(int)startConditionID completionBlock:(void (^) (NSDictionary* startCondition, NSError *error))completionBlock;

-(void)retrieveAgentWithID:(int)agentID completionBlock:(void (^) (EAAgent* agent, NSError *error))completionBlock;


-(void)getPendingTasksCompletionBlock:(void (^) (EASearchResults* searchResults, NSError* error))completionBlock;

-(void)getWorkingTasksCompletionBlock:(void (^) (EASearchResults* searchResults, NSError* error))completionBlock;

-(void)getNumberOfPendingTasks:(void (^) (int nb, NSError* error))completionBlock;
-(void)getNumberOfWorkingTasks:(void (^) (int nb, NSError* error))completionBlock;


-(void)modifyWorkflow:(EAWorkflow*)workflow withParams:(NSDictionary*)params completionBlock:(void (^) (EAWorkflow *newWorkflow, NSError *error))completionBlock;

-(void)validateWorkflow:(EAWorkflow*)workflow completionBlock:(void (^)  (NSError *error) )completionBlock;

-(void)tasksAtDay:(NSDate*)date completionBlock:(void (^) (EASearchResults *result, NSError *error)) completionBlock;

-(void)workflowsAtDay:(NSDate*)date completionBlock:(void (^) (NSArray *workflows)) completionBlock;

-(void)startTask:(EATask*)task completionBlock:(void (^) (NSError *error)) completionBlock;

//EASE NOTIFICATIONS



@end
