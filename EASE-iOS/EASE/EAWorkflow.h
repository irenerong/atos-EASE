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

+(instancetype)workflowByParsingGeneratorDictionary:(NSDictionary*)dictionary;
+(instancetype)workflowByParsingSearchDictionary:(NSDictionary*)dictionary completion:(void (^) (EAWorkflow *workflow))completionBlock;
-(instancetype)initWithGeneratorDictionary:(NSDictionary*)dictionary;
-(instancetype)initWithSearchDictionary:(NSDictionary*)dictionary completion:(void (^) (EAWorkflow *workflow))completionBlock;

@property(nonatomic, weak) EAMetaworkflow *metaworkflow;

@property(nonatomic, readwrite) BOOL isValidated;

@property(nonatomic, readwrite) int workflowID;

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, strong) NSString *sortTag;

@property(nonatomic, strong) NSArray *tasks;

@property(nonatomic, strong) UIColor *color;

@property(nonatomic, strong) NSArray *ingredients;
@property(nonatomic, strong) NSArray *agents;

-(NSArray*)tasksAtDate:(NSDate*)date;

-(int)availableIngredients;
-(int)availableAgents;

-(EADateInterval*)dateInterval;

@end
