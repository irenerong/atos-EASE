//
//  EAWorkflow.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflow.h"

#import "EATask.h"

@implementation EAWorkflow

#pragma mark - Init

+ (instancetype)workflowByParsingGeneratorDictionary:(NSDictionary *)dictionary {
    return [[EAWorkflow alloc] initWithGeneratorDictionary:dictionary];
}

+ (instancetype)workflowByParsingSearchDictionary:(NSDictionary *)dictionary completion:(void (^)(EAWorkflow *))completionBlock {
    return [[EAWorkflow alloc] initWithSearchDictionary:dictionary completion:^(EAWorkflow *workflow) {
                completionBlock(workflow);
            }];
}

- (instancetype)initWithGeneratorDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        if (![dictionary isKindOfClass:[NSDictionary class]])
            return nil;

        self.isValidated = false;


        NSArray *tasks = dictionary[@"subtasks"];
        self.colorIndex = ((NSNumber *)dictionary[@"color"]).intValue;

        NSMutableArray *parsedTasks = [NSMutableArray array];

        for (NSDictionary *taskDic in tasks) {
            EATask *task = [EATask taskByParsingGeneratorDictionary:taskDic fromWorkflow:self];
            [parsedTasks addObject:task];
        }

        _tasks = parsedTasks;
    }

    return self;
}

- (instancetype)initWithSearchDictionary:(NSDictionary *)dictionary completion:(void (^)(EAWorkflow *))completionBlock {
    if (self = [super init]) {
        if (![dictionary isKindOfClass:[NSDictionary class]])
            return nil;
        self.isValidated = true;
        self.workflowID  = ((NSNumber *)dictionary[@"id"]).intValue;
        self.colorIndex  = 0;

        if (![dictionary[@"color"] isKindOfClass:[NSNull class]])
            self.colorIndex = ((NSNumber *)dictionary[@"color"]).intValue;

        NSArray *tasks = dictionary[@"subtasks"];

        NSMutableArray *parsedTasks = [NSMutableArray array];

        dispatch_group_t group = dispatch_group_create();
        for (int i = 0; i < tasks.count; i++) {
            NSDictionary *taskDic = tasks[i];
            dispatch_group_enter(group);
            [EATask taskByParsingSearchDictionary:taskDic fromWorkflow:self completion:^(EATask *task) {
                 [parsedTasks addObject:task];
                 dispatch_group_leave(group);
             }];
        }

        _tasks = parsedTasks;


        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            completionBlock(self);
        });
    }

    return self;
}

#pragma mark - Methods

- (void)updateWithWorkflow:(EAWorkflow *)workflow {
    _isValidated = workflow.isValidated;
    _title       = workflow.title;

    for (EATask *task in workflow.tasks) {
        NSUInteger indexTask = [_tasks indexOfObjectPassingTest:^BOOL (EATask *t, NSUInteger idx, BOOL *stop) {
                                    return task.taskID == t.taskID;
                                }];


        if (indexTask == NSNotFound) {
            [self.tasks addObject:task];
        } else {
            [((EATask *)self.tasks[indexTask]) updateWithTask:task];
        }
    }
}

#pragma mark - Attributes

- (int)availableAgents {
    return self.agents.count;
}

- (int)availableUsers {
    return self.users.count;
}

- (int)availableIngredients {
    int available = 0;

    for (EAIngredient *ing in self.ingredients)
        available += ing.available;

    return available;
}

- (EADateInterval *)dateInterval {
    if (!self.tasks.count)
        return nil;

    EATask *firstTask = self.tasks.firstObject;

    NSDate *start = firstTask.dateInterval.startDate;
    NSDate *end   = firstTask.dateInterval.endDate;

    for (EATask *task in self.tasks) {
        if ([task.dateInterval.startDate compare:start] == NSOrderedAscending)
            start = task.dateInterval.startDate;

        if ([task.dateInterval.endDate compare:end] == NSOrderedDescending)
            end = task.dateInterval.endDate;
    }


    EADateInterval *dateInterval = [[EADateInterval alloc] init];
    dateInterval.startDate = start;
    dateInterval.endDate   = end;

    return dateInterval;
}

- (NSString *)title {
    return self.metaworkflow.title;
}

- (NSArray *)tasksAtDate:(NSDate *)date {
    NSCalendar       *cal        = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay) fromDate:date];



    NSDate         *beginning    = [cal dateFromComponents:components];
    NSDate         *tomorrow     = [beginning dateByAddingTimeInterval:24 * 3600];
    EADateInterval *dateInterval = [EADateInterval dateIntervalFrom:beginning to:tomorrow];

    return [self.tasks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (EATask *task, NSDictionary *bindings) {
                                                        return [task.dateInterval intersects:dateInterval];
                                                    }]];
}

- (NSArray *)pendingTasks {
    NSMutableArray *array = [NSMutableArray array];

    for (EATask *task in self.tasks)
        if (task.status == EATaskStatusPending)
            [array addObject:task];

    return array;
}

- (NSArray *)workingTasks {
    NSMutableArray *array = [NSMutableArray array];

    for (EATask *task in self.tasks)
        if (task.status == EATaskStatusWorking)
            [array addObject:task];

    return array;
}

- (NSArray *)agents {
    NSMutableArray *agents = [NSMutableArray array];

    for (EATask *task in self.tasks) {
        if (![task.agent.type isEqualToString:@"user"] && ![agents containsObject:task.agent])
            [agents addObject:task.agent];
    }

    return agents;
}

- (NSArray *)users {
    NSMutableArray *agents = [NSMutableArray array];

    for (EATask *task in self.tasks) {
        if ([task.agent.type isEqualToString:@"user"] && ![agents containsObject:task.agent])
            [agents addObject:task.agent];
    }

    return agents;
}

- (NSArray *)ingredients {
    return self.metaworkflow.ingredients;
}

- (NSDictionary *)consumption {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    for (EATask *task in self.tasks) {
        for (NSString *key in task.consumption.allKeys) {
            if (!dic[key])
                dic[key] = task.consumption[key];

            else
                dic[key] = @(((NSNumber *)dic[key]).intValue + ((NSNumber *)task.consumption[key]).intValue);
        }
    }

    [dic removeObjectForKey:@"time"];
    dic[@"time"] = @(self.dateInterval.timeInterval);

    return dic;
}

- (UIColor *)color {
    return [EANetworkingHelper sharedHelper].colors[self.colorIndex];
}

@end
