//
//  ViewController_settings.m
//  EmailApp
//
//  Created by Muhammad Asjad on 8/6/13.
//  Copyright (c) 2013 Muhammad Asjad. All rights reserved.
//
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------
//About: Drives the settings screen.
#import "ViewController_settings.h"
#import "NSData+Additions.h"
@interface ViewController_settings ()

@end

@implementation ViewController_settings

@synthesize signature;
@synthesize signature_string=_signature_string;
@synthesize emailobj_settings=_emailobj_settings;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.signature.text = @"";
}

//After the view has been loaded, retrieves the signature via API call
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *url = [NSString stringWithFormat:@"http://frozen-plateau-4042.herokuapp.com/get_closing_message/"];

    NSDictionary *response = [self make_APICallwithURL:url andClosing_message:@"GET"];
    NSLog(@"response%@",response);
    if (response!=nil || response!= NULL)
    {
        NSString *response_val = [response objectForKey:@"closing_message"];
        self.signature.text = response_val;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)Done:(id)sender
{
    NSMutableString *url = [NSMutableString string];
    // [url appendString:@"http://pleasemeet-api.herokuapp.com/get_closing_message/"];
    [url appendString:@"http://frozen-plateau-4042.herokuapp.com/save_closing_message/"];
    
    NSMutableString *closing_message = [NSMutableString string];
    
    [closing_message appendString:@"closing_message="];
    [closing_message appendString:self.self.signature.text];
 
    NSDictionary *response = [self make_APICallwithURL:url andClosing_message:closing_message];
    NSLog(@"response%@",response);
    
    if (response==nil || response== NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Error syncing the closing message"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dimiss"
                                              otherButtonTitles:nil];
        [alert show];
       
    }
    else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.signature.text forKey:@"closing_msg"];
        
    }

    [self dismissViewControllerAnimated:TRUE completion:nil];

}

-(IBAction)Logout:(id)sender{
    //clear the API token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setObject:NULL forKey:@"API_token"];
    
    //clear the cookies of the webview
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Send the logout request to the PleasMeet API
    NSMutableString *url = [NSMutableString string];
   //[url appendString:@"http://pleasemeet-api.herokuapp.com/logout/"];
    [url appendString:@"http://frozen-plateau-4042.herokuapp.com/logout/"];
 
    NSDictionary *response = [self make_APICallwithURL:url andClosing_message:@"GET"];
    NSLog(@"response%@",response);

    if (response!=nil || response!= NULL)
    {
        NSString *response_val = [response objectForKey:@"success"];
        BOOL bool_response = [response_val boolValue];

        if (bool_response == YES){
            [self performSegueWithIdentifier:@"log_out" sender:self];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Opps...something went wrong."
                                                       delegate:nil
                                              cancelButtonTitle:@"Dimiss"
                                              otherButtonTitles:nil];
        [alert show];
        }
    }
    
}

- (NSDictionary *) make_APICallwithURL:(NSString *)url andClosing_message:(NSString *)body{
   
    NSLog(@"the toke is %@",self.emailobj_settings.auth_token);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    if ([body isEqualToString:@"GET"] || [body isEqualToString:@"GET"]){
        [request setHTTPMethod:@"GET"];
    }
    else{
        NSData* body_converted = [body dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:body_converted];
    }
    [request setURL:[NSURL URLWithString:url]];
    
    NSMutableString *user_token = [NSMutableString string];
    
    [user_token appendString:self.emailobj_settings.auth_token];
    [user_token appendString:@":"];

    NSData *authData = [user_token dataUsingEncoding:NSUTF8StringEncoding];

    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSDictionary *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        if([responseCode statusCode] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error"
                                                            message:@"Make sure you are connected to the internet"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            //pause and try again here...
            
            return nil;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Opps...something went wrong."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dimiss"
                                                  otherButtonTitles:nil];
            [alert show];
            NSLog(@"Error sending mail... %@, HTTP status code %i", url, [responseCode statusCode]);
            return nil;
        }
    }
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:oResponseData
                                                             options:kNilOptions
                                                               error:&error];
    NSLog(@"JSON: %@", jsonDict);
    return jsonDict;
    NSString *mystring;
    [mystring isEqualToString:@"sometext"];
}



@end
