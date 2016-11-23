//
//  MainViewController.swift
//  Gouda0916
//
//  Created by Douglas Galante on 11/14/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class MainViewController: UIViewController {
    let store = DataStore.sharedInstance
    let rootRef = "https://gouda0916-4bb79.firebaseio.com/"
    
    let velocity = Velocity()
    let velocityScoreView = VelocityScoreView()
    
    // TODO: Fix
    @IBOutlet weak var ButtonBackground: UIView!
    @IBOutlet weak var buttonShadowBackground: UIView!
    @IBOutlet weak var failSuccessLabel: UILabel!
    
    @IBOutlet weak var failButton: UIButton!
    // TODO: Fix successButton misspelling
    @IBOutlet weak var sucessButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchData()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
        velocityScoreView.updateView()
        
    }
    
    
    @IBAction func failButtonTouched(_ sender: Any) {
        velocity.updateVelocityTracker(points: 0)
        failButton.isEnabled = false
        sucessButton.isEnabled = false
        
        updateFailSuccessLabel(status: "Do Better Tomorrow")
        
    }
    
    @IBAction func successButtonTouched(_ sender: Any) {
        failButton.isEnabled = false
        sucessButton.isEnabled = false
        
        
        updateFailSuccessLabel(status: "Success!!")
    }
    
    func updateView() {
        ButtonBackground.layer.masksToBounds = true
        ButtonBackground.layer.cornerRadius = 3.0
        
        buttonShadowBackground.layer.masksToBounds = true
        buttonShadowBackground.layer.cornerRadius = 3.0
        buttonShadowBackground.layer.shadowColor = UIColor.black.cgColor
        buttonShadowBackground.layer.shadowOpacity = 0.6
        buttonShadowBackground.layer.shadowRadius = CGFloat(5)
        buttonShadowBackground.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
    }
    
    func updateFailSuccessLabel(status: String) {
        failSuccessLabel.text = status
    }
    
    func updateVelocityScoreLabel() {
    }
    
    
    
}
