//
//  EAMetaworkflow.h
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EAIngredient.h"
#import "EAMetaTask.h"
@interface EAMetaworkflow : NSObject

+ (instancetype)metaworkflowByParsingDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (EAMetaTask *)metataskWithID:(int)metataskID;

@property (nonatomic, readwrite) int         metaworkflowID;
@property (nonatomic, strong) NSString       *title;
@property (nonatomic, strong) NSURL          *imageURL;
@property (nonatomic, strong) NSMutableArray *ingredients;
@property (nonatomic, strong) NSMutableArray *metatasks;


@end
