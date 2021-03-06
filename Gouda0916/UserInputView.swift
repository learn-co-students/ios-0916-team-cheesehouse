//
//  UserInputView.swift
//  Gouda0916
//
//  Created by Douglas Galante on 11/29/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

class UserInputView: UIView {
    
    @IBOutlet weak var floatingView: UIView!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    func commonInit() {
        let startingColorOfGradient = UIColor.themePaleGreenColor.cgColor
        let endingColorOFGradient = UIColor.themeLightPrimaryBlueColor.cgColor
        let gradient: CAGradientLayer = CAGradientLayer()
        Bundle.main.loadNibNamed("UserInputView", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        gradient.frame = contentView.bounds
        gradient.colors = [startingColorOfGradient , endingColorOFGradient]
        self.floatingView.layer.insertSublayer(gradient, at: 0)
    }
}

