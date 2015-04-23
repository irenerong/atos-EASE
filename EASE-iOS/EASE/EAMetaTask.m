//
//  EAMetaTask.m
//  EASE
//
//  Created by Aladin TALEB on 23/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAMetaTask.h"
#import "EAMetaworkflow.h"

@implementation EAMetaTask

+(EAMetaTask*)metataskWithDictionary:(NSDictionary*)dic
{
    
    return [[EAMetaTask alloc] initWithDictionary:dic];
    
}

-(instancetype)initWithDictionary:(NSDictionary*)dic
{
    
    if (self= [super init])
    {
        
        self.name = @"";
        if (dic[@"name"] && ![dic[@"name"] isKindOfClass:[NSNull class]] )
        self.name = dic[@"name"];
        
        self.metataskID = ((NSNumber*)dic[@"id"]).intValue;
        self.desc = dic[@"description"];
    }
    return self;
    
}

@end
