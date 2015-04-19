//
//  EACalendarViewController.h
//  EASE
//
//  Created by Aladin TALEB on 08/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "EANetworkingHelper.h"
#import "EAWorkflow.h"
#import "EACollectionViewWorkflowLayout.h"
#import "EAWorkflowDateScrollView.h"
#import "EACalendarWorkflowCollectionViewCell.h"
#import "EACalendarTaskCollectionViewCell.h"

#import "EAWorkflowMasterViewController.h"
#import "JTCalendar.h"

#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"

#import "EASearchPopupViewController.h"
#import "EAWorkflowListCollectionViewController.h"

@interface EACalendarViewController : UIViewController <EACollectionViewWorkflowLayoutDelegate, JTCalendarDataSource, EASearchPopupDelegate, EAWorkflowListDelegate>
{
}

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, readwrite) BOOL displayWorkflow;


@property (weak, nonatomic) IBOutlet UILabel *nothingToDisplayLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *timelineCollectionView;
@property (weak, nonatomic) IBOutlet EAWorkflowDateScrollView *dateScrollView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *contentView;
@property(strong, nonatomic) JTCalendar *calendar;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *modeSwitchButton;

- (IBAction)createWorkflow:(id)sender;

- (IBAction)switchMode:(id)sender;

@end
