//
//  EAIngredient.h
//  EASE
//
//  Created by Aladin TALEB on 29/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EANetworkingHelper.h"

@interface EAIngredient : NSObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, readwrite) float quantity;
@property(nonatomic, strong) NSString *unit;

+(EAIngredient*)ingredientWithDictionary:(NSDictionary*)dic;
-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(BOOL)available;
-(BOOL)ingredientIsAvailable:(EAIngredient*)ingredient;

@end
