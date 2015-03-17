//
//  EAWorkflow.h
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EAWorkflow : NSObject
{
    
}

@property(nonatomic, readwrite) int workflowiD;

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *sortTag;

@property(nonatomic, strong) NSArray *tasks;

@property(nonatomic, strong) NSURL *imageURL;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIColor *color;



-(NSArray*)ingredients;
-(NSArray*)agents;

@end
