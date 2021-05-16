//
//  ViewController.swift
//  FoodAppDemo
//
//  Created by Aakash Uppal on 16/05/21.
//  Copyright © 2021 Aakash Uppal. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mealsCollection: UICollectionView!
    
    var arrMeals = [Meals]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPITogetMeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mealsCollection.reloadData()
    }
    
    @IBAction func txtDidChange(_ sender: UITextField) {
        callAPITogetMeals(txt: sender.text ?? "", loader: false)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMeals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealsCollectionViewCell", for: indexPath) as! MealsCollectionViewCell
        cell.imgView.setImage(arrMeals[indexPath.item].strMealThumb ?? "")
        cell.lblName.text = arrMeals[indexPath.item].strMeal ?? ""
        cell.btnFavourite.tag = indexPath.item
        cell.btnFavourite.isSelected = Constant.favouriteMeals?.contains(where: {$0.idMeal == arrMeals[indexPath.item].idMeal}) ?? false
        cell.btnFavourite.addTarget(self, action: #selector(btnFavAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: arrMeals[indexPath.item].strSource ?? "") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width/2) - 30, height: (collectionView.frame.size.width/2))
    }
    
    @objc func btnFavAction(_ sender: UIButton) {
        if let index = Constant.favouriteMeals?.firstIndex(where: {$0.idMeal == arrMeals[sender.tag].idMeal}) {
            Constant.favouriteMeals?.remove(at: index)
        } else {
            Constant.favouriteMeals?.append(arrMeals[sender.tag])
        }
        self.encodeFavouriteData(data: Constant.favouriteMeals ?? [Meals]())
        self.mealsCollection.reloadData()
    }
}

extension HomeViewController {
    func callAPITogetMeals(txt: String = "", loader: Bool = true) {
        RVApiManager.getAPI(Apis.searchMeals+txt.replacingOccurrences(of: " ", with: "%20"),parameters: [String:Any](),Vc: self, showLoader: loader) { [weak self] (data : HomeModal) in
            self?.arrMeals = data.meals ?? [Meals]()
            self?.mealsCollection.reloadData()
        }
    }
}
