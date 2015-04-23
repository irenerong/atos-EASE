//
//  EAIngredient.m
//  EASE
//
//  Created by Aladin TALEB on 29/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAIngredient.h"

@implementation EAIngredient
+(EAIngredient*)ingredientWithDictionary:(NSDictionary*)dic
{
    
    return [[EAIngredient alloc] initWithDictionary:dic];
    
}

-(instancetype)initWithDictionary:(NSDictionary*)dic
{

    if (self= [super init])
    {
        self.name = dic[@"name"];
        self.quantity = ((NSNumber*)dic[@"quantity"]).floatValue;
        
        if (dic[@"unit"] && ![dic[@"unit"] isKindOfClass:[NSNull class]])
            self.unit = dic[@"unit"];
        else
            self.unit = @"";

    }
    return self;
    
}

-(BOOL)available
{
    
    EAIngredient *userIngredient;
    for (EAIngredient *ing in [EANetworkingHelper sharedHelper].currentUser.ingredients)
    {
        
        if ([ing.name isEqualToString:_name])
        {
            userIngredient = ing;
            break;
        }
    }
    
    return [self ingredientIsAvailable:userIngredient];
    
}

-(BOOL)ingredientIsAvailable:(EAIngredient*)ingredient
{
    if (!ingredient || ![ingredient.name isEqualToString:_name] || ![ingredient.unit isEqualToString:_unit])
    {
        return false;
    }
    

    return ingredient.quantity >= self.quantity;
    
    
}
@end
