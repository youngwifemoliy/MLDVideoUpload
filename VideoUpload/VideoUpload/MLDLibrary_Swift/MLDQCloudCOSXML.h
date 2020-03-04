//
//  MLDQCloudCOSXML.h
//  JJStudy
//
//  Created by MoliySDev on 2019/7/22.
//  Copyright © 2019 Moliy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLDQCloudCOSXML : NSObject

+ (instancetype)shared;

+ (void)setupCOSXMLShareService;

+ (void)uploadWithFileData:(NSData *)data
                  withType:(NSString *)type
               withProcess:(void (^)(int64_t bytesSent,
                                     int64_t totalBytesSent,
                                     int64_t totalBytesExpectedToSend))sendProcessBlock
              withCallback:(void(^)(NSString *url))block;
@end

NS_ASSUME_NONNULL_END
