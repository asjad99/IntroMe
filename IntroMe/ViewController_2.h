//
//  ViewController_2.h
//  EmailApp
//
//  Created by Muhammad Asjad on 7/30/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------

#import <UIKit/UIKit.h>
#import "email.h"
@interface ViewController_2 : UIViewController

@property (nonatomic, strong) email *emailobj_ref2;

//refers to the labels on screen add context
@property (nonatomic, strong) IBOutlet UILabel * dynamic_label_1;
@property (nonatomic, strong) IBOutlet UILabel * dynamic_label_2;


//text fields on the add context screen
@property (nonatomic,  retain) IBOutlet UITextView *add_context_field_1;
@property (nonatomic,  retain) IBOutlet UITextView *add_context_field_2;


//action listener-listens to CONTINUE button press event
-(IBAction)getContexts: (id) sender;

@end
