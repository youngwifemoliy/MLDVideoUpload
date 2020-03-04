//
//  MLDBaseApi.swift
//  MLDSwiftBaseDemo
//
//  Created by 何雷 on 2018/9/19.
//  Copyright © 2018年 何雷. All rights reserved.
//

import Foundation
import Alamofire
import Moya
import SwiftyJSON

//MARK:MoyaProvider配置
private var requestTimeOut:Double = 30
//endpointClosure
private let myEndpointClosure = { (target: MLDBaseRequest) -> Endpoint in
    
    let url:String = target.baseURL.absoluteString+"/"+target.path
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: target.task,
        httpHeaderFields: target.headers
    )
    requestTimeOut = target.requestTimeOut
    return endpoint
}

private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        request.timeoutInterval = requestTimeOut
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

let mldBaseProvider = MoyaProvider<MLDBaseRequest>(endpointClosure: myEndpointClosure,
                                                   requestClosure: requestClosure,
                                                   plugins: [MLDNetSpinnerPlugin(),
                                                             MLDNetLoggerPlugin(verbose: false)])

//MARK:请求基类
open class MLDBaseRequest {
    
    public init () {}
    
    open var mldBaseURL: URL{
        return URL(string: "")!
    }
    open var mldPath: String{
        return ""
    }
    open var mldMethod: Moya.Method {
        return .get
    }
    open var mldHeaders: [String : String]? {
        return nil
    }
    open var mldParameters: [String : Any] {
        let parmeters = [String : Any]()
        return parmeters
    }
    
    open var requestTimeOut : Double {
        return 60.0
    }
    
    open var hudSuperView : UIView?
    
    open var msg = ""
    
    open private(set) var code = -1
    
    open private(set) var responseJson:JSON?
    
    open var ret:JSON?
    
    open private(set) var cancellable : Cancellable?
    
    ///个性化数据封装
    open func successDataPackaging(response:Response) {
    }
    
    open func failedDataPackaging(error:MoyaError) {
    }
    
    ///成功数据的回调
    open func startRequest<T:MLDBaseRequest>(_ completion: @escaping ((T) -> (Void)) ,
                                             failed: ((T) -> (Void))?) -> Void {
        if !isNetworkConnect{
            self.msg = "网络似乎出现了问题"
            self.requestFailedFilter()
            if failed != nil {
                failed!(self as! T)
            }
            return
        }
        cancellable = mldBaseProvider.request(self) { (result) in
            switch result {
            case let .success(response):
                do {
                    self.responseJson = try JSON(data: response.data)
                    self.code = response.statusCode
                    self.successDataPackaging(response: response)
                    self.requestCompleteFilter()
                    completion(self as! T)
                }
                catch {
                }
            case let .failure(error):
                if failed != nil {
                    if self.cancellable?.isCancelled == false {
                        self.failedDataPackaging(error: error)
                    }
                    self.requestFailedFilter()
                    failed!(self as! T)
                }
            }
        }
    }
    
    public func cancel() {
        if cancellable != nil{
            cancellable?.cancel()
        }
    }
    private var isNetworkConnect: Bool {
        get{
            let network = NetworkReachabilityManager()
            return network?.isReachable ?? true //无返回就默认网络已连接
        }
    }
    
    open func requestCompleteFilter() -> Void {
        
    }
    
    open func requestFailedFilter() -> Void {
        
    }
    
    deinit {
//        MLDLog.debug("\n----\(String(describing: self))Request释放了\n路径:\(mldPath)\n")
    }
}
//MARK:TargetType协议
extension MLDBaseRequest : TargetType{
    public var baseURL: URL {
        return mldBaseURL
    }
    
    public var path: String {
        return mldPath
    }
    
    public var method: Moya.Method {
        return mldMethod
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        return .requestParameters(parameters: mldParameters,
                                  encoding:  URLEncoding.default)
    }
    
    public var headers: [String : String]? {
        return mldHeaders
    }
}


