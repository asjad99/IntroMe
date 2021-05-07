//
//  ViewController_2.m
//  EmailApp
//
//  Created by Muhammad Asjad on 7/30/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------

#import "ViewController_2.h"
#import "ViewController_summary_screen.h"
#import "ViewController_settings.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController_2 ()

@end

@implementation ViewController_2

@synthesize emailobj_ref2=_email;

@synthesize dynamic_label_1=_dynamic_label_1;
@synthesize dynamic_label_2=_dynamic_label_2;

@synthesize add_context_field_1=_add_context_field_1;
@synthesize add_context_field_2 = _add_context_field_2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"in VC2, name is %@", self.emailobj_ref2.first_recipientName);
    //set up labels
   self.dynamic_label_1.text = [NSString stringWithFormat:@"%@ please meet %@ \r\n- complete the paragraph", self.emailobj_ref2.first_recipientName,self.emailobj_ref2.second_recipientName];
    self.dynamic_label_1.numberOfLines = 0;

    self.dynamic_label_2.text = [NSString stringWithFormat:@"%@ please meet %@ \r\n- complete the paragraph",self.emailobj_ref2.second_recipientName, self.emailobj_ref2.first_recipientName];
    self.dynamic_label_2.numberOfLines = 0;
    
    self.add_context_field_1.layer.borderWidth = 1.0f;
    self.add_context_field_1.layer.borderColor = [[UIColor grayColor] CGColor];
    self.add_context_field_1.layer.cornerRadius = 5;
    self.add_context_field_1.clipsToBounds = YES;
    
    self.add_context_field_2.layer.borderWidth = 1.0f;
    self.add_context_field_2.layer.borderColor = [[UIColor grayColor] CGColor];
    self.add_context_field_2.layer.cornerRadius = 5;
    self.add_context_field_2.clipsToBounds = YES;

    }

-(IBAction)getContexts:(id)sender
{
    self.emailobj_ref2.context1 = self.add_context_field_1.text;
    self.emailobj_ref2.context2 = self.add_context_field_2.text;
    
    NSString *trimmed_name1 = [self.emailobj_ref2.context1  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSString *trimmed_name2 = [self.emailobj_ref2.context2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([trimmed_name1 length] == 0 && [trimmed_name2 length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Name"
                                                        message:@"Please enter some context."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
}
    
    else {
         [self performSegueWithIdentifier:@"show_summary" sender:self];
    }

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"show_summary"]){
        ViewController_summary_screen *controller = (ViewController_summary_screen *)segue.destinationViewController;
        controller.emailobj_ref3 = self.emailobj_ref2;
    }
    else if([segue.identifier isEqualToString:@"jumpToSettings_2"]){
        ViewController_settings *controller = (ViewController_settings *)segue.destinationViewController;
        controller.emailobj_settings = self.emailobj_ref2;
    }
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.add_context_field_1.resignFirstResponder;
    self.add_context_field_2.resignFirstResponder;
    // or [myTextView resignFirstResponder];
}

@end
