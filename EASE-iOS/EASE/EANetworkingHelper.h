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


extern NSString *const EATaskUpdate;


@class EAMetaworkflow;
@class EAWorkflow;
@class EADateInterval;
@class EATask;
@class EASearchResults;
@class EALoginViewController;


@interface EANetworkingHelper : NSObject <WitDelegate>

+ (EANetworkingHelper *)sharedHelper;


@property (nonatomic, strong) NSString            *easeServerAdress;
@property (nonatomic, strong) EAUser              *currentUser;
@property (nonatomic, weak) EALoginViewController *loginViewController;
@property (nonatomic, strong) NSArray             *colors;

#pragma mark - Wit Processing

- (void)witProcessed:(NSString *)string completionBlock:(void (^)(NSDictionary *results, NSError *error))completionBlock;


#pragma mark - EASE SERVER NETWORKING

//LOGIN & USER
- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password completionBlock:(void (^) (NSError *error) )completionBlock;
- (void)logout;

- (void)retrieveUserIngredients:(void (^) () )completionBlock;

//GENERATE WORKFLOWS

- (void)searchWorkflowsWithConstraints:(NSDictionary *)constraints completionBlock:(void (^) (int totalNumberOfWorkflows, EASearchResults *searchResults, NSError *error))completionBlock;
- (void)sortWorkflowBy:(NSString *)sortBy completionBlock:(void (^) (EASearchResults *searchResults, NSError *error))completionBlock;


- (void)validateWorkflow:(EAWorkflow *)workflow completionBlock:(void (^)  (NSError *error) )completionBlock;

//GET DATA

- (void)retrieveWorkflowWithID:(int)workflowID completionBlock:(void (^) (EAWorkflow *workflow, int metaworkflowID, NSError *error))completionBlock;
- (void)retrieveMetaworkflowWithID:(int)metaworkflowID completionBlock:(void (^) (EAMetaworkflow *metaworkflow, NSError *error))completionBlock;
- (void)retrieveTaskWithID:(int)taskID completionBlock:(void (^) (EATask *task, NSError *error))completionBlock;
- (void)retrieveWorkflowIDWithTaskID:(int)taskID completionBlock:(void (^) (int workflowID, NSError *error))completionBlock;
- (void)retrieveStartConditionWithID:(int)startConditionID completionBlock:(void (^) (NSDictionary *startCondition, NSError *error))completionBlock;
- (void)retrieveAgentWithID:(int)agentID completionBlock:(void (^) (EAAgent *agent, NSError *error))completionBlock;


- (void)getPendingTasksCompletionBlock:(void (^) (EASearchResults *searchResults, NSError *error))completionBlock;
- (void)getPendingAndWorkingTasksCompletionBlock:(void (^) (EASearchResults *searchResults, NSError *error))completionBlock;
- (void)getWorkingTasksCompletionBlock:(void (^) (EASearchResults *searchResults, NSError *error))completionBlock;
- (void)getNumberOfPendingTasks:(void (^) (int nb, NSError *error))completionBlock;
- (void)getNumberOfWorkingTasks:(void (^) (int nb, NSError *error))completionBlock;

- (void)tasksAtDay:(NSDate *)date completionBlock:(void (^) (EASearchResults *result, NSError *error))completionBlock;

//START TASK

- (void)startTask:(EATask *)task completionBlock:(void (^) (NSError *error))completionBlock;
- (void)finishTask:(EATask *)task completionBlock:(void (^) (NSError *error))completionBlock;




@end
