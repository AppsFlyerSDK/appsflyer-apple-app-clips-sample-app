//
//  ApplesViewController.swift
//  Fruit App
//
//

import Foundation
import UIKit

class ApplesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fv = FruitView(image: UIImage(named: "apples.jpeg")!,
                           title: "Apples",
                           color: UIColor(red: 60/255.0, green: 186/255.0, blue: 84/255.0, alpha: 1.00))
        self.view.addSubview(fv)
    }
}
