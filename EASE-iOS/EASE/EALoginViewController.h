//
//  EALoginViewController.h
//  EASE
//
//  Created by Aladin TALEB on 04/04/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EANetworkingHelper.h"



@interface EALoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *easeIPTextField;
- (IBAction)login:(id)sender;
- (void)    logout;


@end
