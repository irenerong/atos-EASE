//
//  EATask.h
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EAWorkflow;
@class EADateInterval;
@class EAAgent;

@interface EATask : NSObject
{
    
}

+(instancetype)taskByParsingDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary fromWorkflow:(EAWorkflow*)workflow;

@property(nonatomic, readonly) int taskID;
@property(nonatomic, readonly) NSArray *predecessors;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *taskDescription;

@property(nonatomic, strong) EADateInterval *dateInterval;

@property(nonatomic, weak) EAAgent *agent;
@property(nonatomic, weak) EAWorkflow *workflow;

@end
