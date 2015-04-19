//
//  NSMutableArray+Flags.h
//  EASE
//
//  Created by Aladin TALEB on 12/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Flags)

-(instancetype)initWithFlags:(int)numberOfFlags;

-(BOOL)allFlagsRaised;
-(void)raiseFlag:(int)index;

@end
