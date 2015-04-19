//
//  EASearchPopupViewController.m
//  EASE
//
//  Created by Aladin TALEB on 18/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EASearchPopupViewController.h"

@interface EASearchPopupViewController ()

@end

@implementation EASearchPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.examplesLabel.text = @"Cook a chicken before 9pm\nBake a salad at noon\nTake a shower";
    self.examplesLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.examplesLabel.text = @"Cook a chicken before 9pm\nBake a salad at noon\nTake a shower";
    self.examplesLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return false;
}

- (IBAction)search:(id)sender {
    
    [self.searchQueryTextField resignFirstResponder];
    
    self.examplesLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    
    self.examplesLabel.text = @"Trying to understand your query ...";

    if (self.searchQueryTextField.text.length == 0)
    {
        self.examplesLabel.text = @"That doesn't look like a regular query !";

        return;
    }

    
       
    [[EANetworkingHelper sharedHelper] witProcessed:self.searchQueryTextField.text completionBlock:^(NSDictionary *results, NSError *error) {
        
        if (error)
        {
            self.examplesLabel.text = error.localizedDescription;
            return;
        }
        self.examplesLabel.text = @"Looking for workflows ...";

       
        NSMutableDictionary *searchQuery = [NSMutableDictionary dictionary];
        
        [searchQuery addEntriesFromDictionary:@{@"intent" : results[@"intent"]}];
        
        if (results[@"search"])
            [searchQuery addEntriesFromDictionary:@{@"title" : results[@"search"]}];
        
        if (results[@"toDate"])
            [searchQuery addEntriesFromDictionary:@{@"endDate" : results[@"toDate"]}];
        
        if (results[@"fromDate"])
            [searchQuery addEntriesFromDictionary:@{@"startDate" : results[@"fromDate"]}];
       

        
        [[EANetworkingHelper sharedHelper] searchWorkflowsWithConstraints:searchQuery completionBlock:^(int totalNumberOfWorkflows, EASearchResults *searchResults, NSError *error) {
           
            if (error)
            {
                self.examplesLabel.text = error.localizedDescription;
                return;
            }
            
            if (!totalNumberOfWorkflows)
            {
                self.examplesLabel.text = @"Can't find any workflows to match your query ...\n Try changing the purpose or the date !";
                return;
            }
            
            self.examplesLabel.text = [NSString stringWithFormat:@"I found %d workflows !", totalNumberOfWorkflows];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
               // [self dismissAnimated:true completionHandler:nil];
                [self.delegate popupFoundWorkflows:searchResults];
            });
            
        }];
        
    }];
    
}


@end
