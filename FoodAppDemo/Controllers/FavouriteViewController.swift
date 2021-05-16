//
//  FavouriteViewController.swift
//  FoodAppDemo
//
//  Created by Aakash Uppal on 16/05/21.
//  Copyright © 2021 Aakash Uppal. All rights reserved.
//

import UIKit
import SafariServices

class FavouriteViewController: UIViewController {

    @IBOutlet weak var mealsCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mealsCollection.reloadData()
    }
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constant.favouriteMeals?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MealsCollectionViewCell", for: indexPath) as! MealsCollectionViewCell
        cell.imgView.setImage(Constant.favouriteMeals?[indexPath.item].strMealThumb ?? "")
        cell.lblName.text = Constant.favouriteMeals?[indexPath.item].strMeal ?? ""
        cell.btnFavourite.tag = indexPath.item
        cell.btnFavourite.isSelected = true
        cell.btnFavourite.addTarget(self, action: #selector(btnFavAction(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: Constant.favouriteMeals?[indexPath.item].strSource ?? "") {
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
        Constant.favouriteMeals?.remove(at: sender.tag)
        self.encodeFavouriteData(data: Constant.favouriteMeals ?? [Meals]())
        self.mealsCollection.reloadData()
    }
}
