//
//  EASearchResults.h
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAWorkflow.h"

@interface EASearchResults : NSObject

+(instancetype)searchResultsByParsingDictionary:(NSDictionary*)dictionary;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;


@property(nonatomic, strong) NSArray *workflows;

@end
