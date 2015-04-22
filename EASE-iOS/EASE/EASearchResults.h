//
//  EASearchResults.h
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EANetworkingHelper.h"
#import "EAWorkflow.h"
#import "EAMetaworkflow.h"
#import "EATask.h"
@interface EASearchResults : NSObject

+(instancetype)searchResultsByParsingGeneratorDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;

+(instancetype)searchResultsByParsingSearchDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;

-(instancetype)initWithGeneratorDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;
-(instancetype)initWithSearchDictionary:(NSDictionary *)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;

-(void)updateWorkflowWithID:(int)workflowID completion:(void (^) () )completionBlock;
-(void)updateTaskWithID:(int)taskID completion:(void (^) () )completionBlock;

-(void)updateTaskWithFeedback:(NSDictionary*)feedback completion:(void (^) ())completionBlock;

@property(nonatomic, strong) NSMutableArray *metaworkflows;
@property(nonatomic, strong) NSMutableArray *workflows;
@property(nonatomic, strong) NSMutableArray *agents;

@property(nonatomic, strong) NSDictionary *constraints;


@end
