//
//  BananasViewController.swift
//  Fruit App
//
//

import Foundation
import UIKit

class BananasViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fv = FruitView(image: UIImage(named: "bananas.jpeg")!,
                           title: "Bananas",
                           color: UIColor(red: 244/255.0, green: 194/255.0, blue: 13/255.0, alpha: 1.00))
        self.view.addSubview(fv)

    }

}
