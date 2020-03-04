//
//  MLDHTTPRequest.h
//  FootballApp
//
//  Created by Moliy on 2017/5/26.
//  Copyright © 2017年 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPHelper.h"

@interface MLDHTTPRequest : NSObject

/**
 发送一个post记分的json请求

 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)postWithJsonURL:(NSString *)url
                 params:(id)params
                success:(void(^)(id responseObject))success
                failure:(void(^)(NSError *error))failure;

/**
 发送一个delete记分的json请求
 
 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
+ (void)deleteWithURL:(NSString *)url
               params:(id)params
              success:(void(^)(id responseObject))success
              failure:(void(^)(NSError *error))failure;

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
            failure:(void(^)(NSError *error))failure;

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
            failure:(void(^)(NSError *error))failure;

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
           failure:(void(^)(NSError *error))failure;

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
           failure:(void(^)(NSError *error))failure;

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
               success:(void(^)(BOOL sucess,id responseObject))success
               failure:(void(^)(NSError *error))failure;


/**
 * 发送一个post请求, 参数 params 中的内容将被转换成 json 作为Request Body
 * 主要应用于新开发的API，例如硬件绑定相关
 *
 * @param url 请求路径
 * @param params 请求参数
 * @param success 请求成功后的回调
 * @param failure 请求失败后的回调
 */
+ (void)postHttpBodyWithURL:(NSString *)url
                     params:(id)params
                    success:(void(^)(BOOL sucess,id responseObject))success
                    failure:(void(^)(NSError *error,id responseObject))failure;

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
                   success:(void(^)(BOOL sucess,id responseObject))success
                   failure:(void(^)(NSError *error,id responseObject))failure;

/**
 发送一个put请求
 
 @param url 请求路径
 @param params 请求参数
 @param success 请求成功后的回调
 @param failure 请求失败后的回调
 */
//+ (void)putWithURL:(NSString *)url
//            params:(id)params
//           success:(void(^)(id responseObject))success
//           failure:(void(^)(NSError *error))failure;

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
                      success:(void(^)(BOOL sucess,id responseObject))success
                      failure:(void(^)(NSError *error,id responseObject))failure;
@end
