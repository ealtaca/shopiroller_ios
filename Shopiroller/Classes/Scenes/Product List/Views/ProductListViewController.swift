//
//  ProductListViewController.swift
//  Shopiroller
//
//  Created by Görkem Gür on 25.10.2021.
//

import UIKit

class ProductListViewController: BaseViewController<ProductListViewModel> {
    
    private struct Constants {
        static var filterTitle: String { return "sort-title-text".localized }
        static var sortByTitle: String { return "filter-title-text".localized }
    }
    
    @IBOutlet weak var sortyByTitleLabel: UILabel!
    @IBOutlet weak var sortByImage: UIImageView!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var fitlerImage: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var filterProductsContainer: UIView!
    @IBOutlet private weak var emptyViewContainer: UIView!
    @IBOutlet private weak var emptyView: EmptyView!
    @IBOutlet private weak var collectionViewContainer: UIView!
    
    
    init(viewModel: ProductListViewModel){
        super.init(viewModel: viewModel, nibName: ProductListViewController.nibName, bundle: Bundle(for: ProductListViewController.self))
    }
    
    public override func setup() {
        super.setup()
        
        filterProductsContainer.layer.cornerRadius = 10
        filterProductsContainer.backgroundColor = .buttonLight
        filterProductsContainer.layer.masksToBounds = true
        filterProductsContainer.clipsToBounds = true
       
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(cellClass: ItemCollectionViewCell.self)
        
        filterTitleLabel.text = Constants.filterTitle
    
        filterTitleLabel.text = Constants.sortByTitle
    
        getProducts(pagination: true)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let backButton = UIBarButtonItem(customView: createNavigationItem(.backIcon , .goBack))
        let cartButton = UIBarButtonItem(customView: createNavigationItem(.cartIcon, .goToCard , true))
        let searchButton = UIBarButtonItem(customView: createNavigationItem(.searchIcon , .searchProduct))
        let shareButton = UIBarButtonItem(customView: createNavigationItem(.moreIcon , .openOptions))
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItems = [shareButton,searchButton,cartButton]
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.makeNavigationBar(.clear)
        
    }
    
    private func configureEmptyView() {
        if viewModel.getProductCount() == 0 {
            filterProductsContainer.isHidden = true
            collectionViewContainer.isHidden = true
            emptyViewContainer.isHidden = false
            emptyView.setup(model: viewModel.getEmptyModel())
        }else{
            collectionViewContainer.isHidden = false
            emptyViewContainer.isHidden = true
            filterProductsContainer.isHidden = false
            getCount()
        }
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
    
    private func getProducts(pagination: Bool) {
        viewModel.getProducts(pagination: pagination,succes: {
            [weak self] in
            guard let self = self else { return }
            self.productsCollectionView.reloadData()
            DispatchQueue.main.async {
                self.configureEmptyView()
            }
        }) {
            [weak self] (errorViewModel) in
            guard let self = self else { return }
        }
    }
    
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getProductCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellModel = viewModel.getProductModel()
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        cell.configureCell(viewModel: ProductViewModel(productListModel: cellModel?[indexPath.row]))
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 10, height: ((collectionView.frame.width / 2) - 10 ) * 254 / 155)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if (indexPath.row == viewModel.getProductCount() - 2){
            getProducts(pagination: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController(viewModel: ProductDetailViewModel(productId: viewModel.getProductId(position: indexPath.row)))
        prompt(vc, animated: true, completion: nil)
    }
    
}

