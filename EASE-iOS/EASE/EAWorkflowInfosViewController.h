//
//  EAWorkflowInfosViewController.h
//  EASE
//
//  Created by Aladin TALEB on 09/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MarqueeLabel.h"
#import "EAWorkflow.h"

#import "UIImageView+XLProgressIndicator.h"

@interface EAWorkflowInfosViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property(nonatomic, weak) EAWorkflow *workflow;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MarqueeLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *infosCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsNumberLabel;
@property (weak, nonatomic) IBOutlet UITableView *ingredientsTableView;
@property (weak, nonatomic) IBOutlet UITableView *agentsTableView;
@property (weak, nonatomic) IBOutlet UILabel *agentsNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;



@end
