//
//  EAMetaworkflow.h
//  EASE
//
//  Created by Aladin TALEB on 06/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAMetaworkflow : NSObject

+(instancetype)metaworkflowByParsingDictionary:(NSDictionary*)dictionary;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property(nonatomic, readwrite) int metaworkflowID;

@property(nonatomic, strong) NSString *title;


@end
