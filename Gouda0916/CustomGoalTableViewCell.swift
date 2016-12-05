//
//  CustomGoalTableViewCell.swift
//  Gouda0916
//
//  Created by Douglas Galante on 11/19/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit

class CustomGoalCell: UITableViewCell {
    
    weak var customView: GoalTableViewCellView!
    weak var delegate: GoalViewController?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCustomViewWithFrame()
    }
    
    func initCustomViewWithFrame() {
        let x = self.contentView.bounds.origin.x
        let y = self.contentView.bounds.origin.y
        let width = UIScreen.main.bounds.width
        let height = self.contentView.bounds.height * 2
        let frame = CGRect(x: x, y: y, width: width, height: height)
        let view = GoalTableViewCellView(frame: frame)
        
        self.customView = view
        if let customView = customView {
            self.contentView.addSubview(customView)
        }
        
        customView.editButton.addTarget(self, action: #selector(buttonTapped), for: UIControlEvents.touchUpInside)
    
    }
    
    func buttonTapped(_ sender: UIButton) {
        delegate?.editButtonTapped(withIndex: sender.tag)
        print("index of button in table view: \(customView.editButton.tag)")
    }
    
    

    
}

