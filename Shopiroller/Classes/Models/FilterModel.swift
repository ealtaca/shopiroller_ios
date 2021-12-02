//
//  FilterModel.swift
//  Shopiroller
//
//  Created by abdllhyalcn on 30.11.2021.
//

import Foundation

struct FilterModel {
    var categoryIds: SelectionIds = SelectionIds()
    var brandIds: SelectionIds = SelectionIds()
    var variationGroups: [VariationIds] = []
    var minimumPrice: Double?
    var maximumPrice: Double?
    var showCaseId: String? = nil
    var stockSwitch: Bool = false
    var discountedProductsSwitch: Bool = false
    var freeShippingSwitch: Bool = false
    
    func getQueryArray() -> [URLQueryItem] {
        var urlQueryItems: [URLQueryItem] = []
        if(!categoryIds.selectedIds.isEmpty) {
            urlQueryItems.append(contentsOf: categoryIds.selectedIds.map{URLQueryItem(name: SRAppConstants.Query.Keys.categoryId, value: $0) })
        }
        if(!brandIds.selectedIds.isEmpty) {
            urlQueryItems.append(contentsOf: brandIds.selectedIds.map{URLQueryItem(name: SRAppConstants.Query.Keys.brandId, value: $0) })
        }
        // TODO: VariationGroups removed in filter section until next phase
        /*if(!variationGroups.isEmpty) {
            for item in variationGroups {
                urlQueryItems.append(contentsOf: brandIds.selectedIds.map{URLQueryItem(name: SRAppConstants.Query.Keys.categoryId, value: $0) })
            }
        }*/
        if let minimumPrice = minimumPrice {
            urlQueryItems.append(URLQueryItem(name: SRAppConstants.Query.Keys.priceMin, value: String(minimumPrice)))
        }
        if let maximumPrice = maximumPrice {
            urlQueryItems.append(URLQueryItem(name: SRAppConstants.Query.Keys.priceMax, value: String(maximumPrice)))
        }
        if let showCaseId = showCaseId {
            urlQueryItems.append(URLQueryItem(name: SRAppConstants.Query.Keys.showcaseId, value: showCaseId))
        }
        if(stockSwitch) {
            urlQueryItems.append(URLQueryItem(name: SRAppConstants.Query.Keys.stockMin, value: String(1)))
        }
        if(discountedProductsSwitch) {
            urlQueryItems.append(URLQueryItem(name: SRAppConstants.Query.Keys.isThereCampaign, value: String(discountedProductsSwitch)))
        }
        if(freeShippingSwitch) {
            urlQueryItems.append(URLQueryItem(name: SRAppConstants.Query.Keys.shippingPrice, value: String(0)))
        }
        return urlQueryItems
    }
    
    func hasQueryItem(urlQueryItems: [URLQueryItem]) -> Bool {
        return urlQueryItems.isEmpty
    }
}

struct VariationIds {
    let variationGroupsItemId: String?
    var variationIds: SelectionIds = SelectionIds()
}

struct SelectionIds {
    let selectedIds: [String]
    let selectionNameLabel: String
    
    init(selectedIds: [String] = [], selectionNameLabel: String = String()) {
        self.selectedIds = selectedIds
        self.selectionNameLabel = selectionNameLabel
    }
}
