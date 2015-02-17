//
//  EACollectionViewWorkflowLayout.h
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EADateInterval.h"

@class EACollectionViewWorkflowLayout;

@protocol EACollectionViewWorkflowLayoutDelegate <UICollectionViewDelegate>

-(EADateInterval*)collectionView:(UICollectionView*)collectionView workflowLayout:(EACollectionViewWorkflowLayout*)workflowLayout askForDateIntervalOfTaskAtIndexPath:(NSIndexPath*)indexPath;


-(void)collectionView:(UICollectionView*)collectionView didUpdateAnchorsForWorkflowLayout:(EACollectionViewWorkflowLayout*)workflowLayout;

@end

@interface EACollectionViewWorkflowLayout : UICollectionViewLayout


@property(nonatomic, weak) id <EACollectionViewWorkflowLayoutDelegate> delegate;
@property(nonatomic, readwrite) CGFloat itemWidth;


@property(nonatomic, strong) NSMutableArray *timeAnchorsY;
@property(nonatomic, strong) NSMutableArray *timeAnchorsDate;


@end
