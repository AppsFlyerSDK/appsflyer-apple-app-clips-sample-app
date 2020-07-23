//
//  FruitViewController.swift
//  Fruit App
//
//  Created by Andrii Hahan on 22.07.2020.
//

import UIKit

enum Fruits {
    case apple
    case banana
    case peaches
}

class FruitViewController: UIViewController {

    var fruit: Fruits?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fruitView: FruitView
        switch fruit {
        case .apple:
            fruitView = FruitView(image: UIImage(named: "apples.jpeg")!,
                                  title: "Apples",
                                  color: UIColor(red: 60/255.0, green: 186/255.0, blue: 84/255.0, alpha: 1.00))
            
        case .banana:
            fruitView = FruitView(image: UIImage(named: "bananas.jpeg")!,
                                  title: "Bananas",
                                  color: UIColor(red: 244/255.0, green: 194/255.0, blue: 13/255.0, alpha: 1.00))
            
        case .peaches:
            fruitView = FruitView(image: UIImage(named: "peaches.jpeg")!,
                                  title: "Peaches",
                                  color: UIColor.orange)
        case .none:
            fatalError()
        }
        view.addSubview(fruitView)
    }
}
