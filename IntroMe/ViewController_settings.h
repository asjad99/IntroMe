//
//  ViewController_settings.h
//  EmailApp
//
//  Created by Muhammad Asjad on 8/6/13.
//  Copyright (c) 2013 Muhammad Asjad. All rights reserved.
//
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------
#import <UIKit/UIKit.h>
#import "email.h"
@interface ViewController_settings : UIViewController

@property (nonatomic,  retain) IBOutlet UITextView *signature;
@property (nonatomic,strong) NSString *signature_string;
@property (nonatomic, strong) email *emailobj_settings;

-(IBAction)Done:(id)sender;
-(IBAction)Logout:(id)sender;

- (NSDictionary *) make_APICallwithURL:(NSString *)url andClosing_message:(NSString *)body;
@end
