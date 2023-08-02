//
//  TabbarController.swift
//  CurrencyConverterApp
//
//  Created by 정해석 on 2023/08/01.
//

import Foundation
import UIKit


class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tabBar.items?[0].title = "Picke"
        
        self.tabBar.items?[0].image = UIImage(systemName: "filemenu.and.selection")
        
        self.tabBar.items?[1].title = "Table"
        
        self.tabBar.items?[1].image = UIImage(systemName: "list.bullet")
    }
}
