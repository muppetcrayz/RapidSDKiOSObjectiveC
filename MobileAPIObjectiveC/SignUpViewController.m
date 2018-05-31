//
//  SignUpViewController.m
//  MobileAPIObjectiveC
//
//  Created by Sage Conger on 5/22/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

#import "SignUpViewController.h"
#import "globals.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *missingLabel;
@property (weak, nonatomic) IBOutlet UILabel *existsLabel;
@property (weak, nonatomic) IBOutlet UILabel *couldNotRegisterLabel;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)submitPressed:(id)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordField.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self submitPressed:_submitButton];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)inputIsValid:(void (^)(BOOL))completed {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.dubtel.com/v1/register"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"firstname=%@&lastname=%@&email=%@&password=%@", _firstNameField.text, _lastNameField.text, _emailField.text, _passwordField.text];
    
    NSData *nsdata = [var dataUsingEncoding:NSUTF8StringEncoding];
    NSString *token = [nsdata base64EncodedStringWithOptions:0];
    
    [request setValue: [NSString stringWithFormat:@"Basic %@", token] forHTTPHeaderField: @"Authorization"];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                      
                                      if ([[jsonObject valueForKey:@"status"] isEqual: @"Success"]) {
                                          completed(YES);
                                      }
                                      else {
                                          completed(NO);
                                      }
                                      
                                  }];
    
    [task resume];
    
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitPressed:(id)sender {
    if ([_firstNameField hasText] && [_lastNameField hasText] && [_emailField hasText] && [_passwordField hasText]) {
        [self inputIsValid:^(BOOL completed) {
            if (completed) {
                if (completed == YES) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self performSegueWithIdentifier:@"signUpToLoginSegue" sender:self->_submitButton];
                    });
                }
                else {
                    self->_couldNotRegisterLabel.hidden = false;
                    self->_missingLabel.hidden = true;
                }
            }
        }];
    }
    else {
        _missingLabel.hidden = false;
        _couldNotRegisterLabel.hidden = true;
    }
}
@end
