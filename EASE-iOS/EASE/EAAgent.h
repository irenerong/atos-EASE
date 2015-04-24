//
//  EAAgent.h
//  EASE
//
//  Created by Aladin TALEB on 03/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EAAgent : NSObject

+ (EAAgent *)agentByParsingDictionary:(NSDictionary *)responseObject;
- (instancetype)initByParsingDictionary:(NSDictionary *)responseObject;

@property (nonatomic, readwrite) int   agentID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *name;

@end
