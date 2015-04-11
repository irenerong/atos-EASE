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
    // Do any additional setup after loading the view.
    //self.backgroundImageView.image =  [[UIImage imageNamed:@"LoginBG"] applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:1 alpha:0.2] saturationDeltaFactor:1 maskImage:nil];
    
    [EANetworkingHelper sharedHelper].loginViewController = self;
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithWhite:180/255. alpha:1.0] }];
    
    self.usernameTextField.attributedPlaceholder = str;

    str = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithWhite:180/255. alpha:1.0] }];
    self.passwordTextField.attributedPlaceholder = str;
    self.easeIPTextField.text = [EANetworkingHelper sharedHelper].easeServerAdress;
    
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




-(void)shakePassword
{
    self.passwordTextField.transform = CGAffineTransformMakeTranslation(40, 0);
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:20 options:0 animations:^{
        self.passwordTextField.transform = CGAffineTransformIdentity;

    } completion:nil];
    
}

-(void)shakeLogin
{
    self.usernameTextField.transform = CGAffineTransformMakeTranslation(-40, 0);
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:20 options:0 animations:^{
        self.usernameTextField.transform = CGAffineTransformIdentity;
        
    } completion:nil];
    
}


- (IBAction)login:(id)sender {
    
    
    
    if (!self.passwordTextField.text.length)
    {
        [self shakePassword];
    }
    
    if (!self.usernameTextField.text.length)
    {
        [self shakeLogin];
    }
    
    if (!self.passwordTextField.text.length || !self.usernameTextField.text.length)
        return;
    
    
    [[EANetworkingHelper sharedHelper] loginWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text completionBlock:^(NSError *error) {
       
        
        if (!error)
        {
            [self performSegueWithIdentifier:@"ToMain" sender:self];
            
            
            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(emptyTextFields) userInfo:nil repeats:NO];
           
            
        }
        else
        {
            
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            

            [self performSegueWithIdentifier:@"ToMain" sender:self];


        }
        
        
    }];
    
    
    
}

-(void)logout
{
    [self dismissViewControllerAnimated:true completion:nil];
}


-(void)emptyTextFields
{
    self.passwordTextField.text = @"";
    self.usernameTextField.text = @"";
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.easeIPTextField)
    {
        
    }
    
    return YES;
}

@end