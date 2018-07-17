//
//  SBAlamofire
//  SearchBook
//
//  Created by sawijaya on 7/17/18.
//  Copyright © 2018 sawijaya. All rights reserved.
//

import Foundation
import Alamofire

class SBAlamofire: NSObject {
    
    public typealias successWithResponse = (HTTPURLResponse?, _ responseObject: AnyObject?) -> Void
    public typealias failureWithError = (Error?) -> Void
    
    public typealias reloadCompletion = () -> Void
    
    static let sharedInstance = SBAlamofire()
    lazy var networkReachabilityManager = NetworkReachabilityManager()
    private override init(){
        super.init()
    }
    
    func startListenNetworkReachability(){
        if self.networkReachabilityManager?.listener != nil {
            self.stopListenNetworkReachability()
        }
        
        self.networkReachabilityManager?.listener = { status in
            //TODO: if the network is not reachable.
            if !self.networkReachabilityManager!.isReachable {
                //TODO: do something
            }
            print("Network Status Changed: \(status)")
            print("network reachable \(self.networkReachabilityManager!.isReachable)")
        }
        self.networkReachabilityManager?.startListening()
    }
    
    func stopListenNetworkReachability(){
        self.networkReachabilityManager?.stopListening()
    }
    
    func requestJSON(url: URLRequestConvertible,
                     successWithResponse: successWithResponse? = nil,
                     failureWithError: failureWithError? = nil) -> Request? {
        
        guard let networkReachabilityManager = self.networkReachabilityManager else {
            return nil
        }
        
        //TODO: if the network is not reachable.
        if !networkReachabilityManager.isReachable {
            //TODO: do something
        }
        let request: Request = Alamofire.request(url)
            //            .validate()
            //        .validate { (request, response, data) -> Request.ValidationResult in
            //            print(request)
            //            print(response)
            //            print(data)
            //            return .success
            //        }
            .responseJSON { (response) in
//                print(NSString(data: response.data!, encoding: 8) ?? "")
                print(response.response ?? "")
                print(response.value ?? "")
                switch(response.result) {
                case .success(let value):
                    successWithResponse?(response.response, value as AnyObject)
                    break
                case .failure(let error):
                    failureWithError?(error)
                    print(error._code)
                    print(error)
                    break
                }
        }
        return request
    }
}
