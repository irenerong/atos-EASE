//
//  EAWorkflow.h
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "EAIngredient.h"
#import "EAAgent.h"

#import "EADateInterval.h"
#import "EAMetaworkflow.h"

@interface EAWorkflow : NSObject
{
    
}

+(instancetype)workflowByParsingDictionary:(NSDictionary*)dictionary;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property(nonatomic, strong) EAMetaworkflow *metaworkflow;

@property(nonatomic, readwrite) int workflowID;

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, strong) NSString *sortTag;

@property(nonatomic, strong) NSArray *tasks;

@property(nonatomic, strong) NSURL *imageURL;
@property(nonatomic, strong) UIColor *color;

@property(nonatomic, strong) NSArray *ingredients;
@property(nonatomic, strong) NSArray *agents;

-(int)availableIngredients;
-(int)availableAgents;

-(EADateInterval*)dateInterval;

@end
