//
//  EAWorkingTasksViewController.m
//  EASE
//
//  Created by Aladin TALEB on 05/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkingTasksViewController.h"

@interface EAWorkingTasksViewController ()

@end

@implementation EAWorkingTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarItem.badgeValue = @"10";

    
    self.actionsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 59, 0);
    self.actionsCollectionView.scrollIndicatorInsets =  UIEdgeInsetsMake(64, 0, 59, 0);
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workingTasksDidAdd) name:EAWorkingTaskAdd object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workingTaskUpdated:) name:EAWorkingTaskUpdate object:nil];

    [self.actionsCollectionView reloadData];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    vc.taskNotification = cell.taskNotification;
    
    MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
    
    MZFormSheetController *formSheet = formSheetSegue.formSheetController;
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 0;
    formSheet.shouldCenterVertically = true;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    formSheet.presentedFormSheetSize = CGSizeMake(screenSize.width-50, screenSize.height-100);
    
    
    
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    
    formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        NSLog(@"Dismiss");
        
    };
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    
    return [EANetworkingHelper sharedHelper].workingTasks.count;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EATaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    
    cell.taskNotification = [EANetworkingHelper sharedHelper].workingTasks[indexPath.row];
    cell.delegate = self;
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TaskInfos" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

-(void)workingTasksDidAdd
{
    [self.actionsCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[EANetworkingHelper sharedHelper].workingTasks.count-1 inSection:0]]];

}

-(void)workingTaskUpdated:(NSNotification*)notification
{
    int index = [[EANetworkingHelper sharedHelper].workingTasks indexOfObject:notification.userInfo[@"workingTask"]];
    if (index != -1)
        [self.actionsCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    
}

#pragma mark - EATaskCellDelegate

- (void) taskCellDidTapCenterButton:(EATaskCollectionViewCell *)cell
{
    NSIndexPath *path = [self.actionsCollectionView indexPathForCell:cell];
    
    EAWorkingTask *workingTask = cell.taskNotification;
    
        [[EANetworkingHelper sharedHelper] endWorkingTask:workingTask completionBlock:^(BOOL ok) {
            if (ok) {
                [self.actionsCollectionView deleteItemsAtIndexPaths:@[path]];
                
            }
        }];
    
  
    
    
    
    
    
}





@end
