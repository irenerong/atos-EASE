//
//  EANotificationsViewController.m
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EATasksViewController.h"

@interface EATasksViewController ()

@end

@implementation EATasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.actionsCollectionView.backgroundColor = [UIColor colorWithWhite:245/255. alpha:1.];
    self.actionsCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    self.actionsCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 54, 0);

    //[self.actionsCollectionView registerClass:[EATaskCollectionViewCell class] forCellWithReuseIdentifier:@"TaskCell"];
    [self.actionsCollectionView registerNib:[UINib nibWithNibName:@"EATaskCell" bundle:nil] forCellWithReuseIdentifier:@"TaskCell"];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [EANetworkingHelper sharedHelper].displayNotificationPopup = NO;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.actionsCollectionView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [EANetworkingHelper sharedHelper].displayNotificationPopup = YES;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.frame.size.width-20, 140);
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
   
    
    return 0;
    
}




@end
