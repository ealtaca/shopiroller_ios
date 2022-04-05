//
//  CheckOutAddressViewModel.swift
//  Shopiroller
//
//  Created by Görkem Gür on 1.11.2021.
//

import Foundation


class CheckOutAddressViewModel: SRBaseViewModel {
    
    private var defaultAdressList: SRDefaultAddressModel?
    
    private var shippingAddress: UserShippingAddressModel?
    
    private var billingAddress: UserBillingAdressModel?
        
    private var userShippingAddressList : [UserShippingAddressModel]?
    
    private var userBillingAddressList : [UserBillingAdressModel]?
    
    func getDefaultAddress(success: (() -> Void)? = nil , error: ((ErrorViewModel) -> Void)? = nil) {
        SRNetworkManagerRequests.getDefaultAddress(userId: SRAppContext.userId).response() {
            (result) in
            switch result {
            case .success(let response):
                self.defaultAdressList = response.data
                self.getShippingAddress()
                self.getBillingAddress()
                DispatchQueue.main.async {
                    success?()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    error?(ErrorViewModel(error: err))
                }
            }
        }
    }
    
    func getDeliveryAddressModel() -> GeneralAddressModel {
        return GeneralAddressModel(title: shippingAddress?.title, address: shippingAddress?.addressLine, description: shippingAddress?.getDescriptionArea(), type: .shipping, isEmpty: isShippingAddressEmpty())
    }
    
    func getBillingAddressModel() -> GeneralAddressModel {
        return GeneralAddressModel(title: billingAddress?.title, address: billingAddress?.addressLine, description: billingAddress?.getDescriptionArea(), type: .billing, isEmpty: isBillingAddressEmpty())
    }
    
    
    func getShippingEmptyModel() -> EmptyModel {
        return EmptyModel(image: .emptyShippingAddresses, title: "address_list_empty_shipping_title".localized,description: nil, button: ButtonModel(title: "add-address-button-text".localized, color: .textPrimary))
    }
    
    func getBillingEmptyModel() -> EmptyModel {
        return EmptyModel(image: .emptyBillingAddresses, title: "address_list_empty_billing_title".localized,description: nil, button: ButtonModel(title: "add-address-button-text".localized, color: .textPrimary))
    }
    
    func getShippingAddress() -> UserShippingAddressModel? {
        if shippingAddress == nil {
            shippingAddress = defaultAdressList?.shippingAddress
        }
        return shippingAddress
    }
    
    func getBillingAddress() -> UserBillingAdressModel? {
        if billingAddress == nil {
            billingAddress = defaultAdressList?.billingAddress
        }
        return billingAddress
    }
    
    func isShippingAddressEmpty() -> Bool {
        return defaultAdressList?.shippingAddress == nil
    }
    
    func isBillingAddressEmpty() -> Bool {
        return defaultAdressList?.billingAddress == nil
    }
    
    func getAddressList(success: (() -> Void)? = nil, error: ((ErrorViewModel) -> Void)? = nil) {
        getShippingAddressList(success: success, error: error)
        getBillingAddressList(success: success, error: error)
        
    }
    
    private func getShippingAddressList(success: (() -> Void)? = nil, error: ((ErrorViewModel) -> Void)? = nil) {
        SRNetworkManagerRequests.getShippingAddresses(userId: SRAppContext.userId).response() {
            (result) in
            switch result{
            case .success(let response):
                self.userShippingAddressList = response.data
                DispatchQueue.main.async {
                    success?()
                }
            case.failure(let err):
                DispatchQueue.main.async {
                    error?(ErrorViewModel(error: err))
                }
            }
        }
    }
    
    private func getBillingAddressList(success: (() -> Void)? = nil, error: ((ErrorViewModel) -> Void)? = nil) {
        SRNetworkManagerRequests.getBillingAddresses(userId: SRAppContext.userId).response() {
            (result) in
            switch result{
            case .success(let response):
                self.userBillingAddressList = response.data
                DispatchQueue.main.async {
                    success?()
                }
            case.failure(let err):
                DispatchQueue.main.async {
                    error?(ErrorViewModel(error: err))
                }
            }
        }
    }
    
    func getUserBillingAddressList() -> [UserBillingAdressModel]? {
        return userBillingAddressList
    }
    
    func getUserShippingAddressList() -> [UserShippingAddressModel]? {
        return userShippingAddressList
    }
    
    func setDefaultAddress(defaultAddress: SRDefaultAddressModel) {
        defaultAdressList = defaultAddress
        billingAddress = defaultAddress.billingAddress
        shippingAddress = defaultAddress.shippingAddress
    }
    
    func setShippingAddress(shippingAddressModel: UserShippingAddressModel) {
        shippingAddress = shippingAddressModel
    }
    
    func setBillingAddress(billingAddressModel: UserBillingAdressModel) {
        billingAddress = billingAddressModel
    }
}
