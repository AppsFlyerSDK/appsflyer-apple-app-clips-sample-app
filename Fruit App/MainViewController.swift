//
//  ViewController.swift
//  Fruit App
//
//  Created by Jonathan Wesfield on 12/07/2020.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func bananasPressed(_ sender: Any) {
        presentViewController(withFruit: .banana)
    }
    
    @IBAction func peachesPressed(_ sender: Any) {
        presentViewController(withFruit: .peaches)
    }
    
    @IBAction func applesPressed(_ sender: Any) {
        presentViewController(withFruit: .apple)
    }
    
    func presentViewController(withFruit fruit: Fruits) {
        
        let destinationViewController = FruitViewController()
        destinationViewController.fruit = fruit
        
        present(destinationViewController, animated: true, completion: nil)
    }
}

