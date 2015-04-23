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
        self.imageURL = [NSURL URLWithString: @"http://img1.mxstatic.com/wallpapers/331df9b319e98e3f5a18873d7093dcba_large.jpeg"];

        
        
        self.ingredients = [NSMutableArray array];
        
        for (NSDictionary *ing in  dictionary[@"ingredient"])
        {
            
            EAIngredient *ingredient = [EAIngredient ingredientWithDictionary:ing];
            
                      
            [self.ingredients addObject:ingredient];
            
        }
        self.metatasks = [NSMutableArray array];

        for (NSDictionary *mt in  dictionary[@"metatasks"])
        {
            
            EAMetaTask *metatask = [EAMetaTask metataskWithDictionary:mt];
            metatask.metaworkflow = self;
            
            [self.metatasks addObject:metatask];
            
        }
        
    }
    
    return self;
    
}

-(EAMetaTask*)metataskWithID:(int)metataskID
{
    EAMetaTask *metatask;
    
    for (EAMetaTask *mt in self.metatasks)
    {
        if (mt.metataskID == metataskID)
        {
            metatask = mt;
            break;
        }
    }
    
    return metatask;
}

@end
