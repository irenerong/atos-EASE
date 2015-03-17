//
//  EASearchTableViewController.m
//  EASE
//
//  Created by Aladin TALEB on 10/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EASearchTableViewController.h"


@interface EASearchTableViewController ()

@property(nonatomic, readwrite) BOOL firstDatePickerEnabled;
@property(nonatomic, readwrite) BOOL secondDatePickerEnabled;


@property(nonatomic, strong) NSString *intent;
@property(nonatomic, strong) NSString *search;

@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;


@end



@implementation EASearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.firstDatePickerEnabled = false;
    self.secondDatePickerEnabled = false;
    
    
    self.startDate = nil;
    self.endDate = nil;
    self.intent = @" ";
    
    self.tableView.contentInset = UIEdgeInsetsMake(44,0, 0, 0);
    self.searchBar.layer.masksToBounds = NO;
    
    self.searchBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.searchBar.layer.shadowOpacity = 0.1;
    self.searchBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.searchBar.layer.shadowRadius = 1;
    
    [self.view addSubview:self.searchBar];
    
    [self updateTableData];
    
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithWhite:132/255. alpha:1], NSForegroundColorAttributeName, nil];
    
    
    self.navigationController.navigationBar.barTintColor = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setConstraints:(NSDictionary*)constraints
{
    
    if (constraints[@"intent"])
    {
        self.intent = constraints[@"intent"];
    }
    
    if (constraints[@"search"])
    {
        self.search = constraints[@"search"];
    }
    if (constraints[@"fromDate"])
    {
        self.startDate = constraints[@"fromDate"];
    }
    
    if (constraints[@"toDate"])
    {
        self.endDate = constraints[@"toDate"];
        
    }
    
    
    [self updateTableDataAnimated:true];
}

-(void)updateTableData
{
    [self updateTableDataAnimated:NO];
}

-(void)updateTableDataAnimated:(BOOL)animated
{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    dateFormatter.doesRelativeDateFormatting = YES;
    
    [UIView transitionWithView:self.intentLabel duration:.5f*animated options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.intentLabel.text = self.intent;
    } completion:nil];
    
    
    
    [UIView transitionWithView:self.searchTextField duration:.5f*animated options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.searchTextField.text = self.search;
    } completion:nil];
    
    
    [UIView transitionWithView:self.startDateLabel duration:.5f*animated options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        if (!self.startDate)
            self.startDateLabel.text = @"Any";
        
        else
            self.startDateLabel.text = [dateFormatter stringFromDate:self.startDate];
    } completion:nil];
    
    
    [UIView transitionWithView:self.endDateLabel duration:.5f*animated options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        if (!self.endDate)
            self.endDateLabel.text = @"Any";
        
        else
            self.endDateLabel.text = [dateFormatter stringFromDate:self.endDate];
        
    } completion:nil];
    
    
    
    
    
    
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        if (!self.firstDatePickerEnabled)
            return 0;
        
        
    }
    
    if (indexPath.section == 1 && indexPath.row == 3)
    {
        if (!self.secondDatePickerEnabled)
            return 0;
        
        
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        self.firstDatePickerEnabled = !self.firstDatePickerEnabled;
        self.secondDatePickerEnabled = false;
        
        
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        self.secondDatePickerEnabled = !self.secondDatePickerEnabled;
        self.firstDatePickerEnabled = false;
        
        
    }
    
    else
    {
        self.firstDatePickerEnabled = false;
        self.secondDatePickerEnabled = false;
        
        
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    [self.tableView reloadData];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = 67;
    
    [scrollView bringSubviewToFront:self.searchBar];
    self.searchBar.frame = CGRectMake(0, scrollView.contentOffset.y+64, width, height);
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UISearchBarDelegate

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return true;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"end");
    [self.navigationController setProgressTitle:@"Processing Language"];
    
    [self.navigationController setIndeterminate:true];
    [self.navigationController showProgress];
    [self.navigationController setProgress:0.5 animated:false];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 0.5;
    }];
    
    [[EANetworkingHelper sharedHelper] witProcessed:searchBar.text completionBlock:^(NSDictionary *results, NSError *error) {
        [self.navigationController setProgressTitle:nil];
        
        [self.navigationController finishProgress];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.alpha = 1;
        }];
        
        
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Impossible de se connecter à Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }
        else
        {
            [self setConstraints:results];
        }
        
        
    }];
    
    
}

- (IBAction)datePickerValueDidChange:(UIDatePicker*)sender {
    
    NSDate *date = sender.date;
    
    NSIndexPath *indexPath;
    
    if (sender.tag == 1)
    {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        self.startDate = date;
        
        
        
    }
    
    else if (sender.tag == 2)
    {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        self.endDate = date;
    }
    
    
    
    [self updateTableData];
    
}

- (IBAction)didClickAnyDateButton:(UIButton *)sender {
    
    NSIndexPath *indexPath;
    
    if (sender.tag == 1)
    {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        self.startDate = nil;
        self.firstDatePickerEnabled = false;
        
    }
    
    else if (sender.tag == 2)
    {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
        self.endDate = nil;
        self.secondDatePickerEnabled = false;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self updateTableData];
    
    
}

- (IBAction)didClickSearchButton:(UIBarButtonItem *)sender {
    [self.navigationItem startAnimatingAt:ANNavBarLoaderPositionRight];
    [self.navigationController setProgressTitle:@"Creating Workflows"];
    
    [self.navigationController setIndeterminate:true];
    
    [self.navigationController showProgress];
    [self.navigationController setProgress:0.5 animated:false];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.alpha = 0.5;
    }];
    
    
    
    [[EANetworkingHelper sharedHelper] searchWorkflowsWithConstraints:self.constraints completionBlock:^(int totalNumberOfWorkflows, NSArray *workflows, NSError *error) {
        
        
        
        
        if (error)
        {
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.alpha = 1;
            }];
            
            
            [self.navigationController setProgressTitle:nil];
            
            [self.navigationController finishProgress];
            
            
            [self.navigationItem stopAnimating];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Impossible de se connecter à Internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }
        else
        {
            
            
            if (!workflows || workflows.count == 0)
            {
                [self.navigationController setProgressTitle:@"No Result"];
                
            }
            
            else if (totalNumberOfWorkflows)
            {
                [self.navigationController setProgressTitle:[NSString stringWithFormat:@"Found %d workflows", totalNumberOfWorkflows]];
                
            }
            else
            {
                [self.navigationController setProgressTitle:[NSString stringWithFormat:@"Found 1 workflow"]];
                
            }
            
            [self.navigationController finishProgress];
            
            
            
            [UIView animateWithDuration:0.7 animations:^{
                self.tableView.alpha = 1;
            } completion:^(BOOL finished) {
                
                [self.navigationItem stopAnimating];
                [self.navigationController setProgressTitle:nil];
                
                
                if (!workflows || workflows.count == 0)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Results" message:@"Change your search criteria" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alert show];
                }
                
                else if (workflows.count != 1)
                {
                    EAWorkflowListCollectionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Results"];
                    controller.workflows = workflows;
                    controller.totalNumberOfWorkflows = totalNumberOfWorkflows;
                    [self.navigationController pushViewController:controller animated:true];
                }
                else
                {
                    EAWorkflowMasterViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterInfo"];
                    controller.workflow = workflows.firstObject;
                    
                    [self.navigationController pushViewController:controller animated:true];
                }
                
                
                
            }];
            
            
        }
        
        
        
    }];
    
}

-(NSDictionary*)constraints
{
    
    NSMutableDictionary *constraints = [NSMutableDictionary dictionary];
    
    if (!self.intent)
        return nil;
    
    constraints[@"intent"] = self.intent;
    
    if (self.search)
        constraints[@"search"] = self.search;
    
    
    if (self.startDate)
        constraints[@"startDate"] = self.startDate.description;
    
    
    if (self.endDate)
        constraints[@"endDate"] = self.endDate.description;
    
    return constraints;
    
}

- (IBAction)didClickCancelButton:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}


#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.search = textField.text;
    
}




@end
