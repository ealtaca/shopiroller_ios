//
//  UserAddressViewController.swift
//  Shopiroller
//
//  Created by abdllhyalcn on 27.10.2021.
//

import UIKit
import MaterialComponents.MaterialButtons

class UserAddressViewController: BaseViewController<UserAddressViewModel> {
    
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var addButton: MDCFloatingButton!
    
    
    private var pageVC: AddressListPageViewController?
    
    init(viewModel: UserAddressViewModel){
        super.init("address_list_page_title".localized, viewModel: viewModel, nibName: UserAddressViewController.nibName, bundle: Bundle(for: UserAddressViewController.self))
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        updateNavigationBar(rightBarButtonItems: nil, isBackButtonActive: true)
    }
    
    override func setup() {
        super.setup()
        getCount()
        let pageVC = AddressListPageViewController(addressDelegate: self)
        addChild(pageVC)
        pageVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(pageVC.view)
        
        NSLayoutConstraint.activate([
            pageVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            pageVC.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0),
            pageVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0),
            pageVC.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0),
        ])
        
        pageVC.didMove(toParent: self)
        
        self.pageVC = pageVC
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            pageVC?.goToPreviousPage()
        }else{
            pageVC?.goToNextPage()
        }
    }
    
    private func getCount() {
        viewModel.getShoppingCartCount(success: {
            [weak self] in
            guard let self = self else { return }
        }) {
            [weak self] (errorViewModel) in
            guard let self = self else { return }
        }
    }
}

extension UserAddressViewController: AddressListPageDelegate {
    func pageViewController(currentIndex: Int) {
        segmentedControl.selectedSegmentIndex = currentIndex
    }
}
