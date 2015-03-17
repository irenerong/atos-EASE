//
//  EACalendarViewController.h
//  EASE
//
//  Created by Aladin TALEB on 08/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EANetworkingHelper.h"
#import "EATask.h"
#import "EACollectionViewWorkflowLayout.h"
#import "EAWorkflowDateScrollView.h"
@interface EACalendarViewController : UIViewController <EACollectionViewWorkflowLayoutDelegate>
{
}

@property(nonatomic, strong) NSDate *date;



@property (weak, nonatomic) IBOutlet UICollectionView *timelineCollectionView;
@property (weak, nonatomic) IBOutlet EAWorkflowDateScrollView *dateScrollView;

@end
