//
//  EAPendingTasksViewController.m
//  EASE
//
//  Created by Aladin TALEB on 05/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAPendingTasksViewController.h"

@interface EAPendingTasksViewController ()

@end

@implementation EAPendingTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBarItem.badgeValue = @"100";
    

}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pendingTasksDidAdd) name:EAPendingTaskAdd object:nil];
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
 
     [[NSNotificationCenter defaultCenter] removeObserver:self];

     
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
 
 
 #pragma mark - Notifications Update
 
 -(void)pendingTasksDidAdd {
 [self.actionsCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[EANetworkingHelper sharedHelper].pendingTasks.count-1 inSection:0]]];
 }

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    

    return [EANetworkingHelper sharedHelper].pendingTasks.count;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EATaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    
    cell.taskNotification = [EANetworkingHelper sharedHelper].pendingTasks[indexPath.row];
    cell.delegate = self;
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TaskInfos" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

#pragma mark - EATaskCellDelegate

- (void) taskCellDidTapCenterButton:(EATaskCollectionViewCell *)cell
{
    NSIndexPath *path = [self.actionsCollectionView indexPathForCell:cell];
    
    EAPendingTask *pendingTask = cell.taskNotification;
    
    if (!pendingTask.alertMessage) {
        [[EANetworkingHelper sharedHelper] startPendingTask:pendingTask completionBlock:^(BOOL ok, EAWorkingTask *workingTask) {
            if (ok) {
                [self.actionsCollectionView deleteItemsAtIndexPaths:@[path]];
                
            }
        }];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.showAnimationType = SlideInFromCenter;
        alert.backgroundType = Blur;
        alert.customViewColor = [UIColor colorWithWhite:200/255. alpha:1.0];
        alert.iconTintColor = [UIColor whiteColor];
        
        [alert addButton:@"Everything's ok ! Let's do it !" actionBlock:^{
            [[EANetworkingHelper sharedHelper] startPendingTask:pendingTask completionBlock:^(BOOL ok, EAWorkingTask *workingTask) {
                if (ok) {
                    [self.actionsCollectionView deleteItemsAtIndexPaths:@[path]];
                    
                }
            }];
        }];
        
        [alert showWarning:self.tabBarController.navigationController title:@"Warning" subTitle:pendingTask.alertMessage closeButtonTitle:@"Let me check ..." duration:0];
        
        
    }
    
    
    
    
    
    
}




@end
