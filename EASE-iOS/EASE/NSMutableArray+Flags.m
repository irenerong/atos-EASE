//
//  NSMutableArray+Flags.m
//  EASE
//
//  Created by Aladin TALEB on 12/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "NSMutableArray+Flags.h"

@implementation NSMutableArray (Flags)

-(instancetype)initWithFlags:(int)numberOfFlags
{
    if (self = [self init])
    {
        
        for (int i = 0; i < numberOfFlags; i++)
            [self addObject:@(false)];
        
    }
    
    return self;
}

-(BOOL)allFlagsRaised
{
    for (NSNumber *flag in self)
    {
        if (!flag.boolValue)
            return false;
    }
    
    return true;
}

-(void)raiseFlag:(int)index
{
    [self replaceObjectAtIndex:index withObject:@(true)];
}

@end
