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
        presentVC(vc: BananasViewController())
    }
    
    @IBAction func peachesPressed(_ sender: Any) {
        presentVC(vc: PeachesViewController())
    }
    
    @IBAction func applesPressed(_ sender: Any) {
        presentVC(vc: ApplesViewController())
    }
    
    func presentVC(vc : UIViewController){
        self.present(vc, animated: true, completion: nil)
    }
}

