//
//  EALoginViewController.m
//  EASE
//
//  Created by Aladin TALEB on 04/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EALoginViewController.h"
#import <UIImage+ImageEffects.h>
@interface EALoginViewController ()

@end

@implementation EALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.backgroundImageView.image =  [[UIImage imageNamed:@"LoginBG"] applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1 maskImage:nil];
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    
    self.usernameTextField.attributedPlaceholder = str;

    str = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    self.passwordTextField.attributedPlaceholder = str;

    
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


- (IBAction)login:(id)sender {
    
    
    
    
    [[EANetworkingHelper sharedHelper] loginWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text completionBlock:^(NSError *error) {
       
        
        if (!error)
        {
            [self performSegueWithIdentifier:@"ToMain" sender:self];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];

        }
        
        
    }];
    
    
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
