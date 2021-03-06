//
//  EATask.h
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EANetworkingHelper.h"

@class EAWorkflow;
@class EADateInterval;
@class EAAgent;
@class EAMetaTask;

typedef enum : NSUInteger {
    EATaskStatusWaiting,
    EATaskStatusWorking,
    EATaskStatusPending,
    EATaskStatusFinished
} EATaskStatus;

@interface EATask : NSObject
{
}

+ (instancetype)taskByParsingGeneratorDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow;

+ (instancetype)taskByParsingSearchDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow completion:(void (^)(EATask *task))completionBlock;

- (instancetype)initWithGeneratorDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow;


- (instancetype)initWithSearchDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow completion:(void (^)(EATask *task))completionBlock;

- (void)updateWithTask:(EATask *)task;
- (void)updateWithFeedback:(NSDictionary *)feedback;


@property (nonatomic, readonly) int             taskID;
@property (nonatomic, readonly) int             metataskID;
@property (nonatomic, readonly) NSArray         *predecessors;
@property (nonatomic, strong) NSString          *title;
@property (nonatomic, strong) NSString          *taskDescription;
@property (nonatomic, strong) EADateInterval    *dateInterval;
@property (nonatomic, weak) EAAgent             *agent;
@property (nonatomic, readonly) int             agentID;
@property (nonatomic, weak) EAWorkflow          *workflow;
@property (nonatomic, readwrite) EATaskStatus   status;
@property (nonatomic, strong) NSString          *textStatus;
@property (nonatomic, readwrite) NSTimeInterval timeLeft;
@property (nonatomic, strong) NSDictionary      *consumption;
- (EAMetaTask *)metatask;
- (float)       completionPercentage;



@end
