//
//  EAWorkingTasksViewController.m
//  EASE
//
//  Created by Aladin TALEB on 05/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkingTasksViewController.h"

@interface EAWorkingTasksViewController ()

@property(nonatomic, strong) NSMutableArray *workingTasks;


@end

@implementation EAWorkingTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workingTaskUpdate:) name:EATaskUpdate object:nil];

    
    self.actionsCollectionView.contentInset = UIEdgeInsetsMake(64, 0, 59, 0);
    self.actionsCollectionView.scrollIndicatorInsets =  UIEdgeInsetsMake(64, 0, 59, 0);
    
    self.actionsCollectionView.alpha = 0;

    [[EANetworkingHelper sharedHelper] getWorkingTasksCompletionBlock:^(EASearchResults *searchResults, NSError *error) {
        
        self.searchResults = searchResults;
        self.workingTasks= [NSMutableArray array];
        
        for (EAWorkflow *workflow in self.searchResults.workflows)
            [self.workingTasks addObjectsFromArray:workflow.workingTasks];
        
        
        [UIView animateWithDuration:0.3 animations:^{
            self.actionsCollectionView.alpha = 1;
        }];
        [self.actionsCollectionView reloadData];
        
    }];
    

}

-(void)viewWillAppear:(BOOL)animated {

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
        NSLog(@"Dismiss");
        
    };
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    
    return self.workingTasks.count;
    
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EATaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    
    cell.task = self.workingTasks[indexPath.row];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TaskInfos" sender:[collectionView cellForItemAtIndexPath:indexPath]];
}

-(void)workingTaskUpdate:(NSNotification*)notification {
    
    
    int taskID = ((NSNumber*)notification.userInfo[@"id"]).intValue;
    
    [self.searchResults updateTaskWithFeedback:notification.userInfo completion:^{
        
        
        self.workingTasks= [NSMutableArray array];
        
        for (EAWorkflow *workflow in self.searchResults.workflows)
            [self.workingTasks addObjectsFromArray:workflow.workingTasks];
        
        
        
        [self.actionsCollectionView reloadData];
    }];
    
    
    
}

#pragma mark - EATaskCellDelegate




@end
