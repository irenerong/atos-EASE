//
//  EANotificationsViewController.m
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EATasksViewController.h"

@interface EATasksViewController ()

@property(nonatomic, retain) EASearchResults *searchResults;
@property(nonatomic, strong) NSMutableArray *tasks;

@end

@implementation EATasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:245/255. alpha:1.];
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 54, 0);

    [self.collectionView registerNib:[UINib nibWithNibName:@"EATaskCell" bundle:nil] forCellWithReuseIdentifier:@"TaskCell"];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTask:) name:EATaskUpdate object:nil];
    
    [[EANetworkingHelper sharedHelper] getPendingAndWorkingTasksCompletionBlock:^(EASearchResults *searchResults, NSError *error) {
       
        self.searchResults = searchResults;
        
        _tasks = [NSMutableArray array];
        
        for (EAWorkflow *workflow in self.searchResults.workflows)
        {
            [_tasks addObjectsFromArray:workflow.pendingTasks];
            [_tasks addObjectsFromArray:workflow.workingTasks];
        }
        
        
        [self.collectionView reloadData];
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    int index = ((NSIndexPath*)self.collectionView.indexPathsForSelectedItems.firstObject).row;
    
    EATask *task = self.tasks[index];
    
    
    MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
    
    MZFormSheetController *formSheet = formSheetSegue.formSheetController;
    
    ((EATaskInfoViewController*)formSheet.presentedFSViewController).task = task;
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
    formSheet.cornerRadius = 0;
    formSheet.shouldCenterVertically = true;
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    formSheet.presentedFormSheetSize = CGSizeMake(screenSize.width-50, screenSize.height-100);
    
    
    
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    
    formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
        
        
    };


    
}

#pragma mark - UICollectionViewDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(collectionView.frame.size.width-20, 93);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TaskInfos" sender:self];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:false];
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    
    if (self.tasks)
    return self.tasks.count;
    
    
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EATaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    cell.task = self.tasks[indexPath.row];
    
    return cell;
    
}


-(void)updateTask:(NSNotification*)notification
{
    
    [self.searchResults updateTaskWithFeedback:notification.userInfo completion:^{
       
        
        _tasks = [NSMutableArray array];
        
        for (EAWorkflow *workflow in self.searchResults.workflows)
        {
            [_tasks addObjectsFromArray:workflow.pendingTasks];
            [_tasks addObjectsFromArray:workflow.workingTasks];
        }
        
        [self.collectionView reloadData];
        
    }];
    
}

@end
