//
//  EANotification.h
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EATask.h"

@interface EANotification : NSObject

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, weak) EATask *task;

@property(nonatomic, strong) NSString *status;
@property(nonatomic, readwrite) float completionPercentage;



@property(nonatomic, strong) id color;

@end
