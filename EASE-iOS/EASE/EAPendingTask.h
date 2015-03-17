//
//  EAPendingTask.h
//  EASE
//
//  Created by Aladin TALEB on 03/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EANotification.h"


@class EATask;

@interface EAPendingTask : EANotification



@property(nonatomic, strong) NSString *alertMessage;

@end
