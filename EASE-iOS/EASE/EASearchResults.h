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
@interface EASearchResults : NSObject

+(instancetype)searchResultsByParsingGeneratorDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;

+(instancetype)searchResultsByParsingSearchDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;

-(instancetype)initWithGeneratorDictionary:(NSDictionary*)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;
-(instancetype)initWithSearchDictionary:(NSDictionary *)dictionary completion:(void (^) (EASearchResults *searchResult))completionBlock;


@property(nonatomic, strong) NSArray *metaworkflows;
@property(nonatomic, strong) NSArray *workflows;


@end
