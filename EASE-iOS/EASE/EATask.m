//
//  EATask.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "NSDate+Complements.h"

#import "EATask.h"

#import "EADateInterval.h"
#import "EAAgent.h"
#import "EAWorkflow.h"
#import "EAMetaTask.h"

@implementation EATask
#pragma mark - Init

+ (instancetype)taskByParsingGeneratorDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow {
    return [[EATask alloc] initWithGeneratorDictionary:dictionary fromWorkflow:workflow];
}

+ (instancetype)taskByParsingSearchDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow completion:(void (^)(EATask *))completionBlock {
    return [[EATask alloc] initWithSearchDictionary:dictionary fromWorkflow:workflow completion:^(EATask *task) {
                completionBlock(task);
            }];
}

- (instancetype)initWithGeneratorDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow {
    if (self = [super init]) {
        _workflow = workflow;




        _taskID     = ((NSNumber *)dictionary[@"subTask"]).intValue;
        _metataskID = ((NSNumber *)dictionary[@"metatask"]).intValue;



        _predecessors = dictionary[@"predecessors"];

        _agentID = ((NSNumber *)dictionary[@"agentID"]).intValue;

        _title = dictionary[@"action"];

        NSDate *beginTime = [NSDate dateByParsingJSString:dictionary[@"beginTime"]];
        float  duration   = ((NSString *)dictionary[@"duration"]).intValue;
        NSDate *endTime   = [beginTime dateByAddingTimeInterval:duration * 60];
        _dateInterval = [EADateInterval dateIntervalFrom:beginTime to:endTime];

        self.consumption = dictionary[@"consumption"];
    }
    return self;
}

- (instancetype)initWithSearchDictionary:(NSDictionary *)dictionary fromWorkflow:(EAWorkflow *)workflow completion:(void (^)(EATask *))completionBlock {
    if (self = [super init]) {
        _workflow = workflow;

        self.consumption = dictionary[@"consumption"];


        _taskID     = ((NSString *)dictionary[@"id"]).intValue;
        _metataskID = ((NSString *)dictionary[@"metatask"]).intValue;

        _title = dictionary[@"action"];


        [self stringToStatus:dictionary[@"status"]];

        int startConditionID = ((NSString *)dictionary[@"startCondition"]).intValue;

        _agentID = ((NSString *)dictionary[@"agent"]).intValue;

        [[EANetworkingHelper sharedHelper] retrieveStartConditionWithID:startConditionID completionBlock:^(NSDictionary *startCondition, NSError *error) {
             _predecessors = startCondition[@"waitforID"];



             NSDate *beginTime = [NSDate dateByParsingJSString:startCondition[@"startDate"]];
             float duration = ((NSString *)dictionary[@"duration"]).intValue;
             NSDate *endTime = [beginTime dateByAddingTimeInterval:duration * 60];
             _dateInterval = [EADateInterval dateIntervalFrom:beginTime to:endTime];

             completionBlock(self);

             _timeLeft = _dateInterval.timeInterval;
         }];
    }
    return self;
}

- (void)stringToStatus:(NSString *)string {
    if ([string isEqualToString:@"start"])
        self.status = EATaskStatusWorking;
    else if ([string isEqualToString:@"waiting"])
        self.status = EATaskStatusWaiting;
    else if ([string isEqualToString:@"pending"])
        self.status = EATaskStatusPending;
    else if ([string isEqualToString:@"finish"])
        self.status = EATaskStatusFinished;
}

#pragma mark - Methods

- (void)updateWithTask:(EATask *)task {
    _dateInterval = task.dateInterval;
    _status       = task.status;
}

- (void)updateWithFeedback:(NSDictionary *)feedback {
    if (feedback[@"status"])
        [self stringToStatus:feedback[@"status"]];

    if (feedback[@"timeLeft"])
        _timeLeft = ((NSNumber *)feedback[@"timeLeft"]).intValue;
}

#pragma mark - Attributes

- (EAMetaTask *)metatask {
    return [self.workflow.metaworkflow metataskWithID:self.metataskID];
}

- (float)completionPercentage {
    return 1 - self.timeLeft / self.dateInterval.timeInterval;
}

@end
