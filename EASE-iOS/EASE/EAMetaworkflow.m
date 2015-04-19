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
        
        self.metaworkflowID = ((NSNumber*)dictionary[@"id"]).intValue;
        self.title = dictionary[@"title"];
        //self.imageURL = dictionary[@"imageURL"];
        self.imageURL = [NSURL URLWithString: @"http://www.supermarchesmatch.fr/userfiles/images/Poulet%20au%20curry.jpg"];

        
        
    }
    
    return self;
    
}

@end
