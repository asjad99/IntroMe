//
//  ViewController_login.m
//  EmailApp
//
//  Created by Muhammad Asjad on 9/17/13.
//  Copyright (c) 2013 Muhammad Asjad. All rights reserved.
//--------------------------------------------------------
//View Controller Driving the 

#import "ViewController_login.h"
#import "ViewController.h"
@interface ViewController_login ()

@end

@implementation ViewController_login

@synthesize email_ln;

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
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)loginUsingGoogleID: (id) sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"API_token"];
    NSString *user_email = [defaults objectForKey:@"user_email"];
    
    NSString* user_data = [NSString stringWithFormat:@"email=%@",user_email];
    if (token!=Nil || token!= NULL) {
        self.email_ln = [[email alloc] init];
        self.email_ln.auth_token = token;

        //convert the user data string into NSdata format
        NSData* data = [user_data dataUsingEncoding:NSUTF8StringEncoding];
        
        //HTTP request for fetching session Token
        NSDictionary *response = [self getUserTokenFromAPI:@"http://frozen-plateau-4042.herokuapp.com/api_token_is_valid/" withBody:data];
      
        if (response!=NULL || response!=nil){
            [self performSegueWithIdentifier:@"login_success1" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"webview" sender:self];
        }
    }
    else{
        [self performSegueWithIdentifier:@"webview" sender:self];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"login_success1"]){
        
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.emailobj = self.email_ln;
    }
}


- (NSDictionary *) getUserTokenFromAPI:(NSString *)url withBody:(NSData *)body{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body];
    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    [request setURL:[NSURL URLWithString:url]];
    [request setTimeoutInterval:240];
    
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
            NSLog(@"Error getting token... %@, HTTP status code %i", url, [responseCode statusCode]);
            return nil;
        }
    }
    
    //NSData *jsonData = [oResponseData dataUsingEncoding:NSASCIIStringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:oResponseData
                                                             options:kNilOptions
                                                               error:&error];
    NSLog(@"JSON: %@", jsonDict);
    return jsonDict;
    
    //return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}



@end
