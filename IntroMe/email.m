//
//  email.m
//  EmailApp
//
//  Created by Muhammad Asjad on 7/30/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------

#import "email.h"

@implementation email

@synthesize auth_token;
@synthesize first_recipientName=_first_recipientName;
@synthesize second_recipientName=_second_recipientName;

@synthesize first_recipientEmail=_first_recipientEmail;
@synthesize second_recipientEmail=_second_recipientEmail;

@synthesize context1;
@synthesize context2;

- (id)init
{
    if (self = [super init]) {
        self.first_recipientName = @"NA";
    }
    return self;
}
@end
