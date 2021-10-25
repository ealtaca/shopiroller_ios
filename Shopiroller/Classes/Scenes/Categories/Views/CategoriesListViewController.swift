//
//  CategoriesListViewController.swift
//  Shopiroller
//
//  Created by Görkem Gür on 22.10.2021.
//

import UIKit

class CategoriesListViewController: BaseViewController<CategoriesListViewModel> {
    
    @IBOutlet private weak var showAllSubCategoriesContainer: UIView!
    @IBOutlet private weak var showAllSubCategoriesTitle: UILabel!
    @IBOutlet private weak var categoriesTableView: UITableView!

    init(viewModel: CategoriesListViewModel){
        super.init(viewModel: viewModel, nibName: CategoriesListViewController.nibName, bundle: Bundle(for: CategoriesListViewController.self))
    }
    
    public override func setup() {
        super.setup()
        
        showAllSubCategoriesContainer.layer.cornerRadius = 15
        showAllSubCategoriesContainer.layer.borderWidth = 1
        showAllSubCategoriesContainer.layer.borderColor = UIColor.textPCaption.withAlphaComponent(0.3).cgColor
        showAllSubCategoriesContainer.layer.masksToBounds = true
        showAllSubCategoriesContainer.clipsToBounds = true
       
        
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(cellClass: CategoriesListCell.self)
        categoriesTableView.separatorStyle = .none
        
        if viewModel.isSubCategory == true {
            showAllSubCategoriesContainer.isHidden = false
            showAllSubCategoriesTitle.text = viewModel.getTitle()
        }else {
            showAllSubCategoriesContainer.isHidden = true
        }
        navigationController?.isNavigationBarHidden = false
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem(customView: createNavigationItem(.backIcon , .goBack))
        let cartButton = UIBarButtonItem(customView: createNavigationItem(.cartIcon, .goToCard , true))
        let searchButton = UIBarButtonItem(customView: createNavigationItem(.searchIcon , .searchProduct))
        let shareButton = UIBarButtonItem(customView: createNavigationItem(.moreIcon , .openOptions))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [shareButton,searchButton,cartButton]
        navigationController?.navigationBar.makeNavigationBar(.clear)
        
        getCount()
        
    }
    
    private func getCount() {
        viewModel.getShoppingCartCount(succes: {
            [weak self] in
            guard let self = self else { return }
        }) {
            [weak self] (errorViewModel) in
            guard let self = self else { return }
        }
    }
    
    func setSubCategories(position: Int){
        let vc = CategoriesListViewController(viewModel: CategoriesListViewModel(categoryList: viewModel.categoryList?[position].subCategories, isSubCategory: true,selectedRowName: viewModel.getSelectedRowName()))
        prompt(vc, animated: true, completion: nil)
    }
    
}

extension CategoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getModel()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: CategoriesListCell.reuseIdentifier) as! CategoriesListCell
        cell.selectionStyle = .none
        cell.setupCategories(model: self.viewModel.getModel()?[indexPath.row] ?? SRCategoryResponseModel())
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.hasSubCategory(position: indexPath.row){
            viewModel.setSelectedRowName(position: indexPath.row)
            self.setSubCategories(position: indexPath.row)
        }else {
            let vc = ProductListViewController(viewModel: ProductListViewModel(categoryId: viewModel.categoryList?[indexPath.row].categoryId))
            prompt(vc, animated: true, completion: nil)
        }
        
    }
}