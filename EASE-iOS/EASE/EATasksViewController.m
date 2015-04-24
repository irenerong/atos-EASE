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
@property(nonatomic, strong) NSMutableArray *dates;

@end

@implementation EATasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:245/255. alpha:1.];
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 54, 0);

    [self.collectionView registerNib:[UINib nibWithNibName:@"EATaskCell" bundle:nil] forCellWithReuseIdentifier:@"TaskCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EATaskHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTask:) name:EATaskUpdate object:nil];
    
    [[EANetworkingHelper sharedHelper] getPendingAndWorkingTasksCompletionBlock:^(EASearchResults *searchResults, NSError *error) {
       
        self.searchResults = searchResults;
        [self updateArray];

        
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
    int section = ((NSIndexPath*)self.collectionView.indexPathsForSelectedItems.firstObject).section;

    EATask *task = self.tasks[section][index];
    
    
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
    
    return CGSizeMake(collectionView.frame.size.width-20, 100);
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.frame.size.width, 50);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"TaskInfos" sender:self];
    
    [self.collectionView deselectItemAtIndexPath:indexPath animated:false];
    
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dates.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    
    if (self.tasks)
    return ((NSArray*)self.tasks[section]).count;
    
    
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    
    
   UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:@"header"
                                                                                   forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:245/255. alpha:1.];
    
    
    UILabel *label = [cell viewWithTag:1];
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateStyle = NSDateFormatterLongStyle;
    
    label.text = [df stringFromDate:self.dates[indexPath.section]];
    
            return cell;

    

    
    

}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    EATaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
    
    cell.task = self.tasks[indexPath.section][indexPath.row];
    
    return cell;
    
}


-(void)updateTask:(NSNotification*)notification
{
    
    [self.searchResults updateTaskWithFeedback:notification.userInfo completion:^{
       
        
        [self updateArray];
        
        [self.collectionView reloadData];
        
    }];
    
}

-(void)updateArray
{
    
    NSMutableArray *tasksArray = [NSMutableArray array];
    
    for (EAWorkflow *workflow in self.searchResults.workflows)
    {
        [tasksArray addObjectsFromArray:workflow.pendingTasks];
        [tasksArray addObjectsFromArray:workflow.workingTasks];
    }
    
    [tasksArray sortUsingComparator:^NSComparisonResult(EATask* obj1, EATask* obj2) {
     
        return [obj1.dateInterval.startDate compare:obj2.dateInterval.startDate];
        
    }];
    
    
    self.dates = [NSMutableArray array];
    self.tasks = [NSMutableArray array];
    
    for (EATask *task in tasksArray)
    {
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:( NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay ) fromDate:task.dateInterval.startDate];
        

        
        NSDate *beginningOfDay = [cal dateFromComponents:components];
        
        int i;
        for (i = 0; i < _dates.count; i++)
        {
            NSDate *date = _dates[i];
            
            NSComparisonResult compare = [date compare:beginningOfDay];
            
            if (compare == NSOrderedSame)
            {
                [((NSMutableArray*)self.tasks[i]) addObject:task];
                
                break;
            }
            else if (compare == NSOrderedDescending)
            {
                [self.tasks insertObject:[NSMutableArray arrayWithObject:task] atIndex:i];
                [self.dates addObject:beginningOfDay];

                break;
            }
        }
        
        if (i == _dates.count)
        {
            [self.tasks addObject:[NSMutableArray arrayWithObject:task] ];
            [self.dates addObject:beginningOfDay];

        }
        
        
        
        
    }
    
    


}

@end
