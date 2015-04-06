//
//  EAIngredient.h
//  EASE
//
//  Created by Aladin TALEB on 29/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAIngredient : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *quantity;
@property(nonatomic, readwrite) BOOL available;

@end
