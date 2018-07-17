//
//  SBRouter.swift
//  SearchBook
//
//  Created by sawijaya on 7/17/18.
//  Copyright © 2018 sawijaya. All rights reserved.
//

import Foundation

import Alamofire

protocol ISBRouterRequest {
    var httpMethod: Alamofire.HTTPMethod { get }
    
    var path: String { get }
    
    var parameters: SBRouter.APIParameters? { get }
    
    var encoding: Alamofire.ParameterEncoding { get }
    
    var httpHeaderFields:[String: Any] { get }
}

enum SBRouter {
    typealias APIParameters = [String: Any]
    
    static let APP_API_BASE_URL_ENDPOINT: String = "https://www.googleapis.com"
    static let BASE_URL: URL = URL(string:APP_API_BASE_URL_ENDPOINT)!
    
    static let TIMEOUTINTERVAL: TimeInterval = 60
    
    case searchBook(query:[String:Any])
}

extension SBRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var baseURL = SBRouter.BASE_URL
        
        baseURL = baseURL.appendingPathComponent(self.path)
        let mutableUrlRequest = NSMutableURLRequest(url: baseURL)
        mutableUrlRequest.httpMethod = self.httpMethod.rawValue
        mutableUrlRequest.timeoutInterval = SBRouter.TIMEOUTINTERVAL
        for (key,value) in self.httpHeaderFields {
            mutableUrlRequest.setValue(value as? String, forHTTPHeaderField: key)
        }
        let urlRequest: URLRequest = mutableUrlRequest.copy() as! URLRequest
        let encoding = self.encoding
        
        print("base url   : \(baseURL)")
        print("header     : \(self.httpHeaderFields)")
        print("parameters : \(String(describing: self.parameters))")
        
        return try encoding.encode(urlRequest as URLRequestConvertible, with: self.parameters).urlRequest!
    }
}

extension SBRouter: ISBRouterRequest {
    
    internal var httpHeaderFields: [String: Any] {
        
        var _httpHeaderFields: [String: Any] = [:]
        _httpHeaderFields["Accept"] = "application/json" as AnyObject
        
        return _httpHeaderFields
    }
    
    internal var httpMethod: HTTPMethod {
        switch self {
            case .searchBook:
                return .get
        }
    }
    
    internal var parameters: APIParameters? {
        switch self {
            case .searchBook(let parameter):
                return parameter
        }
    }
    
    internal var path: String {
        switch self {
            
            case .searchBook:
                //https://www.googleapis.com/books/v1/volumes?q=%7Bkeyword
                return "books/v1/volumes"
        }
    }
    
    internal var encoding: ParameterEncoding {
        switch self {
            case .searchBook :
                return URLEncoding.default
        }
    }
}
