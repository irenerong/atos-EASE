//
//  EAMetaworkflow.m
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAMetaworkflow.h"

@implementation EAMetaworkflow


+(instancetype)metaworkflowByParsingDictionary:(NSDictionary*)dictionary
{
    
    return [[EAMetaworkflow alloc] initWithDictionary:dictionary];
}
-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{

    if (self = [super init])
    {
        self.title = dictionary[@"title"];
        
    }
    
    return self;
    
}

@end
