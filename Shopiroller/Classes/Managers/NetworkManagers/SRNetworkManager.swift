//
//  SRNetworkManager.swift
//  shopiroller
//
//  Created by Görkem Gür on 16.09.2021.
//


import UIKit
import Foundation
//import SVProgressHUD


public typealias handler = (FetchResult) -> Void

public enum FetchResult {
    case error(_: ShopirollerError)
    case success(result: Any?)
}

public enum SRResponseResult<T: Decodable> {
    case failure(_: ShopirollerError)
    case success(result: T)
}

final public class SRNetworkManager {
    
    private let urlSession: URLSession
    private let environment: SREndpointType
    
    public init(urlSession: URLSession, environment: SREndpointType) {
        self.urlSession = urlSession
        self.environment = environment
    }
    
    public init() {
        let urlSessionConfiguration: URLSessionConfiguration = .`default`
        urlSessionConfiguration.timeoutIntervalForRequest = 60.0
        urlSessionConfiguration.timeoutIntervalForResource = 60.0
        urlSession = .init(configuration: urlSessionConfiguration, delegate: SRNetworkManagerURLSessionDelegate(), delegateQueue: nil)
        environment = SRAppContext.currentEndpoint
    }
    
    private func url<T>(for request: SRNetworkRequestManager<T>) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = environment.scheme
        urlComponents.host = environment.baseURL
        urlComponents.port = environment.port
        urlComponents.path = request.path.name + (request.subpath ?? "")
        var urlQueryItems = request.urlQueryItems ?? []
        urlComponents.queryItems = urlQueryItems
        return urlComponents.url
    }
    
    private func urlRequest<T>(for request: SRNetworkRequestManager<T>) -> URLRequest? {
        guard let url = url(for: request) else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod?.rawValue
        urlRequest.httpBody = request.httpBody
        
        urlRequest.setValue(request.contentType.value, forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        
        SRNetworkManager.additionalHeaders.forEach { (element) in
            urlRequest.setValue(element.value, forHTTPHeaderField: element.key)
        }
        
        return urlRequest
    }
    
    
    static var additionalHeaders: [String: String?] {
        var headers: [String: String] = [:]
        headers[SRAppConstants.Header.apiKey] = SRNetworkContext.apiKey
        headers[SRAppConstants.Header.appKey] = SRNetworkContext.appKey
        //        headers[AppConstants.Header.appVersion] = AppInfo.appVersion
        //        headers[AppConstants.Header.deviceBrand] = AppInfo.deviceModel
        //        headers[AppConstants.Header.deviceModel] = AppInfo.deviceName
        //        headers[AppConstants.Header.osVersion] = AppInfo.systemVersion
        //        headers[AppConstants.Header.uuid] = AppInfo.uuid
        return headers
    }
    
    private func uploadData(for request: URLRequest, data: Data, handler: @escaping handler) {
        urlSession.uploadTask(with: request, from: data, completionHandler: { data, response, error in
            loggingPrint(request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                handler(.error(ShopirollerError.expiredToken))
                return
            }
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8) ?? "")
                handler(.success(result: data))
            } else {
                loggingPrint(error)
                if error?.isConnectivityError ?? true {
                    handler(.error(ShopirollerError.network))
                } else {
                    
                    handler(.error(ShopirollerError.other(title: nil, description: error?.localizedDescription ?? "")))
                }
            }
        }).resume()
    }
    
    private func fetchData(for request: URLRequest, handler: @escaping handler) {
        urlSession.dataTask(with: request, completionHandler: { data, response, error in
            loggingPrint(request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                handler(.error(ShopirollerError.expiredToken))
                return
            }
            if let data = data {
                print(String(data: data, encoding: String.Encoding.utf8) ?? "")
                handler(.success(result: data))
            } else {
                
                loggingPrint(error)
                if error?.isConnectivityError ?? true {
                    handler(.error(ShopirollerError.network))
                } else {
                    
                    handler(.error(ShopirollerError.other(title: nil, description: error?.localizedDescription ?? "")))
                }
            }
        }).resume()
    }
    
    func response<T: Decodable>(for request: SRNetworkRequestManager<T>, response resourceResult: @escaping ((SRResponseResult<SRNetworkManagerResponse<T>>) -> Void)) {
        guard let urlRequest = urlRequest(for: request) else {
            resourceResult(.failure(ShopirollerError.url))
            return
        }
        self.fetchData(for: urlRequest) { (result) in
            DispatchQueue.global(qos: .background).async {
                switch result {
                case .error(let error):
                    if error == .expiredToken {
                        resourceResult(.failure(error))
                    } else {
                        resourceResult(.failure(error))
                    }
                case .success(result: let result):
                    guard let data = result as? Data else {
                        resourceResult(.failure(ShopirollerError.parseJSON))
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    let obj = SRNetworkManagerResponse<T>.self
                    do {
                        var value = try decoder.decode(obj, from: data)
                        
                        if let error = value.message {
                            resourceResult(.failure(ShopirollerError.other(title: "error-general-title", description: error)))
                            return
                        } else if let errors = value.errors {
                            resourceResult(.failure(ShopirollerError.other(title: "error-general-title", description: errors[0])))
                            return
                        } else {
                            resourceResult(.success(result: value))
                            return
                        }
                        
                    } catch let error {
                        do {
                            let object = T.self
                            let value = try decoder.decode(object, from: data)
                            let a = SRNetworkManagerResponse(data: value, success: nil, isUserFriendlyMessage: nil, key: nil, message: nil, errors: nil)
                            resourceResult(.success(result: a))
                            return
                        } catch let subError {
                            
                            
                        }
                        resourceResult(.failure(error.convertError))
                        return
                    }
                }
            }
        }
        
    }
    
    func objectResponse<T: Decodable>(for request: SRNetworkRequestManager<T>, response resourceResult: @escaping ((SRResponseResult<T>) -> Void)) {
        guard let urlRequest = urlRequest(for: request) else {
            resourceResult(.failure(ShopirollerError.url))
            return
        }
        self.fetchData(for: urlRequest) { (result) in
            DispatchQueue.global(qos: .background).async {
                switch result {
                case .error(let error):
                    resourceResult(.failure(error))
                case .success(result: let result):
                    guard let data = result as? Data else {
                        resourceResult(.failure(ShopirollerError.parseJSON))
                        return
                    }
                    do {
                        let decoder = JSONDecoder()
                        let obj = T.self
                        let resourceValue = try decoder.decode(obj, from: data)
                        resourceResult(.success(result: resourceValue))
                    } catch let error {
                        resourceResult(.failure(error.convertError))
                    }}
            }
        }
    }
    
}



