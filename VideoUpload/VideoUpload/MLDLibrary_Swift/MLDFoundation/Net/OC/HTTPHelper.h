//
//  HTTPHelper.h
//  FootballApp
//
//  Created by Moliy on 2017/4/12.
//  Copyright © 2017年 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HTTPHelper : NSObject
+ (AFHTTPSessionManager *)HTTPSManager;
+ (AFHTTPSessionManager *)HTTPManager;

@end
