//
//  ApplicationViewController.m
//  MobileAPIObjectiveC
//
//  Created by Sage Conger on 5/22/18.
//  Copyright © 2018 DUBTEL. All rights reserved.
//

#import "ApplicationViewController.h"

@interface ApplicationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
- (IBAction)logOutPressed:(id)sender;

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutPressed:(id)sender {
    [self inputIsValid:^(BOOL completed) {
        if (completed) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
}

- (void)inputIsValid:(void (^)(BOOL))completed {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.dubtel.com/v1/logout"]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString = [NSString stringWithFormat:@"session_id=%@&user_id=%@", session_id, user_id];
    
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

@end
