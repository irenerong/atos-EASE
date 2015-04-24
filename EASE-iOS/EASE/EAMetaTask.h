//
//  EAMetaTask.h
//  EASE
//
//  Created by Aladin TALEB on 23/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EAMetaworkflow;

@interface EAMetaTask : NSObject

@property(nonatomic, weak) EAMetaworkflow *metaworkflow;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, readwrite) int metataskID;
@property(nonatomic, readwrite) NSString* desc;
-(NSString*)htmlDescription;

+(EAMetaTask*)metataskWithDictionary:(NSDictionary*)dic;
-(instancetype)initWithDictionary:(NSDictionary*)dic;

@end
