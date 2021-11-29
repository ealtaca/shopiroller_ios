//
//  CheckOutPaymentViewController.swift
//  Shopiroller
//
//  Created by Görkem Gür on 1.11.2021.
//

import UIKit
import InputMask

class CheckOutPaymentViewController: BaseViewController<CheckOutPaymentViewModel> {
    
    private struct Constants {
        
        static var selectPaymentMethodText : String { return "checkout-payment-select-payment-method-text".localized }
        static var selectedPaymentMethodCreditCart : String { return "checkout-payment-selected-payment-method-credit-cart-placeholder".localized }
        static var selectedPaymentMethodBankTransfer : String { return "checkout-payment-selected-payment-method-transfer-bank-placeholder".localized}
        static var selectedPaymentMethodPayAtTheDoor : String { return "checkout-payment-selected-payment-method-pay-at-the-door-placeholder".localized }
        static var creditCartHolderNamePlaceholder : String { return "checkout-payment-credit-card-holder-placeholder".localized }
        static var creditCartNumberPlaceholder : String { return "checkout-payment-credit-card-number-placeholder".localized }
        static var creditCartExpireDatePlaceholder : String { return "checkout-payment-credit-card-expire-date-placeholer".localized }
        static var creditCartCvvPlaceholder : String { return "checkout-payment-credit-card-cvv-placeholder".localized }
        static var payAtTheDoorDescription: String {
            return "checkout-payment-pay-at-the-door-description".localized
        }
    }
    
    
    @IBOutlet private weak var contentContainerView: UIView!
    @IBOutlet private weak var paymentEmptyView: EmptyView!
    @IBOutlet private weak var selectPaymentMethodView: UIView!
    @IBOutlet private weak var selectMethodTitle: UILabel!
    @IBOutlet private weak var selectedMethodTitle: UILabel!
    @IBOutlet private weak var selectMethodRightArrow: UIImageView!
    @IBOutlet private weak var methodTitleView: UIView!
    @IBOutlet private weak var selectedMethodViewTitle: UILabel!
    @IBOutlet private weak var titleUnderLineView: UIView!
    @IBOutlet private weak var creditCartContainer: UIView!
    @IBOutlet private weak var creditCartHolderNameTextField: UITextField!
    @IBOutlet private weak var creditCartNumberTextField: UITextField!
    @IBOutlet private weak var creditCartImageView: UIImageView!
    @IBOutlet private weak var creditCartExpireDateTextField: UITextField!
    @IBOutlet private weak var creditCartCvvTextField: UITextField!
    @IBOutlet private weak var bankTransferContainer: UIView!
    @IBOutlet private weak var bankTransferTableView: UITableView!
    @IBOutlet private weak var payAtTheDoorDescription: UILabel!
    @IBOutlet private weak var payAtTheDoorContainer: UIView!
    
    var delegate : CheckOutProgressPageDelegate?
    var creditCardNumberListener: MaskedTextFieldDelegate!
    var creditCardExpireDateListener: MaskedTextFieldDelegate!
    var creditCardCvvListener: MaskedTextFieldDelegate!
    
    private var isValid: Bool = false
    
    init(viewModel: CheckOutPaymentViewModel){
        super.init(viewModel: viewModel, nibName: CheckOutPaymentViewController.nibName, bundle: Bundle(for:  CheckOutPaymentViewController.self))
    }
    
    override func setup() {
        super.setup()
        
        creditCardNumberListener = MaskedTextFieldDelegate()
        creditCardExpireDateListener = MaskedTextFieldDelegate()
        creditCardCvvListener = MaskedTextFieldDelegate()
        
        selectPaymentMethodView.backgroundColor = .buttonLight.withAlphaComponent(0.77)
        selectPaymentMethodView.layer.cornerRadius = 6
        selectMethodTitle.textColor = .textSecondary
        selectMethodTitle.font = UIFont.systemFont(ofSize: 13)
        selectMethodTitle.text = Constants.selectPaymentMethodText
        
        titleUnderLineView.backgroundColor = .veryLightBlue
        
        selectMethodRightArrow.image = UIImage(systemName: "chevron.right")
        selectMethodRightArrow.tintColor = .textPCaption
        
        selectedMethodTitle.textColor = .textPCaption
        selectedMethodTitle.font = UIFont.systemFont(ofSize: 12)
        
        selectedMethodViewTitle.textColor = .textPCaption
        selectedMethodViewTitle.font = UIFont.systemFont(ofSize: 12)
        
        creditCartHolderNameTextField.backgroundColor = .buttonLight.withAlphaComponent(0.7)
        creditCartHolderNameTextField.layer.cornerRadius = 6
        creditCartHolderNameTextField.delegate = self
        creditCartHolderNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: creditCartHolderNameTextField.frame.height))
        creditCartHolderNameTextField.leftViewMode = .always
        creditCartHolderNameTextField.placeholder = Constants.creditCartHolderNamePlaceholder

        creditCartNumberTextField.backgroundColor = .buttonLight.withAlphaComponent(0.7)
        creditCartNumberTextField.layer.cornerRadius = 6
        creditCartNumberTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: creditCartNumberTextField.frame.height))
        creditCartNumberTextField.delegate = creditCardNumberListener
        creditCartNumberTextField.leftViewMode = .always
        creditCartNumberTextField.textContentType = .creditCardNumber
        creditCartNumberTextField.keyboardType = .numberPad
        creditCardNumberListener.delegate = self
        creditCardNumberListener.primaryMaskFormat =
                     "[0000] [0000] [0000] [0000]"
        creditCardNumberListener.affinityCalculationStrategy = .prefix
        creditCartNumberTextField.placeholder = Constants.creditCartNumberPlaceholder
        
        creditCartExpireDateTextField.backgroundColor = .buttonLight.withAlphaComponent(0.7)
        creditCartExpireDateTextField.layer.cornerRadius = 6
        creditCartExpireDateTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: creditCartExpireDateTextField.frame.height))
        creditCartExpireDateTextField.delegate = creditCardExpireDateListener
        creditCartExpireDateTextField.leftViewMode = .always
        creditCartExpireDateTextField.keyboardType = .numberPad
        creditCardExpireDateListener.delegate = self
        creditCardExpireDateListener.primaryMaskFormat =
            "[00]{/}[00]"
        creditCardExpireDateListener.affinityCalculationStrategy = .prefix
        creditCartExpireDateTextField.placeholder = Constants.creditCartExpireDatePlaceholder
        
        
        creditCartCvvTextField.backgroundColor = .buttonLight.withAlphaComponent(0.7)
        creditCartCvvTextField.layer.cornerRadius = 6
        creditCartCvvTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: creditCartCvvTextField.frame.height))
        creditCartCvvTextField.delegate = creditCardCvvListener
        creditCartCvvTextField.leftViewMode = .always
        creditCartCvvTextField.keyboardType = .numberPad
        creditCardCvvListener.delegate = self
        creditCardCvvListener.primaryMaskFormat = "[000]"
        creditCardCvvListener.affinityCalculationStrategy = .prefix
        creditCartCvvTextField.placeholder = Constants.creditCartCvvPlaceholder
        
        
        
        let addressSelectTapGesture = UITapGestureRecognizer(target: self, action: #selector(openPaymentList))
        selectPaymentMethodView.isUserInteractionEnabled = true
        selectPaymentMethodView.addGestureRecognizer(addressSelectTapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPaymentSettings()
    }
    
    private func getPaymentSettings() {
        viewModel.getPaymentSettings(success: {
            self.configureEmptyView()
        })
        { [weak self] (errorViewModel) in
            guard let self = self else { return }
        }
    }
    
    private func configureEmptyView() {
        if viewModel.arePaymentSettingsEmpty() {
            contentContainerView.isHidden = true
            paymentEmptyView.isHidden = false
            paymentEmptyView.setup(model: viewModel.getEmptyViewModel())
            delegate?.isHidingNextButton(hide: true)
        } else {
            delegate?.isHidingNextButton(hide: false)
            configureView()
            checkIsValid()
        }
    }
    
    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        switch textField {
        case creditCartHolderNameTextField:
            viewModel.creditCardHolder = textField.text
        default:
            break
        }
        
        validateCreditCardFields()
    }
    
    
    private func configureView() {
        switch viewModel.getDefaultPaymentMethod() {
        case .Transfer:
            bankTransferContainer.isHidden = false
            bankTransferTableView.register(cellClass: BankTransferTableViewCell.self)
            bankTransferTableView.delegate = self
            bankTransferTableView.dataSource = self
            bankTransferTableView.reloadData()
            payAtTheDoorContainer.isHidden = true
            creditCartContainer.isHidden = true
            selectedMethodViewTitle.text = Constants.selectedPaymentMethodBankTransfer.uppercased()
            selectedMethodTitle.text = Constants.selectedPaymentMethodBankTransfer
        case .Online , .Online3DS:
            bankTransferContainer.isHidden = true
            payAtTheDoorContainer.isHidden = true
            creditCartContainer.isHidden = false
            selectedMethodViewTitle.text = Constants.selectedPaymentMethodCreditCart.uppercased()
            selectedMethodTitle.text = Constants.selectedPaymentMethodCreditCart
        case .PayPal:
            bankTransferContainer.isHidden = true
            creditCartContainer.isHidden = true
            payAtTheDoorContainer.isHidden = true
            selectedMethodViewTitle.text = PaymentTypeEnum.PayPal.rawValue.uppercased().localized
            selectedMethodTitle.text = PaymentTypeEnum.PayPal.rawValue
        case .PayAtDoor:
            bankTransferContainer.isHidden = true
            creditCartContainer.isHidden = true
            payAtTheDoorContainer.isHidden = false
            selectedMethodViewTitle.text = Constants.selectedPaymentMethodPayAtTheDoor.uppercased()
            selectedMethodTitle.text = Constants.selectedPaymentMethodPayAtTheDoor
            payAtTheDoorDescription.font = UIFont.systemFont(ofSize: 14)
            payAtTheDoorDescription.textColor = .textPCaption
            payAtTheDoorDescription.text = Constants.payAtTheDoorDescription
        case .none:
            break
        case .Stripe:
            print("Stripe")
        case .Stripe3DS:
            print("Stripe3DS")
        }
    }
    
    private func checkIsValid() {
        isValid = (viewModel.getDefaultPaymentMethod() == .PayAtDoor || viewModel.getDefaultPaymentMethod() == .Online || viewModel.getDefaultPaymentMethod() == .Online3DS || viewModel.getDefaultPaymentMethod() == .Stripe  || viewModel.getDefaultPaymentMethod() == .Stripe3DS || viewModel.getDefaultPaymentMethod() == .PayPal || (viewModel.getDefaultPaymentMethod() == .Transfer && viewModel.paymentType != nil))
        if isValid == true {
            SRSessionManager.shared.paymentSettings = viewModel.getPaymentSettings()
            switch viewModel.getDefaultPaymentMethod() {
            case .PayPal:
                SRSessionManager.shared.orderEvent.paymentType = PaymentTypeEnum.PayPal.rawValue
            case .Transfer:
                setBankTransferUI()
                SRSessionManager.shared.orderEvent.paymentType = PaymentTypeEnum.Transfer.rawValue
            case .Online3DS, .Online:
                validateCreditCardFields()
                if viewModel.getDefaultPaymentMethod() == .Online {
                    SRSessionManager.shared.orderEvent.paymentType = PaymentTypeEnum.Online.rawValue
                } else {
                    SRSessionManager.shared.orderEvent.paymentType = PaymentTypeEnum.Online3DS.rawValue
                }
            case .PayAtDoor:
                SRSessionManager.shared.orderEvent.paymentType = PaymentTypeEnum.PayAtDoor.rawValue
                self.delegate?.isEnabledNextButton(enabled: true)
            case .none:
                break
            case .Stripe:
                print("Stripe")
            case .Stripe3DS:
                print("Stripe3DS")
            }
        }
    }
    
    private func setBankTransferUI() {
        if viewModel.isSelected  {
            delegate?.isEnabledNextButton(enabled: true)
        } else {
            delegate?.isEnabledNextButton(enabled: false)
        }
    }
    
    @objc func openPaymentList() {
        let vc = ListPopUpViewController(viewModel: ListPopUpViewModel(listType: .payment, supportedPaymentMethods: viewModel.getSupportedPaymentList()))
        vc.paymentDelegate = self
        popUp(vc)
    }
    
    private func validateCreditCardFields() {
        viewModel.isValid(success: { [weak self] in
            self?.delegate?.isEnabledNextButton(enabled: true)
        }) { [weak self] (errorViewModel) in
            self?.delegate?.isEnabledNextButton(enabled: false)
        }
    }
    
    
    
}

extension CheckOutPaymentViewController: ListPopUpPaymentDelegate {
    func getSelectedPayment(payment: PaymentTypeEnum) {
        viewModel.paymentType = payment
        self.configureEmptyView()
        self.view.layoutIfNeeded()
    }
}

extension CheckOutPaymentViewController: MaskedTextFieldDelegateListener {
    open func textField( _ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        if textField == creditCartNumberTextField {
            self.viewModel.creditCardNumber = value
            creditCartNumberTextField.rightViewImage = textField.text?.creditCardBrand
        }
        if textField == creditCartExpireDateTextField {
            if let expireDate = creditCartExpireDateTextField.text , expireDate.count == 5 {
                self.viewModel.creditCardExpireMonth = expireDate.components(separatedBy: "/")[0]
                self.viewModel.creditCardExpireYear = "20" + expireDate.components(separatedBy: "/")[1]
            }
        }
        if textField == creditCartCvvTextField {
            self.viewModel.creditCardCvv = value
        }
        validateCreditCardFields()
    }
}

extension CheckOutPaymentViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        default:
            guard let textField = textField as? UITextField else { break }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        default:
            guard let textField = textField as? UITextField else { break }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField {
        case creditCartHolderNameTextField:
            creditCartNumberTextField.becomeFirstResponder()
        case creditCartNumberTextField:
            creditCartExpireDateTextField.becomeFirstResponder()
        case creditCartExpireDateTextField:
            creditCartCvvTextField.becomeFirstResponder()
        case creditCartCvvTextField:
            self.validateCreditCardFields()
        default:
            break
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
         return true;
    }
}

extension CheckOutPaymentViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getBankAccountCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = viewModel.getBankAccountModel(position: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: BankTransferTableViewCell.reuseIdentifier, for: indexPath) as! BankTransferTableViewCell
        if viewModel.selectedBankIndex == indexPath.row {
            viewModel.isSelected = true
            setBankTransferUI()
        } else {
            viewModel.isSelected = false
        }
        cell.configureBankList(model: model,index: indexPath.row, isSelected: viewModel.isSelected)
        cell.delegate = self
        return cell
    }
}

extension CheckOutPaymentViewController: BankTransferCellDelegate {
    func tappedCopyIbanButton() {
        var style = ToastStyle()
        style.backgroundColor = .veryLightPink
        style.messageColor = .textPrimary
        style.messageFont = UIFont.systemFont(ofSize: 12)
        self.view.makeToast(String(format: "checkout-table-view-iban-copied-message".localized),position: ToastPosition.bottom,style: style)
    }
    
    func setSelectedBankIndex(index: Int?) {
        SRSessionManager.shared.orderEvent.bankAccount = viewModel.getBankAccountModel(position: index ?? 0)
        viewModel.selectedBankIndex = index
        bankTransferTableView.reloadData()
    }
}
    
