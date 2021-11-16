//
//  AddressSelectTableViewCell.swift
//  Shopiroller
//
//  Created by Görkem Gür on 9.11.2021.
//

import UIKit

protocol AddressPopUpSelectedDelegate {
    func getIndex(shippingAddressIndex : Int? , billingAddressIndex: Int?)
}

class AddressSelectTableViewCell: UITableViewCell {
    @IBOutlet private weak var addressTitle: UILabel!
    @IBOutlet private weak var addressFirstLine: UILabel!
    @IBOutlet private weak var addressSecondLine: UILabel!
    @IBOutlet private weak var addressThirdLine: UILabel!
    @IBOutlet private weak var rightArrowImage: UIImageView!
    
    private var billingAddressIndex : Int?
    private var shippingAddressIndex: Int?
    
    var delegate : AddressPopUpSelectedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addressTitle.textColor = .textPrimary
        addressTitle.font = UIFont.boldSystemFont(ofSize: 14)
        
        addressFirstLine.textColor = .textPCaption
        addressFirstLine.font = UIFont.systemFont(ofSize: 12)
        addressFirstLine.lineBreakMode = .byTruncatingTail
    
        addressSecondLine.textColor = .textPCaption
        addressSecondLine.font = UIFont.systemFont(ofSize: 12)
        addressSecondLine.adjustsFontSizeToFitWidth = false
        addressSecondLine.lineBreakMode = .byTruncatingTail
        
        addressThirdLine.textColor = .textPCaption
        addressThirdLine.font = UIFont.systemFont(ofSize: 12)
        addressThirdLine.adjustsFontSizeToFitWidth = false
        addressThirdLine.lineBreakMode = .byTruncatingTail
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        
    }

    func setupBillingCell(model: UserBillingAdressModel?, index: Int){
        addressTitle.text = model?.title
        addressFirstLine.text = model?.getPopupAddressFirstLine()
        addressSecondLine.text = model?.getPopupAddressSecondLine()
        addressThirdLine.text = model?.getPopupAddressThirdLine()
        billingAddressIndex = index
    }
    
    func setupShippingCell(model: UserShippingAddressModel?, index: Int){
        addressTitle.text = model?.title
        addressFirstLine.text = model?.getPopupAddressFirstLine()
        addressSecondLine.text = model?.getPopupAddressSecondLine()
        addressThirdLine.text = model?.getPopupAddressThirdLine()
        shippingAddressIndex = index
    }
    
    @objc func cellTapped() {
        delegate?.getIndex(shippingAddressIndex: shippingAddressIndex, billingAddressIndex: billingAddressIndex)
    }
    
}