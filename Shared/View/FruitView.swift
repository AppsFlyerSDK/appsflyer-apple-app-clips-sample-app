//
//  FruitView.swift
//  Fruit App
//
//

import Foundation
import UIKit

class FruitView : UIView {
    
    var headerView: UIView!
    var titleLabel: UILabel!
    var imageView: UIImageView!
    let screenSize =  UIScreen.main.bounds

    init(image : UIImage, title : String, color : UIColor) {
        super.init(frame: CGRect(x: 10, y: 40, width: screenSize.width - 20, height: screenSize.height - 190));

        self.imageView  = UIImageView(frame:CGRect(x:100, y:100, width:screenSize.width - 200, height:200))
        self.imageView.image = image
        self.imageView.layer.cornerRadius = 10
        self.imageView.contentMode = .scaleAspectFit
        self.setHeader(title: title)
        
        self.backgroundColor = color
        self.layer.cornerRadius = 20
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.imageView)
    }
    
    func setHeader(title : String){

        headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
        headerView.backgroundColor = .white
        headerView.layer.cornerRadius = 10

        self.addSubview(headerView)

        titleLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: self.frame.size.width, height: 50))
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 40)
        headerView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
}
