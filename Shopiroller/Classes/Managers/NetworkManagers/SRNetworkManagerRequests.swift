//
//  SRSRNetworkRequestManagers.swift
//  shopiroller
//
//  Created by Görkem Gür on 19.09.2021.
//

import Foundation

struct SRNetworkManagerRequests {
    
    static func getProductsWithAdvancedFiltered(urlQueryItems: [URLQueryItem] = []) -> SRNetworkRequestManager<[ProductListModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getProductsWithAdvancedFiltered, resourceType: [ProductListModel].self,urlQueryItems: urlQueryItems)
    }
    
    static func getProducts(showProgress: Bool,urlQueryItems: [URLQueryItem] = []) -> SRNetworkRequestManager<[ProductListModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getProducts, resourceType: [ProductListModel].self, urlQueryItems: urlQueryItems,shouldShowProgressHUD: showProgress)
        
    }
    
    static func getProduct(productId: String) -> SRNetworkRequestManager<ProductDetailResponseModel> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getProduct, subpath:
        "\(productId)",resourceType: ProductDetailResponseModel.self)
    }
    
    static func getPaymentSettings() -> SRNetworkRequestManager<PaymentSettingsResponeModel> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getPaymentSettings
                                       , resourceType: PaymentSettingsResponeModel.self)
    }
    
    static func makeOrder(_ makeOrder: MakeOrderAddressModel,userId: String) -> SRNetworkRequestManager<SROrderResponseInnerModel> {
        return SRNetworkRequestManager(httpMethod: .post, path: .makeOrder, subpath:
                                        "/\(userId)", resourceType: SROrderResponseInnerModel.self, httpBody: makeOrder.data)
    }
    
    static func tryAgain(_ completeOrder: CompleteOrderModel) -> SRNetworkRequestManager<SROrderResponseInnerModel> {
        return SRNetworkRequestManager(httpMethod: .post, path: .tryAgain, resourceType: SROrderResponseInnerModel.self, httpBody: completeOrder.data)
    }
    
    static func getOrderList(urlQueryItems: [URLQueryItem] = []) -> SRNetworkRequestManager<[SROrderModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getOrderList, resourceType: [SROrderModel].self , urlQueryItems: urlQueryItems)
    }
    
    static func getOrder(orderId: String) -> SRNetworkRequestManager<OrderDetailModel> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getOrder, subpath: "/\(orderId)", resourceType: OrderDetailModel.self)
    }
    
    static func getShoppingCart(userId: String) -> SRNetworkRequestManager<SRShoppingCartResponseModel> {
        let subPath = "\(userId)\(SRNetworkManagerPaths.shoppingCart.rawValue)"
        
        return SRNetworkRequestManager(httpMethod: .get, path: .users, subpath: subPath, resourceType: SRShoppingCartResponseModel.self)
    }
    
    static func validateShoppingCart(userId: String) -> SRNetworkRequestManager<SRShoppingCartResponseModel> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shoppingCartValidate.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .users, subpath: subpath, resourceType: SRShoppingCartResponseModel.self)
    }
    
    static func removeItemFromShoppingCart(userId: String, cartItemId: String) -> SRNetworkRequestManager<SuccessResponse> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shoppingCartItems.rawValue)\(cartItemId)"
        return SRNetworkRequestManager(httpMethod: .delete, path: .users, subpath: subpath , resourceType: SuccessResponse.self,ignoreParse: true)
    }
    
    static func updateItemQuantity(userId: String, cartItemId: String, body: UpdateCartItemQuantity) -> SRNetworkRequestManager<SuccessResponse> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shoppingCartItems.rawValue)\(cartItemId)\(SRNetworkManagerPaths.quantity.rawValue)"
        return SRNetworkRequestManager(httpMethod: .put, path: .users, subpath: subpath, resourceType: SuccessResponse.self, httpBody: body.data,ignoreParse: true)
    }
    
    static func addProductToShoppingCart(products: SRAddProductModel,userId: String) ->
    SRNetworkRequestManager<String> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shoppingCartItems.rawValue)"
        return SRNetworkRequestManager(httpMethod: .post, path: .users, subpath: subpath, resourceType: String.self, httpBody: products.data, ignoreParse: true)
    }
    
    static func clearShoppingCart(userId: String) -> SRNetworkRequestManager<SuccessResponse> {
        let subPath = "\(userId)\(SRNetworkManagerPaths.shoppingCartItems.rawValue)"
        return SRNetworkRequestManager(httpMethod: .delete, path: .users, subpath: subPath , resourceType: SuccessResponse.self)
    }
    
    static func getShoppingCartCount(userId: String) -> SRNetworkRequestManager<Int> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.getShoppingCartCount.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .users, subpath: subpath, resourceType: Int.self)
    }
    
    static func failurePayment(orderId: String) -> SRNetworkRequestManager<SuccessResponse> {
        return SRNetworkRequestManager(httpMethod: .post, path: .failurePayment, subpath: "/\(orderId)", resourceType: SuccessResponse.self)
    }
    
    static func getSliders(showProgress: Bool) -> SRNetworkRequestManager<[SRSliderDataModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getSliders, resourceType: [SRSliderDataModel].self,shouldShowProgressHUD: showProgress)
    }
    
    static func getCategories(showProgress: Bool) -> SRNetworkRequestManager<[SRCategoryResponseModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getCategories, resourceType: [SRCategoryResponseModel].self,shouldShowProgressHUD: showProgress)
    }
    
    static func getSubCategories(categoryId: String) -> SRNetworkRequestManager<SRCategoryResponseModel> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getSubCategories, resourceType: SRCategoryResponseModel.self)
    }
    
    static func getShowCase(showProgress: Bool) -> SRNetworkRequestManager<[SRShowcaseResponseModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getShowcase, resourceType: [SRShowcaseResponseModel].self,shouldShowProgressHUD: showProgress)
    }
    
    static func getFilterOptions(urlQueryItems: [URLQueryItem] = []) -> SRNetworkRequestManager<SRFilterOptionsResponseModel> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getFilterOptions , resourceType: SRFilterOptionsResponseModel.self, urlQueryItems: urlQueryItems)
    }
    
    static func getShippingAddresses(userId: String) -> SRNetworkRequestManager<[UserShippingAddressModel]> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shipping.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .addresses, subpath: subpath, resourceType: [UserShippingAddressModel].self)
    }
    
    static func getBillingAddresses(userId: String) -> SRNetworkRequestManager<[UserBillingAdressModel]> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.billing.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .addresses, subpath: subpath, resourceType: [UserBillingAdressModel].self)
    }
    
    static func deleteShippingAddress(userId: String, addressId: String) -> SRNetworkRequestManager<SuccessResponse> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shipping.rawValue)\(addressId)"
        return SRNetworkRequestManager(httpMethod: .delete, path: .addresses, subpath: subpath, resourceType: SuccessResponse.self,ignoreParse: true)
    }
    
    static func deleteBillingAddress(userId: String, addressId: String) -> SRNetworkRequestManager<SuccessResponse> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.billing.rawValue)\(addressId)"
        return SRNetworkRequestManager(httpMethod: .delete, path: .addresses, subpath: subpath, resourceType: SuccessResponse.self,ignoreParse: true)
    }
    
    static func getDefaultAddress(userId: String) -> SRNetworkRequestManager<SRDefaultAddressModel> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.defaultAddress.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .addresses , subpath: subpath, resourceType: SRDefaultAddressModel.self, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func addBillingAddress(_ request: AddAddressModel,userId: String) -> SRNetworkRequestManager<UserBillingAdressModel> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.billingAddress.rawValue)"
        return SRNetworkRequestManager(httpMethod: .post, path: .addresses , subpath: subpath, resourceType: UserBillingAdressModel.self,httpBody: request.data, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func addShippingAddress(_ request: AddAddressModel,userId: String) -> SRNetworkRequestManager<UserShippingAddressModel> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shippingAddress.rawValue)"
        return SRNetworkRequestManager(httpMethod: .post, path: .addresses , subpath: subpath, resourceType: UserShippingAddressModel.self,httpBody: request.data, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func editBillingAddress(_ request: EditAddressModel,userId: String) -> SRNetworkRequestManager<UserBillingAdressModel> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.billingAddress.rawValue)"
        return SRNetworkRequestManager(httpMethod: .put, path: .addresses , subpath: subpath, resourceType: UserBillingAdressModel.self,httpBody: request.data, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func editShippingAddress(_ request: EditAddressModel,userId: String) -> SRNetworkRequestManager<UserShippingAddressModel> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.shippingAddress.rawValue)"
        return SRNetworkRequestManager(httpMethod: .put, path: .addresses , subpath: subpath, resourceType: UserShippingAddressModel.self,httpBody: request.data, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func getCountryList() -> SRNetworkRequestManager<[CountryModel]> {
        let subpath = "\(SRNetworkManagerPaths.countries.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .addresses , subpath: subpath, resourceType: [CountryModel].self, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func getStateList(urlQueryItems: [URLQueryItem] = []) -> SRNetworkRequestManager<[CountryModel]> {
        let subpath = "\(SRNetworkManagerPaths.states.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .addresses , subpath: subpath, resourceType: [CountryModel].self, urlQueryItems: urlQueryItems, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func getCityList(urlQueryItems: [URLQueryItem] = []) -> SRNetworkRequestManager<[CountryModel]> {
        let subpath = "\(SRNetworkManagerPaths.cities.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .addresses , subpath: subpath, resourceType: [CountryModel].self, urlQueryItems: urlQueryItems, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    static func addAddress(userId: String?, address: AddAddressModel) -> SRNetworkRequestManager<SRDefaultAddressModel> {
        return SRNetworkRequestManager(httpMethod: .post, path: .addresses , subpath: userId, resourceType: SRDefaultAddressModel.self, httpBody: address.data, shouldShowProgressHUD: true,ignoreBaseModel: true)
    }
    
    
}

