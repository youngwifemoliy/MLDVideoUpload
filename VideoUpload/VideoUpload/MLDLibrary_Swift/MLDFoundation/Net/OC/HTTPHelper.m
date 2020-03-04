//
//  HTTPHelper.m
//  FootballApp
//
//  Created by Moliy on 2017/4/12.
//  Copyright © 2017年 North. All rights reserved.
//

#import "HTTPHelper.h"

@implementation HTTPHelper
+ (AFHTTPSessionManager *)HTTPSManager
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@""]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    NSString *certificatePath = [[NSBundle mainBundle] pathForResource:@""
                                                                ofType:@"cer"];
    NSData *certificateData = [NSData dataWithContentsOfFile:certificatePath];
    NSSet *certificateSet = [[NSSet alloc] initWithObjects:certificateData, nil];
    [securityPolicy setPinnedCertificates:certificateSet];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    manager.securityPolicy = securityPolicy;
    return manager;
}

+ (AFHTTPSessionManager *)HTTPManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    return manager;
}

@end
