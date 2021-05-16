
//
//  HomeModal.swift
//  FoodAppDemo
//
//  Created by Aakash Uppal on 16/05/21.
//  Copyright © 2021 Aakash Uppal. All rights reserved.
//

import Foundation

struct HomeModal : Codable {
    var meals: [Meals]?
}

struct Meals : Codable {
    var idMeal : String?
    var strMeal : String?
    var strMealThumb : String?
    var strSource : String?
}
