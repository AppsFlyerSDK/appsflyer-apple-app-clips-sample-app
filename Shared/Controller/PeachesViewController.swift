//
//  PeachesViewController.swift
//  Fruit App
//
//

import Foundation
import UIKit

class PeachesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fv = FruitView(image: UIImage(named: "peaches.jpeg")!,
                           title: "Peaches",
                           color: UIColor.orange)
        self.view.addSubview(fv)
    }
}
