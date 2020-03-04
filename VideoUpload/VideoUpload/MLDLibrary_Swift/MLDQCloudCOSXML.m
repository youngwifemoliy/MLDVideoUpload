//
//  MLDQCloudCOSXML.m
//  JJStudy
//
//  Created by MoliySDev on 2019/7/22.
//  Copyright © 2019 Moliy. All rights reserved.
//

#import "MLDQCloudCOSXML.h"
#import <QCloudCore.h>
#import <QCloudCOSXML.h>

//#define AppID @""
//#define SecretID @""
//#define SecretKey @""

@interface MLDQCloudCOSXML()<QCloudSignatureProvider>

@end

@implementation MLDQCloudCOSXML

static MLDQCloudCOSXML *object = nil;

+ (instancetype)shared {
    @synchronized (self) {
        if (object == nil) {
            object = [[self alloc] init];
        }
    }
    return object;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (object == nil) {
            object = [super allocWithZone:zone];
        }
    }
    return object;
}

+ (void)setupCOSXMLShareService {
    QCloudServiceConfiguration* configuration = [QCloudServiceConfiguration new];
    configuration.appID = AppID;
    configuration.signatureProvider = [MLDQCloudCOSXML shared];
    QCloudCOSXMLEndPoint* endpoint = [[QCloudCOSXMLEndPoint alloc] init];
    endpoint.regionName = @"ap-chengdu";//服务地域名称，可用的地域请参考注释
    //默认不用https
    endpoint.useHTTPS = YES;
    configuration.endpoint = endpoint;
    [QCloudCOSXMLService registerDefaultCOSXMLWithConfiguration:configuration];
    [QCloudCOSTransferMangerService registerDefaultCOSTransferMangerWithConfiguration:configuration];
}

+ (void)uploadWithFileData:(NSData *)data
                  withType:(NSString *)type
               withProcess:(void (^)(int64_t bytesSent,
                                     int64_t totalBytesSent,
                                     int64_t totalBytesExpectedToSend))sendProcessBlock
              withCallback:(void(^)(NSString *url))block {
    if (data.length < 1) {
        return;
    }
    QCloudCOSXMLUploadObjectRequest* put = [QCloudCOSXMLUploadObjectRequest new];
    put.body = data;
    put.bucket = @"huoke-public-1254282420";
    if ([type isEqualToString:@"img"]) {
        put.object = [NSString stringWithFormat:@"app/img/%@.png",[NSUUID UUID].UUIDString];
    }
    else if ([type isEqualToString:@"video"]) {
        put.object = [NSString stringWithFormat:@"app/video/%@.mov",[NSUUID UUID].UUIDString];
    }
    else {
        put.object = [NSString stringWithFormat:@"app/audio/%@.aac",[NSUUID UUID].UUIDString];
    }
    [put setSendProcessBlock:^(int64_t bytesSent,
                               int64_t totalBytesSent,
                               int64_t totalBytesExpectedToSend) {
        sendProcessBlock(bytesSent,
                         totalBytesSent,
                         totalBytesExpectedToSend);
    }];
    [put setFinishBlock:^(QCloudUploadObjectResult *outputObject,
                          NSError* error) {
        //可以从 outputObject 中获取 response 中 etag 或者自定义头部等信息（更多头部信息可以通过打印 outputObject 查看）
        NSString *url = [outputObject.location stringByReplacingOccurrencesOfString:@"huoke-public-1254282420.cos.ap-chengdu.myqcloud.com"
                                                                         withString:@"pub.file.k12.vip"];
        
        block(url);
    }];
    [[QCloudCOSTransferMangerService defaultCOSTransferManager] UploadObject:put];
}

- (void) signatureWithFields:(QCloudSignatureFields*)fileds
                     request:(QCloudBizHTTPRequest*)request
                  urlRequest:(NSMutableURLRequest*)urlRequst
                   compelete:(QCloudHTTPAuthentationContinueBlock)continueBlock
{
    
    QCloudCredential* credential = [QCloudCredential new];
    credential.secretID = SecretID;
    credential.secretKey = SecretKey;
    QCloudAuthentationV5Creator* creator = [[QCloudAuthentationV5Creator alloc] initWithCredential:credential];
    QCloudSignature* signature =  [creator signatureForData:urlRequst];
    continueBlock(signature, nil);
}

@end
