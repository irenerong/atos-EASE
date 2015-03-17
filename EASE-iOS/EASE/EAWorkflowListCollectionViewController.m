//
//  EAWorkflowListCollectionViewController.m
//  EASE
//
//  Created by Aladin TALEB on 08/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflowListCollectionViewController.h"

#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"


@interface EAWorkflowListCollectionViewController ()

@end

@implementation EAWorkflowListCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    colors = @[[UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0], [UIColor colorWithRed:28/255.0 green:253/255.0 blue:171/255.0 alpha:1.0], [UIColor colorWithRed:252/255.0 green:200/255.0 blue:53/255.0 alpha:1.0], [UIColor colorWithRed:253/255.0 green:101/255.0 blue:107/255.0 alpha:1.0], [UIColor colorWithRed:254/255.0 green:100/255.0 blue:192/255.0 alpha:1.0]];
    
    
    
    seekingWorkflows = true;
    
    //    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    //    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2);
    //    self.navigationController.navigationBar.layer.shadowOpacity = 0.1;
    //    self.navigationController.navigationBar.layer.shadowRadius = 3;
    //    self.navigationController.navigationBar.layer.masksToBounds = false;
    //    self.navigationController.navigationBar.layer.shadowPath = CGPathCreateWithRect(self.navigationController.navigationBar.layer.bounds, NULL);
    
    //self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-Bold" size:20], NSFontAttributeName, nil];
    
    //self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:10/255.0 green:130/255.0 blue:88/255.0 alpha:1.0];
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:245/255. alpha:1.0];
    FRGWaterfallCollectionViewLayout *layout = self.collectionViewLayout;
    layout.delegate = self;
    
    
    
    layout.itemWidth = (self.view.frame.size.width-30)/2;
    
    layout.topInset = -10.0f;
    layout.bottomInset = 10.0f;
    layout.stickyHeader = YES;
    
    
    
      // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    seekingWorkflows = false;
}

-(void)setWorkflows:(NSArray *)workflows
{
    _workflows = workflows;
    if (self.isViewLoaded)
    {
        [self.collectionView reloadData];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    if ([segue.identifier isEqualToString:@"SortFilter"])
    {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
        
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.transitionStyle = MZFormSheetTransitionStyleDropDown;
        formSheet.cornerRadius = 8.0;
        formSheet.shouldCenterVertically = true;
        formSheet.presentedFormSheetSize = CGSizeMake(300, 300);
        
        
        
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        
        formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {
            
            NSLog(@"Dismiss");
            
        };
        
    }
    
}

-(void)pushWorkflow:(EAWorkflow*)workflow {
    
    EAWorkflowMasterViewController *workflowViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterInfo"];
    workflowViewController.workflow = workflow;
    [self.navigationController pushViewController:workflowViewController animated:true];
    
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.collectionView)
        return self.workflows.count;
    
    return 5;
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView)
    {
        EAWorkflowListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        // Configure the cell
        
        EAWorkflow *workflow = self.workflows[indexPath.row];
        workflow.color = colors[indexPath.row%5];
        
        cell.infosCollectionView.tag = indexPath.row;
        cell.workflow = workflow;
        cell.color =workflow.color;
        
        
        cell.imageView.progressIndicatorView.strokeProgressColor = workflow.color;
        cell.imageView.progressIndicatorView.strokeRemainingColor = [UIColor colorWithWhite:230/255.0 alpha:1.0];
        cell.imageView.progressIndicatorView.strokeWidth = 2;
        
        [cell.imageView setImageWithProgressIndicatorAndURL:workflow.imageURL];
        
        
        
        
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InfoCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [cell viewWithTag:2];
    imageView.image = [UIImage imageNamed:@"Hour"];
    
    UILabel *label = [cell viewWithTag:1];
    label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    label.textColor = [UIColor whiteColor];
    
    return cell;
}



#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EAWorkflow *workflow = self.workflows[indexPath.row];
    
    
    
    if (workflow.tasks.count) {
        [self pushWorkflow:workflow];
        
    }
    else
    {
        [[EANetworkingHelper sharedHelper] retrieveWorkflow:workflow completionBlock:^(NSError *error) {
            [self pushWorkflow:workflow];
            
        }];
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!seekingWorkflows && self.workflows.count < self.totalNumberOfWorkflows) {
        if (scrollView.contentOffset.y > scrollView.contentSize.height-scrollView.frame.size.height) {
            
            seekingWorkflows = true;
            
            [[EANetworkingHelper sharedHelper] searchWorklowsBetweenId:self.workflows.count andId:self.workflows.count completionBlock:^(NSArray *workflows, NSError *error) {
                
                int workflowsCount = self.workflows.count;
                self.workflows = [self.workflows arrayByAddingObjectsFromArray:workflows];
                
                [self.collectionView reloadData];
                seekingWorkflows = false;
                
            }];
        }
        
    }
}

#pragma mark - FRGWaterfallCollectionViewDelegate

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout
heightForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(FRGWaterfallCollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 250 + indexPath.row%3*50;
    
}

@end
