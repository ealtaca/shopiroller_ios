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
    
    static func getProducts(urlQueryItems: [URLQueryItem] = []) -> SRNetworkRequestManager<[ProductListModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getProducts, resourceType: [ProductListModel].self, urlQueryItems: urlQueryItems)
        
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
        return SRNetworkRequestManager(httpMethod: .get, path: .getShoppingCart, subpath: "/\(userId)", resourceType: SRShoppingCartResponseModel.self)
    }
    
    static func validateShoppingCart(userId: String,cartItemId: String) -> SRNetworkRequestManager<SRShoppingCartResponseModel> {
        
        return SRNetworkRequestManager(httpMethod: .get, path: .validateShoppingCart,subpath: "/\(userId)" + "/\(cartItemId)", resourceType: SRShoppingCartResponseModel.self)
    }
    
    static func removeItemFromShoppingCart(userId: String, cartItemId: String) -> SRNetworkRequestManager<SuccessResponse> {
        return SRNetworkRequestManager(httpMethod: .delete, path: .removeItemFromShoppingCart, subpath: "/\(userId)" + "/\(cartItemId)" , resourceType: SuccessResponse.self)
    }
    
    static func updateItemQuantity(userId: String, cartItemId: String) -> SRNetworkRequestManager<SuccessResponse> {
        return SRNetworkRequestManager(httpMethod: .put, path: .updateItemQuantity, subpath: "/\(userId)" + "/\(cartItemId)", resourceType: SuccessResponse.self)
    }
    
    static func addProductToShoppingCart(products: SRAddProductModel,userId: String) ->
    SRNetworkRequestManager<String> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.addProductToShoppingCart.rawValue)"
        return SRNetworkRequestManager(httpMethod: .post, path: .users, subpath: subpath, resourceType: String.self, httpBody: products.data, ignoreParse: true)
    }
    
    static func clearShoppingCart(userId: String) -> SRNetworkRequestManager<SuccessResponse> {
        return SRNetworkRequestManager(httpMethod: .delete, path: .clearShoppingCart,subpath: "/\(userId)" ,resourceType: SuccessResponse.self)
    }
    
    static func getShoppingCartCount(userId: String) -> SRNetworkRequestManager<Int> {
        let subpath = "\(userId)\(SRNetworkManagerPaths.getShoppingCartCount.rawValue)"
        return SRNetworkRequestManager(httpMethod: .get, path: .users, subpath: subpath, resourceType: Int.self)
    }
    
    static func failurePayment(orderId: String) -> SRNetworkRequestManager<SuccessResponse> {
        return SRNetworkRequestManager(httpMethod: .post, path: .failurePayment, subpath: "/\(orderId)", resourceType: SuccessResponse.self)
    }
    
    static func getSliders() -> SRNetworkRequestManager<[SRSliderDataModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getSliders, resourceType: [SRSliderDataModel].self)
    }
    
    static func getCategories() -> SRNetworkRequestManager<[SRCategoryResponseModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getCategories, resourceType: [SRCategoryResponseModel].self)
    }
    
    static func getSubCategories(categoryId: String) -> SRNetworkRequestManager<SRCategoryResponseModel> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getSubCategories, resourceType: SRCategoryResponseModel.self)
    }
    
    static func getShowCase() -> SRNetworkRequestManager<[SRShowcaseResponseModel]> {
        return SRNetworkRequestManager(httpMethod: .get, path: .getShowcase, resourceType: [SRShowcaseResponseModel].self)
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
    
}

