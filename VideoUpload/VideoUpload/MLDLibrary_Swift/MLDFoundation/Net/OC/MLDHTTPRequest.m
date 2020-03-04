//
//  MLDHTTPRequest.m
//  FootballApp
//
//  Created by Moliy on 2017/5/26.
//  Copyright © 2017年 North. All rights reserved.
//

#import "MLDHTTPRequest.h"
@interface MLDHTTPRequest()


@end
@implementation MLDHTTPRequest

void httpRequestLog(NSString *url,id body)
{
//    NSLog(@"\n===\n请求Api = %@\n请求参数 = %@\n===",url,body);
}

void httpErrorLog(NSURLSessionDataTask *task,NSString *url)
{
//    NSURLResponse *respones = [task response];
//    NSHTTPURLResponse *http = (NSHTTPURLResponse *)respones;
//    NSLog(@"\n===\n请求Api = %@\n请求错误信息 = %ld",url,(long)[http statusCode]);
}



/**
 发送一个post请求
 
 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url
             params:(id)params
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSDictionary *dic = [NSUserDefaults.standardUserDefaults dictionaryForKey:@"UserInfo"];
    NSString *sessionId = dic[@"sessionId"];
    if (sessionId.length > 0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",sessionId]
                         forHTTPHeaderField:@"Cookie"];
    }
    [manager POST:url
       parameters:params
          headers:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        success(responseObject);
    }
          failure:^(NSURLSessionDataTask * _Nullable task,
                    NSError * _Nonnull error) {
        httpErrorLog(task,url);
        failure(error);
    }];
}



+ (void)postWithJsonURL:(NSString *)url
                 params:(id)params
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *dic = [NSUserDefaults.standardUserDefaults dictionaryForKey:@"UserInfo"];
    NSString *sessionId = dic[@"sessionId"];
    if (sessionId.length > 0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",sessionId]
                         forHTTPHeaderField:@"Cookie"];
    }
    [manager POST:url
       parameters:params
          headers:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        success(responseObject);
    }
          failure:^(NSURLSessionDataTask * _Nullable task,
                    NSError * _Nonnull error) {
        httpErrorLog(task,url);
        failure(error);
    }];
}

+ (void)deleteWithURL:(NSString *)url
               params:(id)params
              success:(void(^)(id responseObject))success
              failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager DELETE:url
         parameters:params
            success:^(NSURLSessionDataTask * _Nonnull task,
                      id  _Nullable responseObject)
     {
         success(responseObject);
     }
            failure:^(NSURLSessionDataTask * _Nullable task,
                      NSError * _Nonnull error)
     {
         httpErrorLog(task,url);
         failure(error);
     }];
}

/**
 发送一个post请求,带进度条
 
 @param url 请求路径
 @param params 请求参数
 @param progress 百分比
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url
             params:(id)params
           progress:(void(^)(NSProgress *progress))progress
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager POST:url
       parameters:params
         progress:^(NSProgress * _Nonnull uploadProgress)
     {
         progress(uploadProgress);
     }
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject)
     {
         success(responseObject);
     }
          failure:^(NSURLSessionDataTask * _Nullable task,
                    NSError * _Nonnull error)
     {
         httpErrorLog(task,url);
         failure(error);
     }];
}

/**
 上传图片UIImage数组
 
 @param url 请求路径
 @param params 请求参数
 @param imageArray UIImage数组
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)uploadImageUrl:(NSString *)url
            withParams:(id)params
        withImageArray:(NSArray <UIImage *>*)imageArray
               success:(void(^)(BOOL sucess,
                                id responseObject))success
               failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    [manager.requestSerializer setValue:@"multipart/form-data"
                     forHTTPHeaderField:@"Content-Type"];
    [manager POST:url
       parameters:params
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         for (UIImage *image in imageArray)
         {
             [formData appendPartWithFileData:UIImagePNGRepresentation(image)
                                         name:@"files"
                                     fileName:@"imageFile.png"
                                     mimeType:@"image/png"];
         }
     }
         progress:^(NSProgress * _Nonnull uploadProgress) {}
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject)
     {
         if ([responseObject[@"flag"] intValue] == 0)
         {
             success(YES,responseObject);
         }
         else
         {
             success(NO,responseObject);
         }
     }
          failure:^(NSURLSessionDataTask * _Nullable task,
                    NSError * _Nonnull error)
     {
         httpErrorLog(task,url);
         failure(error);
     }];
}

/**
 发送一个get请求,带进度条
 
 @param url 请求路径
 @param params 请求参数
 @param progress 百分比
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url
            params:(id)params
          progress:(void(^)(NSProgress *progress))progress
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager GET:url
      parameters:params
        progress:^(NSProgress * _Nonnull downloadProgress)
     {
         progress(downloadProgress);
     }
         success:^(NSURLSessionDataTask * _Nonnull task,
                   id  _Nullable responseObject)
     {
         success(responseObject);
     }
         failure:^(NSURLSessionDataTask * _Nullable task,
                   NSError * _Nonnull error)
     {
         httpErrorLog(task,url);
         failure(error);
     }];
}

/**
 发送一个get请求
 
 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url
            params:(id)params
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.requestSerializer= [AFHTTPRequestSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    [manager.requestSerializer setValue:@"application/json"
                     forHTTPHeaderField:@"Content-Type"];
    NSDictionary *dic = [NSUserDefaults.standardUserDefaults dictionaryForKey:@"UserInfo"];
    NSString *sessionId = dic[@"sessionId"];
    if (sessionId.length > 0) {
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",sessionId]
                         forHTTPHeaderField:@"Cookie"];
    }
//    [manager.requestSerializer setValue:appVersion
//                     forHTTPHeaderField:@"version"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",sessionId]
//                     forHTTPHeaderField:@"model"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",sessionId]
//                     forHTTPHeaderField:@"system"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"JSESSIONID=%@",sessionId]
//                     forHTTPHeaderField:@"serialNum"];
    
    
    
    [manager GET:url
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task,
                   id  _Nullable responseObject)
     {
         success(responseObject);
     }
         failure:^(NSURLSessionDataTask * _Nullable task,
                   NSError * _Nonnull error)
     {
         httpErrorLog(task,url);
         failure(error);
     }];
}

/**
 * 发送一个post请求, 参数 params 中的内容将被转换成 json 作为Request Body
 *
 * @param url 请求路径
 * @param params 请求参数
 * @param success 请求成功后的回调
 * @param failure 请求失败后的回调
 */
+ (void)postHttpBodyWithURL:(NSString *)url
                     params:(id)params
                    success:(void(^)(BOOL sucess,
                                     id responseObject))success
                    failure:(void(^)(NSError *error,
                                     id responseObject))failure
{
    httpRequestLog(url, params);
    NSLog(@"+[MLDHTTPRequest postJsonBodyWithURL:params:success:failure:], URL: %@", url);
    // 将参数转换为json
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:0
                                                         error:&error];
    // 设置 request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:url
                                                                                parameters:nil
                                                                                     error:nil];
    request.timeoutInterval= 15.0;
    [request setValue:@"application/json;charset=UTF-8"
   forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
#ifdef DEBUG
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    NSLog(@"    >>>> POST Http Header: %@", request.allHTTPHeaderFields);
    NSLog(@"    >>>> POST Http Body  : %@", request.HTTPBody);
    NSLog(@"    >>>> POST Http Body string: %@", jsonString);
#endif
    // 设置 response
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request
                   uploadProgress:^(NSProgress * _Nonnull uploadProgress){}
                 downloadProgress:^(NSProgress * _Nonnull downloadProgress){}
                completionHandler:^(NSURLResponse * _Nonnull response,
                                    id  _Nullable responseObject,
                                    NSError * _Nullable error)
      {
#ifdef DEBUG
          NSLog(@"    >>>> Http responseObject = %@", responseObject);
#endif
          // 新格式的API中不再有flag、code等响应内容
          if (!error)
          {
              success(YES,responseObject);
          }
          else
          {
              failure(error,responseObject);
          }
      }] resume];
    //    [[manager dataTaskWithRequest:request
    //                completionHandler:^(NSURLResponse * _Nonnull response,
    //                                    id  _Nullable responseObject,
    //                                    NSError * _Nullable error)
    //      {
    //
    //      }] resume];
}

/**
 * 发送一个PUT请求, 参数 params 中的内容将被转换成 json 作为Request Body
 *
 * @param url 请求路径
 * @param params 请求参数
 * @param success 请求成功后的回调
 * @param failure 请求失败后的回调
 */
+ (void)putHttpBodyWithURL:(NSString *)url
                    params:(id)params
                   success:(void(^)(BOOL sucess,
                                    id responseObject))success
                   failure:(void(^)(NSError *error,
                                    id responseObject))failure
{
    httpRequestLog(url, params);
    NSLog(@"+[MLDHTTPRequest putHttpBodyWithURL:params:success:failure:]");
    // 将参数转换为json
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:0
                                                         error:&error];
    // 设置 request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"PUT"
                                                                                 URLString:url
                                                                                parameters:nil
                                                                                     error:nil];
    request.timeoutInterval = 15.0;
    [request setValue:@"application/json;charset=UTF-8"
   forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
#ifdef DEBUG
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"    >>>> PUT Http Header: %@", request.allHTTPHeaderFields);
    NSLog(@"    >>>> PUT Http Body  : %@", request.HTTPBody);
    NSLog(@"    >>>> PUT Http Body string : %@", jsonString);
#endif
    // 设置 response
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request
                   uploadProgress:^(NSProgress * _Nonnull uploadProgress) {}
                 downloadProgress:^(NSProgress * _Nonnull downloadProgress) {}
                completionHandler:^(NSURLResponse * _Nonnull response,
                                    id  _Nullable responseObject,
                                    NSError * _Nullable error)
      {
#ifdef DEBUG
          NSLog(@"    >>>> PUT Http responseObject = %@", responseObject);
#endif
          if (!error)
          {
              success(YES,responseObject);
          }
          else
          {
              failure(error,responseObject);
          }
      }] resume];
    //    [[manager dataTaskWithRequest:request
    //                completionHandler:^(NSURLResponse * _Nonnull response,
    //                                    id  _Nullable responseObject,
    //                                    NSError * _Nullable error)
    //      {
    //
    //      }] resume];
}


/**
 发送一个put请求
 
 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)putWithURL:(NSString *)url
            params:(id)params
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failure
{
    httpRequestLog(url, params);
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager PUT:url
      parameters:params
         success:^(NSURLSessionDataTask * _Nonnull task,
                   id  _Nullable responseObject)
     {
         success(responseObject);
     }
         failure:^(NSURLSessionDataTask * _Nullable task,
                   NSError * _Nonnull error)
     {
         httpErrorLog(task,url);
         failure(error);
     }];
}

/**
 * 发送一个DELETE请求, 参数 params 中的内容将被转换成 json 作为Request Body
 *
 * @param url 请求路径
 * @param params 请求参数
 * @param success 请求成功后的回调
 * @param failure 请求失败后的回调
 */
+ (void)deleteHttpBodyWithURL:(NSString *)url
                       params:(id)params
                      success:(void(^)(BOOL sucess,
                                       id responseObject))success
                      failure:(void(^)(NSError *error,
                                       id responseObject))failure
{
    httpRequestLog(url, params);
    NSLog(@"+[MLDHTTPRequest putHttpBodyWithURL:params:success:failure:]");
    // 将参数转换为json
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:0
                                                         error:&error];
    // 设置 request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"DELETE"
                                                                                 URLString:url
                                                                                parameters:nil
                                                                                     error:nil];
    request.timeoutInterval = 15.0;
    [request setValue:@"application/json;charset=UTF-8"
   forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
#ifdef DEBUG
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"    >>>> DELETE Http Header: %@", request.allHTTPHeaderFields);
    NSLog(@"    >>>> DELETE Http Body  : %@", request.HTTPBody);
    NSLog(@"    >>>> DELETE Http Body string: %@", jsonString);
#endif
    // 设置 response
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain",nil];
    AFHTTPSessionManager *manager = [HTTPHelper HTTPManager];
    manager.responseSerializer = responseSerializer;
    [[manager dataTaskWithRequest:request
                   uploadProgress:^(NSProgress * _Nonnull uploadProgress) {}
                 downloadProgress:^(NSProgress * _Nonnull downloadProgress) {}
                completionHandler:^(NSURLResponse * _Nonnull response,
                                    id  _Nullable responseObject,
                                    NSError * _Nullable error)
      {
#ifdef DEBUG
          NSLog(@"    >>>> PUT Http responseObject = %@", responseObject);
#endif
          if (!error)
          {
              success(YES,responseObject);
          }
          else
          {
              failure(error,responseObject);
          }
      }] resume];
    //    [[manager dataTaskWithRequest:request
    //                completionHandler:^(NSURLResponse * _Nonnull response,
    //                                    id  _Nullable responseObject,
    //                                    NSError * _Nullable error)
    //      {
    //
    //      }] resume];
}

@end



