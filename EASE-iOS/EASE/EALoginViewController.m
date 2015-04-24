//
//  EALoginViewController.m
//  EASE
//
//  Created by Aladin TALEB on 04/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EALoginViewController.h"
#import "UIImage+ImageEffects.h"
@interface EALoginViewController ()

@end

@implementation EALoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [EANetworkingHelper sharedHelper].loginViewController = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBackToLogin) name:@"Disconnect" object:nil];




    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithWhite:180/255. alpha:1.0] }];
    self.usernameTextField.attributedPlaceholder = str;

    str                                          = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithWhite:180/255. alpha:1.0] }];
    self.passwordTextField.attributedPlaceholder = str;
    self.easeIPTextField.text                    = [EANetworkingHelper sharedHelper].easeServerAdress;



    self.usernameTextField.text = @"";
    self.passwordTextField.text = @"";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.


}

- (void)goBackToLogin {

    [self dismissViewControllerAnimated:true completion:nil];

}

- (void)shakePassword {
    self.passwordTextField.transform = CGAffineTransformMakeTranslation(40, 0);


    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:20 options:0 animations:^{
         self.passwordTextField.transform = CGAffineTransformIdentity;

     } completion:nil];

}

- (void)shakeLogin {
    self.usernameTextField.transform = CGAffineTransformMakeTranslation(-40, 0);


    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:20 options:0 animations:^{
         self.usernameTextField.transform = CGAffineTransformIdentity;

     } completion:nil];

}

- (IBAction)login:(id)sender {



    if (!self.passwordTextField.text.length) {
        [self shakePassword];
    }

    if (!self.usernameTextField.text.length) {
        [self shakeLogin];
    }

    if (!self.passwordTextField.text.length || !self.usernameTextField.text.length)
        return;


    [[EANetworkingHelper sharedHelper] loginWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text completionBlock:^(NSError *error) {


         if (!error) {
             [self performSegueWithIdentifier:@"ToMain" sender:self];


             [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(emptyTextFields) userInfo:nil repeats:NO];


         } else {



             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                 message:[error localizedDescription]
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
             [alertView show];




         }


     }];



}

- (void)logout {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)emptyTextFields {
    self.passwordTextField.text = @"";
    self.usernameTextField.text = @"";
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    if (textField == self.easeIPTextField) {
        [EANetworkingHelper sharedHelper].easeServerAdress = self.easeIPTextField.text;
    }

    return YES;
}

@end
