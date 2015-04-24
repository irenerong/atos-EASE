//
//  ViewController.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflowViewController.h"

#import "MBPullDownController.h"

@interface EAWorkflowViewController ()





@end

@implementation EAWorkflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"Workflow";

    ((EACollectionViewWorkflowLayout*)self.collectionView.collectionViewLayout).delegate = self;
    ((EACollectionViewWorkflowLayout*)self.collectionView.collectionViewLayout).minHeight = 130;

    ((EACollectionViewWorkflowLayout*)self.collectionView.collectionViewLayout).maxHeight = 160;
    ((EACollectionViewWorkflowLayout*)self.collectionView.collectionViewLayout).itemWidth = 200;
    ((EACollectionViewWorkflowLayout*)self.collectionView.collectionViewLayout).emptyHeight = 30;


    self.collectionView.contentInset = UIEdgeInsetsMake(0, 72, 0, 10);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 67, 0, 0);
    self.dateScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    
    ((EACollectionViewWorkflowLayout*)self.collectionView.collectionViewLayout).cellInset = CGSizeMake(5, 5);

    
    self.dateScrollView = [[EAWorkflowDateScrollView alloc] initWithFrame:CGRectMake(self.collectionView.contentOffset.x, 0, 67, self.collectionView.frame.size.height)];
    
    
    [self.collectionView addSubview:self.dateScrollView];
    
    self.dateScrollView.color = self.workflow.color;
    
    
    if (_workflow)
    self.workflow = _workflow;
}

-(void)setWorkflow:(EAWorkflow *)workflow
{
    _workflow = workflow;
    
    if (self.isViewLoaded)
    {
        [self.collectionView reloadData];
        self.dateScrollView.color = self.workflow.color;

    }
    
    

}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(EAWorkflowTaskCollectionViewCell*)cell {
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
        
        
    };
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (!self.workflow)
        return 0;
    return self.workflow.tasks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EAWorkflowTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
   
    cell.task = self.workflow.tasks[indexPath.row];
    cell.color = self.workflow.color;
    
    return cell;
    
}

#pragma mark - EACollectionViewWorkflowLayoutDelegate

-(EADateInterval*)collectionView:(UICollectionView *)collectionView workflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout askForDateIntervalOfTaskAtIndexPath:(NSIndexPath *)indexPath
{
    return ((EATask*)self.workflow.tasks[indexPath.row]).dateInterval;
}


-(void)collectionView:(UICollectionView *)collectionView didUpdateAnchorsForWorkflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout
{
    if (self.workflow)
    {
        [self.dateScrollView updateScrollViewWithTimeAnchorsDate:workflowLayout.timeAnchorsDate andTimeAnchorsY:workflowLayout.timeAnchorsY];
        [self scrollViewDidScroll:self.collectionView];
    }
    
}

#pragma mark - UICollectionViewDelegate


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    self.dateScrollView.frame = CGRectMake(scrollView.contentOffset.x, -10, 67, MAX(self.collectionView.contentSize.height, self.collectionView.frame.size.height)+20);
    self.dateScrollView.contentOffset = CGPointMake(0, -10);
    
    
    if (self.pullDownController)
    {
        
    
    
    EAWorkflowInfosViewController *infosViewController = self.pullDownController.backController;
    
    CGFloat topOffset = self.pullDownController.closedTopOffset;
    
    CGFloat offsetY = MAX( 0.5*(self.collectionView.contentOffset.y+topOffset-64)-32, -64);
    

    
    infosViewController.scrollView.contentOffset = CGPointMake(0, offsetY);
    
    UIImageView *imageView = infosViewController.imageView;
    
    CGFloat bottomYofImage = imageView.frame.origin.y+imageView.frame.size.height;
    
    CGFloat topYofImage = offsetY;
    CGFloat heightOfImage = MAX(bottomYofImage-topYofImage, 0);
    
    }
    
}


@end
