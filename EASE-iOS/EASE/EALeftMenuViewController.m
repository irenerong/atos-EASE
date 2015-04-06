//
//  EALeftMenuViewController.m
//  EASE
//
//  Created by Aladin TALEB on 02/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EALeftMenuViewController.h"

@interface EALeftMenuViewController ()

@end

@implementation EALeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tasksButton.titleLabel.numberOfLines = 0;
    
    /*
    NSMutableAttributedString *ingredientsString = [[NSMutableAttributedString alloc] initWithString:@"2" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]}];
    
    [ingredientsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Pending Tasks\n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]}]];
    
    [ingredientsString appendAttributedString:[[NSAttributedString alloc] initWithString:@"5" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]}]];
     
    [ingredientsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Working Tasks\n" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]}]];
    
    [self.tasksButton setAttributedTitle:ingredientsString forState:UIControlStateNormal];
     */
    
    
    
    NSMutableAttributedString *welcomeText = [[NSMutableAttributedString alloc] initWithString:@"Welcome " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]}];
    
    if ([EANetworkingHelper sharedHelper].currentUser)
    {
        
    
        [welcomeText appendAttributedString:[[NSAttributedString alloc] initWithString:[EANetworkingHelper sharedHelper].currentUser.username attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:17]}]];
        
        [welcomeText appendAttributedString:[[NSAttributedString alloc] initWithString:@" !" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]}]];
    }
    
    self.welcomeTextLabel.attributedText = welcomeText;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.frame.size.height/[self tableView:tableView numberOfRowsInSection:0];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSArray *menuItems = @[@"New Workflow", @"Dashboard", @"Calendar", @"Tasks"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    cell.textLabel.text = menuItems[indexPath.row];

    cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    cell.selectedBackgroundView = [UIView new];
    
    cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:1.];
    
    
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        
        case 0:
                    [self showViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"workflowViewController"] sender:self];
            break;
            
        case 2:
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"calendarViewController"]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];

            break;
        case 3:
            [self.sideMenuViewController setContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"notificationsViewController"]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];

            break;
            
        default:
            break;
    }
    

    
}

- (IBAction)logout:(id)sender {
    
    [[EANetworkingHelper sharedHelper] logout];
    
}
@end
