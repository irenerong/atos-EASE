//
//  EAWorkflowDateScrollView.h
//  EASE
//
//  Created by Aladin TALEB on 04/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EAWorkflowDateScrollView : UIScrollView


- (void)updateScrollViewWithTimeAnchorsDate:(NSArray *)timeAnchorsDate andTimeAnchorsY:(NSArray *)timeAnchorsY;

@property(nonatomic, strong) UIColor *color;

@end
