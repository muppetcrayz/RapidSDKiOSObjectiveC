//
//  ViewController.m
//  MobileAPIObjectiveC
//
//  Created by Sage Conger on 5/15/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

#import "ViewController.h"

NSString *session_id = @"";
NSString *user_id = @"";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
- (IBAction)submitPressed;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordField.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self submitPressed];
    return YES;
}

//- (void)inputIsValid:(completion:

- (IBAction)submitPressed {
    if ([_usernameField hasText] && [_passwordField hasText]) {
        
    }
    else {
        
    }
}

- (IBAction)signUpPressed {
    [self performSegueWithIdentifier:@"logInToSignUpSegue" sender:_signUpButton];
}
                      
@end
