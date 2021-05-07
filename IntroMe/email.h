//
//  email.h
//  EmailApp
//
//  Created by Muhammad Asjad on 7/30/13.
//-----------------------------
// Copyright ., Inc.
// All Rights Reserved
//-----------------------------

#import <Foundation/Foundation.h>


@interface email : NSObject

@property (nonatomic,strong) NSString *auth_token;

@property (nonatomic,strong) NSString *first_recipientName;
@property (nonatomic,strong) NSString *second_recipientName;

@property (nonatomic,strong) NSString *first_recipientEmail;
@property (nonatomic,strong) NSString *second_recipientEmail;

@property (nonatomic,strong) NSString *context1;
@property (nonatomic,strong) NSString *context2;



@end
