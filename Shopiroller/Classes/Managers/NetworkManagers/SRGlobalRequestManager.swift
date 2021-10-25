//
//  SRGlobalRequestManager.swift
//  Shopiroller
//
//  Created by Görkem Gür on 20.10.2021.
//

import Foundation

class SRGlobalRequestManager {
    static func getShoppingCartCount(succes: (() -> Void)? = nil, error: ((ErrorViewModel) -> Void)? = nil) {
        SRNetworkManagerRequests.getShoppingCartCount(userId: SRAppConstants.Query.Values.userId).response() {
            (result) in
            switch result{
            case .success(let response):
                DispatchQueue.main.async {
                    SRAppContext.shoppingCartCount = response.data ?? 0
                    succes?()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    error?(ErrorViewModel(error: err))
                }
            }
        }
        
    }
}