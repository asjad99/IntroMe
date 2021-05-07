//
//  ViewController.h
//  EmailApp
//
//  Created by Muhammad Asjad on 7/26/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------

#import <UIKit/UIKit.h>
#import "email.h"
@interface ViewController : UIViewController


@property (nonatomic, strong) email *emailobj;

//refers to the fields that appear after the label please enter details on screen 1
@property (nonatomic,  retain) IBOutlet UITextField *namefield_1;
@property (nonatomic,  retain) IBOutlet UITextField *namefield_2;

@property (nonatomic,  retain) IBOutlet UITextField *first_email_address;
@property (nonatomic,  retain) IBOutlet UITextField *second_email_address;



//action listener-listens to CONTINUE button press event
-(IBAction)getUserNames: (id)sender;
//to dismiss keyboard upon touch outside fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)IsValidEmail:(NSString *)checkString;
-(BOOL)validateInput:(NSArray *)input_array;

@end
