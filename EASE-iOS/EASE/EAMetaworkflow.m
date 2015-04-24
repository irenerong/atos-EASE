//
//  EAMetaworkflow.m
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAMetaworkflow.h"

@implementation EAMetaworkflow

#pragma mark - Init
+ (instancetype)metaworkflowByParsingDictionary:(NSDictionary *)dictionary {
    return [[EAMetaworkflow alloc] initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.metaworkflowID = ((NSNumber *)dictionary[@"id"]).intValue;
        self.title          = dictionary[@"title"];

        if (dictionary[@"image"] && ![dictionary[@"image"] isKindOfClass:[NSNull class]])
            self.imageURL = [NSURL URLWithString:dictionary[@"image"]];



        self.ingredients = [NSMutableArray array];

        for (NSDictionary *ing in  dictionary[@"ingredient"]) {
            EAIngredient *ingredient = [EAIngredient ingredientWithDictionary:ing];


            [self.ingredients addObject:ingredient];
        }
        self.metatasks = [NSMutableArray array];

        for (NSDictionary *mt in  dictionary[@"metatasks"]) {
            EAMetaTask *metatask = [EAMetaTask metataskWithDictionary:mt];
            metatask.metaworkflow = self;

            [self.metatasks addObject:metatask];
        }
    }

    return self;
}

#pragma mark - Methods

- (EAMetaTask *)metataskWithID:(int)metataskID {
    EAMetaTask *metatask;

    for (EAMetaTask *mt in self.metatasks) {
        if (mt.metataskID == metataskID) {
            metatask = mt;
            break;
        }
    }

    return metatask;
}

@end
