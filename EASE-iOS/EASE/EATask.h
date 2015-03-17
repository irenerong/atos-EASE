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


@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *taskDescription;
@property(nonatomic, strong) EADateInterval *dateInterval;

@property(nonatomic, weak) EAAgent *agent;
@property(nonatomic, weak) EAWorkflow *workflow;

@end
