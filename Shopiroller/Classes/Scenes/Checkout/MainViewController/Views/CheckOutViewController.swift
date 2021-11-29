//
//  CheckOutViewController.swift
//  Shopiroller
//
//  Created by Görkem Gür on 1.11.2021.
//

import UIKit
import MaterialComponents.MaterialButtons

class CheckOutViewController: BaseViewController<CheckOutViewModel> {
    
    private struct Constants {
        static var confirmOrderButtonText: String { "confirm-order-button-text".localized }
    }
    
    @IBOutlet private weak var checkOutProgress: CheckOutProgress!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var nextPageButton: MDCFloatingButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var viewControllerTitle: UILabel!
    @IBOutlet private weak var confirmOrderButtonContainer: UIView!
    @IBOutlet private weak var confirmOrderButton: UIButton!
    
    var index = 0
    
    private var checkOutPageViewController: CheckOutPageViewController?
    
    init(viewModel: CheckOutViewModel){
        super.init(viewModel.getPageTitle()?.localized, viewModel: viewModel, nibName: CheckOutViewController.nibName, bundle: Bundle(for: CheckOutViewController.self))
    }
    
    override func setup() {
        super.setup()
        
        let checkOutPageViewController = CheckOutPageViewController(checkOutPageDelegate: self)
        addChild(checkOutPageViewController)
        checkOutPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(checkOutPageViewController.view)
        
        checkOutPageViewController.view.frame = containerView.frame
        
        self.navigationController?.navigationBar.isHidden = true
        
        checkOutPageViewController.didMove(toParent: self)
        
        self.viewControllerTitle.text = "delivery-information-page-title".localized
        
        self.checkOutPageViewController = checkOutPageViewController
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(onResultEvent), name: Notification.Name(SRAppConstants.UserDefaults.Notifications.orderInnerResponseObserve), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadPayment), name: Notification.Name(SRAppConstants.UserDefaults.Notifications.updatePaymentMethodObserve), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadAddress), name: Notification.Name(SRAppConstants.UserDefaults.Notifications.updateAddressMethodObserve), object: nil)
    }
    
    @objc func loadPayment() {
        checkOutProgress.configureView(stage: .payment)
        setTitle(stage: .payment)
        isHidingNextButton(hide: false)
        setButton()
        self.view.layoutIfNeeded()
    }
    
    @objc func loadAddress() {
        checkOutProgress.configureView(stage: .address)
        setTitle(stage: .address)
        isHidingNextButton(hide: false)
        setButton()
        self.view.layoutIfNeeded()
    }
    
    @objc func onResultEvent() {
        let orderResponse = SRSessionManager.shared.orderResponseInnerModel
        
        if (orderResponse != nil && orderResponse?.order?.paymentType == PaymentTypeEnum.Online3DS) && (orderResponse?.payment != nil && orderResponse?.payment?._3DSecureHtml != nil) {
            let threeDSViewController = ThreeDSModalViewController(viewModel: ThreeDSModalViewModel(urlToOpen: orderResponse?.payment?._3DSecureHtml))
            threeDSViewController.modalPresentationStyle = .overCurrentContext
            present(threeDSViewController, animated: true, completion: nil)
        } else if (orderResponse != nil && orderResponse?.order?.paymentType == PaymentTypeEnum.Transfer) {
            loadOrderResultSuccess(orderResponse: orderResponse ?? SROrderResponseInnerModel(),isCreditCard : false)
        } else if (orderResponse != nil && orderResponse?.order?.paymentType == PaymentTypeEnum.PayAtDoor) {
            loadOrderResultSuccess(orderResponse: orderResponse ?? SROrderResponseInnerModel(), isCreditCard: false)
        }
    }
    
    private func loadOrderResultSuccess(orderResponse : SROrderResponseInnerModel , isCreditCard : Bool) {
        let resultVC = SRResultViewController(viewModel: viewModel.getResultPageModel(isCreditCard : isCreditCard))
        self.prompt(resultVC, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped() {
        checkOutPageViewController?.goToNextPage()
        switch index {
        case 1:
            checkOutProgress.configureView(stage: .payment)
            setTitle(stage: .payment)
        case 2:
            checkOutProgress.configureView(stage: .info)
            setTitle(stage: .info)
            isHidingNextButton(hide: true)
            setButton()
        default:
            checkOutProgress.configureView(stage: .address)
            setTitle(stage: .address)
        }
    }
    
    @IBAction func backButtonTapped() {
        checkOutPageViewController?.goToPreviousPage()
        switch index {
        case 1:
            checkOutProgress.configureView(stage: .payment)
            setTitle(stage: .payment)
            isHidingNextButton(hide: false)
            setButton()
        case 0:
            checkOutProgress.configureView(stage: .address)
            setTitle(stage: .address)
        default:
            break
        }
        setButton()
    }
    
    
    private func setButton() {
        confirmOrderButtonContainer.isHidden = !nextPageButton.isHidden
        confirmOrderButtonContainer.backgroundColor = .textPrimary
        confirmOrderButton.setTitle(Constants.confirmOrderButtonText)
        confirmOrderButton.setTitleColor(.white)
    }
    
    private func setTitle(stage : ProgressStageEnum) {
        switch stage {
        case .address:
            self.viewControllerTitle.text = "delivery-information-page-title".localized
        case .payment:
            self.viewControllerTitle.text = "payment-information-page-title".localized
        case .info:
            self.viewControllerTitle.text =
            "info-information-page-title".localized
        }
    }
    
    @IBAction func confirmButtonTapped() {
        NotificationCenter.default.post(name: Notification.Name(SRAppConstants.UserDefaults.Notifications.userConfirmOrderObserve), object: nil)
    }
}

extension CheckOutViewController : CheckOutProgressPageDelegate {
    func isEnabledNextButton(enabled: Bool?) {
        if enabled == true {
            self.nextPageButton.isUserInteractionEnabled = true
            self.nextPageButton.backgroundColor = .black
        } else {
            self.nextPageButton.isUserInteractionEnabled = false
            self.nextPageButton.backgroundColor = .black.withAlphaComponent(0.35)
        }
    }
    
    func isHidingNextButton(hide: Bool?) {
        if hide == true {
            self.nextPageButton.isHidden = true
        } else {
            self.nextPageButton.isHidden = false
        }
    }
    
    
    func popLastViewController() {
        self.pop(animated: true, completion: nil)
    }
    
    func showSuccessfullToastMessage() {
        self.view.makeToast(String(format: "address-bottom-view-address-saved-text".localized),position: ToastPosition.bottom)
    }
    
    func currentPageIndex(currentIndex: Int) {
        self.index = currentIndex
        print(currentIndex)
    }
    
}