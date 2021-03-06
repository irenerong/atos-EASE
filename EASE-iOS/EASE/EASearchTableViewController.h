//
//  EASearchTableViewController.h
//  EASE
//
//  Created by Aladin TALEB on 10/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem+Loading.h"
#import "EANetworkingHelper.h"

#import "EAWorkflowListCollectionViewController.h"
#import "EAWorkflowMasterViewController.h"

#import "UINavigationController+M13ProgressViewBar.h"

#import "EASearchResults.h"

@interface EASearchTableViewController : UITableViewController <UISearchBarDelegate, UITextFieldDelegate>

@property(weak, nonatomic) id delegate;







@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel     *intentLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel     *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel     *endDateLabel;

- (NSDictionary *)constraints;

- (IBAction)datePickerValueDidChange:(UIDatePicker *)sender;
- (IBAction)didClickAnyDateButton:(UIButton *)sender;
- (IBAction)didClickSearchButton:(UIBarButtonItem *)sender;

- (IBAction)didClickCancelButton:(id)sender;

@end
