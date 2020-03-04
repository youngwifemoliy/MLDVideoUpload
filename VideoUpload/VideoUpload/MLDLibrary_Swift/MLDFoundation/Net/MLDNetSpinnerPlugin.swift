//
//  LoggerPlugin.swift
//  MLDSwiftBaseDemo
//
//  Created by mac on 2018/11/5.
//  Copyright © 2018年 何雷. All rights reserved.
//

import UIKit
import Moya
import Result

public class MLDNetSpinnerPlugin: PluginType {
    
    //活动状态指示器（菊花进度条）
    public var spinner = UIActivityIndicatorView(style: .gray)
    
    public init(spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)) {
        self.spinner = spinner
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        if let tempTarget = target as? MLDBaseRequest,
            tempTarget.hudSuperView != nil {
            tempTarget.hudSuperView!.addSubview(spinner)
            spinner.center = tempTarget.hudSuperView!.center
            spinner.startAnimating()
        }
    }
    
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        if let tempTarget = target as? MLDBaseRequest,
            tempTarget.hudSuperView != nil {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
        }
    }
}
