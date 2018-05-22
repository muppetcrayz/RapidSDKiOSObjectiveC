//
//  ViewController.m
//  MobileAPIObjectiveC
//
//  Created by Sage Conger on 5/15/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *incorrectLabel;
- (IBAction)submitPressed:(id)sender;

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
    [self submitPressed:_submitButton];
    return YES;
}

- (IBAction)submitPressed:(id)sender {
    if ([_usernameField hasText] && [_passwordField hasText]) {
        [self inputIsValid:^(BOOL completed) {
            if (completed) {
                if (![session_id isEqual: @""]) {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        [self performSegueWithIdentifier:@"loginSegue" sender:self->_submitButton];
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        self->_incorrectLabel.hidden = false;
                    });
                        
                }
            }
        }];
    }
    else {
            _incorrectLabel.hidden = false;
        }
}

- (void)inputIsValid:(void (^)(BOOL))completed {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.dubtel.com/v1/login"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@", _usernameField.text, _passwordField.text];
    
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
                                          session_id = [jsonObject objectForKey:@"session_id"];
                                          user_id = [jsonObject objectForKey:@"user_id"];
                                          completed(YES);
                                      }
                                      else {
                                          completed(NO);
                                      }
                                  
                                  }];
    
    [task resume];
    
}

- (IBAction)signUpPressed:(id)sender {
    [self performSegueWithIdentifier:@"logInToSignUpSegue" sender:_signUpButton];
}

@end
