//
//  ViewController.m
//  EmailApp
//
//  Created by Muhammad Asjad on 7/26/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------
//About: Drives the first screen of the App
#import "ViewController.h"
#import "ViewController_2.h"
#import "ViewController_settings.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize emailobj=_email;

@synthesize namefield_1=_namefield_1;
@synthesize namefield_2=_namefield_2;

@synthesize first_email_address=_first_email_address;
@synthesize second_email_address=_second_email_address;

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)getUserNames:(id)sender
{
    self.emailobj.first_recipientName = self.namefield_1.text;
    self.emailobj.second_recipientName = self.namefield_2.text;
   
    self.emailobj.first_recipientEmail = self.first_email_address.text;
    self.emailobj.second_recipientEmail = self.second_email_address.text;
   
    NSArray *input_array = [NSArray arrayWithObjects:self.namefield_1.text,self.namefield_2.text,self.first_email_address.text,self.second_email_address.text,nil];

    BOOL isValid = [self validateInput:input_array];
    
    if (isValid == YES){
          [self performSegueWithIdentifier:@"show_labels" sender:self];
    }

}

-(BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"show_labels"]){
        ViewController_2 *controller = (ViewController_2 *)segue.destinationViewController;
        controller.emailobj_ref2 = self.emailobj;
    }
    else if([segue.identifier isEqualToString:@"jumpToSettings_1"]){
        ViewController_settings *controller = (ViewController_settings *)segue.destinationViewController;
        controller.emailobj_settings = self.emailobj;   
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.namefield_1.resignFirstResponder;
    self.namefield_2.resignFirstResponder;
    self.first_email_address.resignFirstResponder;
    self.second_email_address.resignFirstResponder;
    // or [myTextView resignFirstResponder];
}

-(BOOL)validateInput:(NSArray *)input_array {
    
    //verify if the entered email is a valid one
    BOOL flag = [self IsValidEmail: input_array[2]];
    BOOL flag_2 = [self IsValidEmail:input_array[3]];
   
    //trim the input name
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed_name1 = [input_array[0] stringByTrimmingCharactersInSet:whitespace];
    NSString *trimmed_name2 = [input_array[1] stringByTrimmingCharactersInSet:whitespace];

    
    if ([trimmed_name1 length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name"
                                                        message:@"Please enter the name of first person."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    else if ([trimmed_name2 length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name"
                                                        message:@"Please enter a valid email for second person."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else if (flag == NO){
        UIAlertView *alert_2 = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                          message:@"Please enter a valid email for 1st recepient."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [alert_2 show];
        
        
        return NO;
    }
    
    
    if (flag_2 == NO){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                            message:@"Please enter a valid email for 2nd recepient."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return NO;
            

    }
    else{
        //If the user input is valid
        return YES;
    }
    
}

@end
