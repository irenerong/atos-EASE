//
//  EAPendingTasksViewController.m
//  EASE
//
//  Created by Aladin TALEB on 05/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAPendingTasksViewController.h"

@interface EAPendingTasksViewController ()

@property(nonatomic, strong) NSMutableArray *pendingTasks;

@end

@implementation EAPendingTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pendingTaskUpdate:) name:EATaskUpdate object:nil];
    
    // Do any additional setup after loading the view.
    self.actionsCollectionView.alpha = 0;
    
    
    [[EANetworkingHelper sharedHelper] getPendingTasksCompletionBlock:^(EASearchResults *searchResults, NSError *error) {
       
        self.searchResults = searchResults;
        self.pendingTasks= [NSMutableArray array];
        
        for (EAWorkflow *workflow in self.searchResults.workflows)
            [self.pendingTasks addObjectsFromArray:workflow.pendingTasks];
        
        
        
        [self.actionsCollectionView reloadData];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.actionsCollectionView.alpha = 1;
        }];
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {
   
    [self.actionsCollectionView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(EATaskCollectionViewCell*)cell {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 

     
 EATaskInfoViewController *vc = segue.destinationViewController;
 vc.task = cell.task;
 
 MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
 
 MZFormSheetController *formSheet = formSheetSegue.formSheetController;
 formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
 formSheet.cornerRadius = 0;
 formSheet.shouldCenterVertically = true;
 
 CGSize screenSize = [UIScreen mainScreen].bounds.size;
 
 formSheet.presentedFormSheetSize = CGSizeMake(screenSize.width-50, screenSize.height-100);
 
 
 
 formSheet.shouldDismissOnBackgroundViewTap = YES;
 
 formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
 
     [self.actionsCollectionView reloadData];
 
 };
 }
 
 
 #pragma mark - Notifications Update
 
-(void)pendingTaskUpdate:(NSNotification*)notification {

    
    int taskID = ((NSNumber*)notification.userInfo[@"id"]).intValue;
    
    [self.searchResults updateTaskWithFeedback:notification.userInfo completion:^{
        
        
        NSMutableArray *newPendingTasks = [NSMutableArray array];
        
        for (EAWorkflow *workflow in self.searchResults.workflows)
            [newPendingTasks addObjectsFromArray:workflow.pendingTasks];
        
       
        NSMutableArray *insertedIndexPaths = [NSMutableArray array];
        NSMutableArray *deletedIndexPaths = [NSMutableArray array];
        NSMutableArray *updatedIndexPaths = [NSMutableArray array];

        for (int i = 0; i < self.pendingTasks.count; i++)
        {
            EAWorkflow *w = self.pendingTasks[i];
            
            if (![newPendingTasks containsObject:w])
                [deletedIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            
        }
        
        for (int i = 0; i < newPendingTasks.count; i++)
        {
            EAWorkflow *w = newPendingTasks[i];
            
            if (![self.pendingTasks containsObject:w])
                [insertedIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
            else
                [updatedIndexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];

        }
        
        
        self.pendingTasks = newPendingTasks;
        
        [self.actionsCollectionView performBatchUpdates:^{
           
            [self.actionsCollectionView insertItemsAtIndexPaths:insertedIndexPaths];
            [self.actionsCollectionView deleteItemsAtIndexPaths:deletedIndexPaths];
            [self.actionsCollectionView reloadItemsAtIndexPaths:updatedIndexPaths];
            
        } completion:^(BOOL finished) {
            
        }];
        
        
       

    }];

    

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.pendingTasks.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EATaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    
    cell.task = self.pendingTasks[indexPath.row];
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TaskInfos" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}






@end
