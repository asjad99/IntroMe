//
//  ViewController_summary_screen.h
//  EmailApp
//
//  Created by Muhammad Asjad on 8/2/13.
//  Copyright (c) 2013 Muhammad Asjad. All rights reserved.
//
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------
#import <UIKit/UIKit.h>
#import "email.h"
@interface ViewController_summary_screen : UIViewController

- (NSDictionary *) getDataFrom:(NSString *)url withBody:(NSData *)body withToken:(NSString *)token;
-(IBAction)sendMail:(id)sender;

@property (nonatomic, strong) email *emailobj_ref3;
@property (nonatomic, strong) IBOutlet UITextView * summary;
@property (nonatomic, strong) IBOutlet UISwitch *user1_opt;
@property (nonatomic, strong) IBOutlet UISwitch *user2_opt;
@property (nonatomic, strong) IBOutlet UISwitch *email_notify;

//@property (nonatomic, strong)IBOutlet UIActivityIndicatorView *activityIndicator;


@end
