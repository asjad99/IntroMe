//
//  ViewController_login.h
//  EmailApp
//
//  Created by Muhammad Asjad on 9/17/13.
//  Copyright (c) 2013 Muhammad Asjad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "email.h"
#import "NSData+Additions.h"
@interface ViewController_login : UIViewController

@property (nonatomic,strong) email *email_ln;

//login button
-(IBAction)loginUsingGoogleID:(id) sender;
- (NSDictionary *) getUserTokenFromAPI:(NSString *)url withBody:(NSData *)body;
@end
