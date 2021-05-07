//
//  ViewController_browser.h
//  EmailApp
//
//  Created by Muhammad Asjad on 8/1/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------

#import <UIKit/UIKit.h>
#import "email.h"
@interface ViewController_browser : UIViewController <UIWebViewDelegate>


- (NSDictionary *) getUserTokenFromAPI:(NSString *)url withBody:(NSData *)body;

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
@property (nonatomic, strong)IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) email *email_br;
@property (nonatomic, strong)IBOutlet UIWebView *webView;

@end




