//
//  ViewController_summary_screen.m
//  EmailApp
//
//  Created by Muhammad Asjad on 8/2/13.
//  Copyright (c) 2013 Muhammad Asjad. All rights reserved.
//
//-----------------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------------
//About: ViewController Driving the Summary Screen
#import "ViewController_summary_screen.h"
#import "NSData+Additions.h"
#import "ViewController_settings.h"
@interface ViewController_summary_screen ()

@end

@implementation ViewController_summary_screen

@synthesize emailobj_ref3=_emailobj_ref3;
@synthesize summary=_summary;

//@synthesize activityIndicator;

@synthesize user1_opt;
@synthesize user2_opt;


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
    //Closing message to be taken from NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *closing_msg = [defaults objectForKey:@"closing_msg"];

    NSString *email_body = [NSString stringWithFormat:@"%@, please meet %@,%@ \r\n\r\n%@, please meet %@, %@ \r\n\r\n %@", self.emailobj_ref3.first_recipientName,self.emailobj_ref3.second_recipientName,self.emailobj_ref3.context1,self.emailobj_ref3.second_recipientName, self.emailobj_ref3.first_recipientName,self.emailobj_ref3.context2,closing_msg];
    self.summary.text = email_body;
    //self.summary.numberOfLines = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)sendMail:(id)sender
{
    //[activityIndicator startAnimating];
    //activityIndicator.hidesWhenStopped = YES;
    NSLog(@"sending mail...to recepient %@, and to %@, using token %@",self.emailobj_ref3.first_recipientEmail, self.emailobj_ref3.second_recipientEmail,self.emailobj_ref3.auth_token);
    NSMutableString *url = [NSMutableString string];
   
    [url appendString:@"http://"];
    //[url appendString:@"pleasemeet-api.herokuapp.com/send_email/"];    
    [url appendString:@"frozen-plateau-4042.herokuapp.com/send_email/"];
    
    //Subject is being currently generated server side, see if that needs to be changed.
    NSMutableString *email_parameters = [NSMutableString string];
    
    [email_parameters appendString:@"to="];
    [email_parameters appendString:self.emailobj_ref3.first_recipientEmail];
    [email_parameters appendString:@","];
    [email_parameters appendString:self.emailobj_ref3.second_recipientEmail];
    //[email_parameters appendString:@"&subject="];
    //[email_parameters appendString:self.emailobj_ref3.first_recipientName];
    //[email_parameters appendString:@"<=>"];
    //[email_parameters appendString:self.emailobj_ref3.second_recipientName];
    //[email_parameters appendString:@"&body="];
    //[email_parameters appendString:self.summary.text];
    [email_parameters appendFormat:@"&user1_name="];
    [email_parameters appendFormat:self.emailobj_ref3.first_recipientName];
    [email_parameters appendFormat:@"&user2_name="];
    [email_parameters appendFormat:self.emailobj_ref3.second_recipientName];
    [email_parameters appendFormat:@"&opt_user1="];
    if (user1_opt.isOn == YES){
        [email_parameters appendFormat:@"1"];
    }
    else{
        //send OPT in API is currently set to take true if anything is passed at all..to be changed later   
    }
    [email_parameters appendFormat:@"&opt_user2="];
    if (user2_opt.isOn == YES){
        [email_parameters appendFormat:@"1"];
    }
    else{
        //API is currently set to take true if anything is passed at all..to be changed later
    }
    [email_parameters appendFormat:@"&context1="];
    [email_parameters appendFormat:self.emailobj_ref3.context1];
    
    [email_parameters appendFormat:@"&context2="];
    [email_parameters appendFormat:self.emailobj_ref3.context2];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *closing_msg = [defaults objectForKey:@"closing_msg"];
    [email_parameters appendFormat:@"&closing_message=%@",closing_msg];

    NSLog(@"the request url is%@", url);
    NSLog(@"the user_data is%@", email_parameters);
    
    NSData* data = [email_parameters dataUsingEncoding:NSUTF8StringEncoding];
    
    //HTTP request for sending email
    NSDictionary *response = [self getDataFrom:url withBody:data withToken:self.emailobj_ref3.auth_token];
   // NSLog(@"the response from mail server %@",response);
    //NSLog(@"response%@",response);
    if (response!=nil || response!= NULL)
    {
        NSString *response_val = [response objectForKey:@"success"];
        BOOL bool_response = [response_val boolValue];
    
        if (bool_response == YES){
            [self performSegueWithIdentifier:@"intro_sent" sender:self];
        }
        else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Opps. Something went wrong..."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Dimiss"
                                                      otherButtonTitles:nil];
                [alert show];
            
        }
    }
    //[activityIndicator stopAnimating];
    
}

//function needs renaming...

- (NSDictionary *) getDataFrom:(NSString *)url withBody:(NSData *)body withToken:(NSString *)token{
    //NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"myusername", @"mypassword"];

    NSMutableString *user_token = [NSMutableString string];
    //[user_token appendString:@"Basic "];
    [user_token appendString:token];
    [user_token appendString:@":"];
    [user_token appendString:@""];
    //  [user_token encodeWithCoder:];
    NSData *authData = [user_token dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];


    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setURL:[NSURL URLWithString:url]];
    
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
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
    //NSLog(@"JSON: %@", jsonDict);
    return jsonDict;
    
  }

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"jumpToSettings_3"]){
        ViewController_settings *controller = (ViewController_settings *)segue.destinationViewController;
        controller.emailobj_settings = self.emailobj_ref3;
    }
}

@end


