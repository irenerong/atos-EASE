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

-(void)updateWithWorkflow:(EAWorkflow*)workflow;

@property(nonatomic, weak) EAMetaworkflow *metaworkflow;

@property(nonatomic, readwrite) BOOL isValidated;

@property(nonatomic, readwrite) int workflowID;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *sortTag;

@property(nonatomic, strong) NSMutableArray *tasks;

@property(nonatomic, readwrite) int colorIndex;


-(UIColor*)color;

-(NSDictionary*)consumption;

-(NSArray*)tasksAtDate:(NSDate*)date;
-(NSArray*)pendingTasks;
-(NSArray*)workingTasks;
-(NSArray*)agents;
-(NSArray*)users;
-(NSArray*)ingredients;

-(int)availableAgents;
-(int)availableUsers;
-(int)availableIngredients;

-(EADateInterval*)dateInterval;



@end
