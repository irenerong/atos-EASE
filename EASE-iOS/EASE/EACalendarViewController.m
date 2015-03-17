//
//  EACalendarViewController.m
//  EASE
//
//  Created by Aladin TALEB on 08/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACalendarViewController.h"

@interface EACalendarViewController ()


@property(nonatomic, strong) NSMutableArray *tasks;

@end

@implementation EACalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ((EACollectionViewWorkflowLayout*)self.timelineCollectionView.collectionViewLayout).delegate = self;
    
    self.timelineCollectionView.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1.0];
    
    self.timelineCollectionView.contentInset = UIEdgeInsetsMake(10, 72, 10, 10);
    self.timelineCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 72, 0, 0);
    
    
    
    self.dateScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.dateScrollView.color = [UIColor colorWithWhite:150/255. alpha:1.0];
    
    self.tasks = [NSMutableArray array];
    
    self.date = [NSDate date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    [self.tasks removeAllObjects];
   
        [[EANetworkingHelper sharedHelper] tasksAtDay:date completionBlock:^(NSArray *tasks) {
            
            [self.tasks addObjectsFromArray:tasks];
            [self.timelineCollectionView reloadData];
            
         
                
            }];
  
   
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return self.tasks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.layer.masksToBounds = false;
    cell.layer.shadowColor = [UIColor colorWithWhite:210/255. alpha:1.0].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowOpacity = 0.9;
    cell.layer.shadowRadius = 1;
    
    
    return cell;
    
}

#pragma mark - EACollectionViewWorkflowLayoutDelegate

-(EADateInterval*)collectionView:(UICollectionView *)collectionView workflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout askForDateIntervalOfTaskAtIndexPath:(NSIndexPath *)indexPath
{
    return ((EATask*)self.tasks[indexPath.row]).dateInterval;
}


-(void)collectionView:(UICollectionView *)collectionView didUpdateAnchorsForWorkflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout
{
   [self.dateScrollView updateScrollViewWithTimeAnchorsDate:workflowLayout.timeAnchorsDate andTimeAnchorsY:workflowLayout.timeAnchorsY];
    [self scrollViewDidScroll:self.timelineCollectionView];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    self.dateScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    
}



@end
