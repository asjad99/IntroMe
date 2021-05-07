//
//  ViewController_browser.m
//  EmailApp
//
//  Created by Muhammad Asjad on 8/1/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------
//About: viewcontroller driving the embeded browser screen.
#import "ViewController_browser.h"
#import "ViewController.h"

@interface ViewController_browser ()

@end

@implementation ViewController_browser


@synthesize webView;
@synthesize email_br=_email_br;
@synthesize activityIndicator;

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
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://email-app-v1.herokuapp.com/info"];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
  
    
    // }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"login_success"]){
      
        ViewController *controller = (ViewController *)segue.destinationViewController;
        controller.emailobj = self.email_br;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)awebView
{
    [activityIndicator stopAnimating];
    self.email_br = [[email alloc] init];
    
    NSString *theTitle=[awebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title is%@",theTitle);

    //parse the title to retrieve email and refresh token, make an call to Please Meet API to obtain user_token
    NSArray *title_array = [theTitle componentsSeparatedByString:@":"];
   
    //needs cleaning-up...
    if (title_array.count > 3){
        NSString *temp = title_array[1];
        if ([temp rangeOfString:@"@"].location != NSNotFound){
        BOOL authenticated = [self authenticateUsingRefreshToken:title_array];
            if (authenticated == YES){
                NSLog(@"--successfully authenticated--");
                [self performSegueWithIdentifier:@"login_success" sender:self];
            }
            else{
                NSLog(@"--authentication failed--");
            }
        }
    }
    
    if ([theTitle isEqualToString:@"Please Meet :: APP"]){
      NSURL *url2 = [NSURL URLWithString:@"http://email-app-v1.herokuapp.com/info"];
        
      NSURLRequest *req = [NSURLRequest requestWithURL:url2];
     [awebView loadRequest:req];
    }
}

//Makes an API call to retrieve user_token and uniqueID based on google's refresh Token.

-(BOOL) authenticateUsingRefreshToken:(NSArray *)title_array {
    
        //parse the title string to separate the email, token.
        NSArray *email = [title_array[1] componentsSeparatedByString:@"-"];
        NSArray *refresh_token = [title_array[3] componentsSeparatedByString:@"-"];
        NSArray *refresh_token_s = [refresh_token[0] componentsSeparatedByString:@" "];
    
        NSArray *user_name = [title_array[4] componentsSeparatedByString:@"-"];

        NSMutableString *url = [NSMutableString string];
        //[url appendString:@"http://pleasemeet-api.herokuapp.com/session/"];
        [url appendString:@"http://frozen-plateau-4042.herokuapp.com/session/"];
        
        NSString* user_data = [NSString stringWithFormat:@"email=%@&google_refresh_token=%@&user_name=%@",email[0],refresh_token_s[1],user_name[0]];


        NSLog(@"the user_data is%@", user_data);
        
        //convert the user data string into NSdata format
        NSData* data = [user_data dataUsingEncoding:NSUTF8StringEncoding];
        
        //HTTP request for fetching session Token
        NSDictionary *response = [self getUserTokenFromAPI:url withBody:data];
        NSDictionary *user_datadic = [response objectForKey:@"user"];
        NSString *API_token = NULL;
    
        if (user_datadic !=NULL){
            API_token = [user_datadic objectForKey:@"token"];
        }
    
        //store the token in email object
        if (API_token != Nil || API_token !=NULL){
            self.email_br.auth_token = API_token;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:API_token forKey:@"API_token"];
            [defaults setObject:email[0] forKey:@"user_email"];
  
            [defaults synchronize];
            return YES;
        }
        else{
            return NO;
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
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:oResponseData
                                                             options:kNilOptions
                                                               error:&error];
   NSLog(@"JSON: %@", jsonDict);
   return jsonDict;
    
}


@end
