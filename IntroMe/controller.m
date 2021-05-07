//
//  controller.m
//  EmailApp
//
//  Created by Muhammad Asjad on 7/29/13.
//  Copyright (c) 2013 Muhammad Asjad. All rights reserved.
//

#import "controller.h"


@implementation controller

@synthesize dynamic_namefield_1=_dynamic_namefield_1;


- (void)viewDidLoad
{
   // [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.dynamic_namefield_1.text = [NSString stringWithFormat:@"%@", @"HELLO"];
}
@end
