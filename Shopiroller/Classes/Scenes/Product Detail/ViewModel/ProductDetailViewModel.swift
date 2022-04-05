//
//  ProductDetailViewModel.swift
//  shopiroller
//
//  Created by Görkem Gür on 7.10.2021.
//

import UIKit
import Kingfisher


public class ProductDetailViewModel: SRBaseViewModel {
    
    private var productId: String?
    private var productDetailModel: ProductDetailResponseModel?
    private var paymentSettings: PaymentSettingsResponeModel?
    
    var quantityCount = 1
    private var isPopUpState: Bool = false
    private var isUserFriendly: Bool = false
    
    init (productId: String = String()) {
        self.productId = productId
    }
    
    func getProductTerms(success: (() -> Void)? = nil, error: ((ErrorViewModel) -> Void)? = nil) {
        SRNetworkManagerRequests.getPaymentSettings().response() {
            (result) in
            switch result {
            case .success(let response):
                self.paymentSettings = response.data
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
    
    
    func getProductDetail(success: (() -> Void)? = nil, error: ((ErrorViewModel) -> Void)? = nil) {
        SRNetworkManagerRequests.getProduct(productId: self.productId ?? "").response() {
            (result) in
            switch result{
            case .success(let response):
                self.productDetailModel = response.data
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
    
    func addProductToCart(success : (() -> Void)? = nil , error: ((ErrorViewModel) -> Void)? = nil){
        SRNetworkManagerRequests.addProductToShoppingCart(products: SRAddProductModel(productId: self.productId, quantity: self.quantityCount, displayName: productDetailModel?.title), userId: SRAppContext.userId).response() {
            (result) in
            switch result {
            case.success(let response):
                if let count = response.data?.shoppingCardCount {
                    if count >= 10 {
                        SRAppContext.shoppingCartCount = "\(9)" + "+"
                    } else {
                        SRAppContext.shoppingCartCount = "\(count)"
                    }
                }
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name(SRAppConstants.UserDefaults.Notifications.updateShoppighCartObserve), object: nil)
                    success?()
                }
            case .failure(let err):
                DispatchQueue.main.async {
                    error?(ErrorViewModel(error: err))
                    self.isUserFriendly = err.isUserFriendlyMessage ?? false
                }
            }
        }
    }
    
    func getShoppingCartCount(success: (() -> Void)? = nil, error: ((ErrorViewModel) -> Void)? = nil) {
        SRGlobalRequestManager.getShoppingCartCount(success: success, error: error)
    }
    
    func getTitle() -> String? {
        return productDetailModel?.title
    }
    
    func getItemCount() -> Int? {
        return productDetailModel?.images?.count ?? 0
    }
    
    func getImages(position : Int) -> ProductImageModel? {
        return productDetailModel?.images?[position]
    }
    
    func getImageArray() -> [ProductImageModel]? {
        return productDetailModel?.images
    }
    
    func getBrandImage() -> String? {
        productDetailModel?.brand?.icon?.normal
    }
    
    func isOutofStock() -> Bool {
        return productDetailModel?.stock == 0
    }
    
    func isShippingFree() -> Bool {
        return productDetailModel?.shippingPrice == 0.0
    }
    
    func isUseFixPrice() -> Bool {
        return productDetailModel?.useFixPrice == true
    }
    
    func hasDiscount() -> Bool {
        return productDetailModel?.campaignPrice != nil && productDetailModel?.campaignPrice != 0
    }
    
    func getCurrency() -> String {
        return productDetailModel?.currency?.currencySymbol ?? ""
    }
    
    func hasSituation() -> Bool {
        return (isShippingFree() || isOutofStock()) && !isUseFixPrice()
    }
    
    func getShippingPrice() -> String {
        return String(productDetailModel?.shippingPrice ?? 0.0)
    }
    
    func getPrice() -> String {
        return String(productDetailModel?.price ?? 0.0)
    }
    
    func getCampaignPrice() -> String {
        return String(productDetailModel?.campaignPrice ?? 0.0)
    }
    
    var discount: String {
        let discount = ""
        return discount.calculateDiscount(price: productDetailModel?.price ?? 0.0, campaignPrice: productDetailModel?.campaignPrice ?? 0.0)
    }
    
    func getMaxQuantity() -> Int {
        return productDetailModel?.maxQuantityPerOrder ?? 0
    }
    
    func getStockCount() -> Int {
        return productDetailModel?.stock ?? 0
    }
    
    func isProductReachMaximumAddLimit() -> Bool {
        return productDetailModel?.maxQuantityPerOrder == quantityCount || productDetailModel?.stock == quantityCount
    }
    
    func getMaxQuantityCount() -> String {
        return productDetailModel?.maxQuantityPerOrder?.description ?? ""
    }
    
    func getReturnExchangeTerms() -> String? {
        return paymentSettings?.cancellationProcedure
    }
    
    func getDeliveryTerms() -> String? {
        return paymentSettings?.deliveryConditions
    }
    
    func getDescription() -> String? {
        return productDetailModel?.description
    }
    
    func getAppId() -> String? {
        return SRAppContext.aliasKey
    }
    
    func getReturnExchangePopUpViewModel() -> PopUpViewModel {
        return PopUpViewModel(image: .deliveryTerms, title: getCancellationProdecureTitle(), description: nil , firstButton: PopUpButtonModel(title: "product-detail-back-to-product-button-text".localized, type: .lightButton), secondButton: nil, htmlDescription: getReturnExchangeTerms()?.convertHtml())
    }
    
    func getDeliveryTermsPopUpViewModel() -> PopUpViewModel {
        return PopUpViewModel(image: .deliveryTerms, title: getDeliveryConditionsTitle(), description: nil , firstButton: PopUpButtonModel(title: "product-detail-back-to-product-button-text".localized, type: .lightButton), secondButton: nil, htmlDescription :  getDeliveryTerms()?.convertHtml())
    }
    
    func getSoldOutPopUpViewModel() -> PopUpViewModel {
        isPopUpState = true
        return PopUpViewModel(image: .outOfStock, title: "product-detail-out-of-stock-title".localized, description: "product-detail-out-of-stock-description".localized , firstButton: PopUpButtonModel(title: "product-detail-back-to-product-list-button-text".localized, type: .lightButton), secondButton: nil)
    }
    
    func getMaxQuantityPopUpViewModel() -> PopUpViewModel {
        return PopUpViewModel(image: .outOfStock, title: "product-detail-maximum-product-quantity-title".localized, description: String(format: "product-detail-maximum-product-quantity-description".localized, "\(productDetailModel?.maxQuantityPerOrder ?? 0)") , firstButton: PopUpButtonModel(title: "product-detail-back-to-product-button-text".localized, type: .lightButton), secondButton: nil)
    }
    
    func getProductNotFoundPopUpViewModel() -> PopUpViewModel {
        return PopUpViewModel(image: .outOfStock, title: "product-detail-product-not-found-title".localized, description: "product-detail-product-not-found-description".localized, firstButton: nil, secondButton: PopUpButtonModel(title: "general-ok-button-text".localized, type: .darkButton))
    }
    
    func isStateSoldOut() -> Bool {
        return isPopUpState
    }
    
    func isUserFriendlyMessage() -> Bool {
        return self.isUserFriendly
    }
    
    func getDeliveryConditionsTitle() -> String {
        if let deliveryConditionTitle = paymentSettings?.deliveryConditionsTitle ,
        deliveryConditionTitle != "" {
            return deliveryConditionTitle
        } else {
            return "delivery-terms-title".localized
        }
    }
    
    func getCancellationProdecureTitle() -> String {
        if let cancellationProdecureTitle = paymentSettings?.cancellationProcedureTitle ,
        cancellationProdecureTitle != "" {
            return cancellationProdecureTitle
        } else {
            return "return-exchange-terms-title".localized
        }
    }
    
}
