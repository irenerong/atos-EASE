//
//  EAAgent.m
//  EASE
//
//  Created by Aladin TALEB on 03/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAAgent.h"

@implementation EAAgent

+(EAAgent*)agentByParsingDictionary:(NSDictionary*)responseObject
{
    return [[EAAgent alloc] initByParsingDictionary:responseObject];
}

-(instancetype)initByParsingDictionary:(NSDictionary*)responseObject
{
    if (self = [super init])
    {
        
        _agentID = ((NSNumber*)responseObject[@"id"]).intValue;
        _type = responseObject[@"agentType"];
        _name = responseObject[@"agentName"];

        
        
    }
    
    return self;
    
}

@end

