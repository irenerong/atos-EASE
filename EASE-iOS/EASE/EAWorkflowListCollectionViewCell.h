//
//  EAWorkflowListCollectionViewCell.h
//  EASE
//
//  Created by Aladin TALEB on 08/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAWorkflow.h"

@interface EAWorkflowListCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *infosView;

@property (weak, nonatomic) IBOutlet UICollectionView *infosCollectionView;
@property (weak, nonatomic) IBOutlet UIView *sortInfosView;

@property(nonatomic, weak) EAWorkflow *workflow;


@property(nonatomic, weak) UIColor *color;

@end
