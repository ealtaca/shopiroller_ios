//
//  AddressListViewController.swift
//  Shopiroller
//
//  Created by abdllhyalcn on 27.10.2021.
//

import UIKit

class AddressListViewController: BaseViewController<AddressListViewModel> {

    @IBOutlet private weak var addressTable: UITableView!
    @IBOutlet private weak var emptyView: EmptyView!
    @IBOutlet weak var addButton: UIButton!
    
    init(viewModel: AddressListViewModel){
        super.init(viewModel: viewModel, nibName: AddressListViewController.nibName, bundle: Bundle(for: AddressListViewController.self))
    }
    
    override func setup() {
        super.setup()
        getAddressList()
    }
    
    private func configure(isUpdate: Bool) {
        if(viewModel.isListEmpty()){
            addressTable.isHidden = true
            emptyView.isHidden = false
            emptyView.setup(model: viewModel.getEmptyModel())
        }else{
            addressTable.isHidden = false
            emptyView.isHidden = true
            if(!isUpdate){
                addressTable.register(cellClass: AddressTableViewCell.self)
                addressTable.delegate = self
                addressTable.dataSource = self
                addressTable.reloadData()
            }
        }
    }
    
    private func getAddressList() {
        viewModel.getAddressList(success: {
            self.configure(isUpdate: false)
        }) { (errorViewModel) in
            self.view.makeToast(errorViewModel)
        }
    }
    
    private func deleteAddress() {
        viewModel.deleteAddress(success: {
            guard let row = self.viewModel.selectedIndexPathRow else {return}
            self.addressTable.deleteRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            self.view.makeToast(text: "address_list_delete_success".localized)
            self.configure(isUpdate: true)
        }) { (errorViewModel) in
            self.view.makeToast(errorViewModel)
        }
    }
}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource, AddressTableViewCellDelegate {
    
    func deleteButtonClicked(indexPathRow: Int?) {
        viewModel.selectedIndexPathRow = indexPathRow
        deleteAddress()
    }
    
    func editButtonClicked(indexPathRow: Int?) {
        //TODO: ADD ACTION
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getListSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressTableViewCell.reuseIdentifier, for: indexPath) as! AddressTableViewCell
        cell.delegate = self
        switch viewModel.state {
        case .shipping:
            guard let model = viewModel.getShippingAddress(position: indexPath.row) else { return cell}
            cell.setup(model: model, indexPathRow: indexPath.row)
        case .billing:
            guard let model = viewModel.getBillingAddress(position: indexPath.row) else { return cell}
            cell.setup(model: model, indexPathRow: indexPath.row)
        }
        
        return cell
    }
}