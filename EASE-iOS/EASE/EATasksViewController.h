//
//  EANotificationsViewController.h
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZFormSheetSegue.h>
#import <SCLAlertView.h>

#import "EANetworkingHelper.h"
#import "EATaskCollectionViewCell.h"

@protocol EATasksViewControllerDelegates <NSObject, UICollectionViewDataSource, UICollectionViewDelegate>

@end

@interface EATasksViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet UICollectionView *actionsCollectionView;


@end
