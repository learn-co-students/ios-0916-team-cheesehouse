//
//  EditGoalViewController.swift
//  Gouda0916
//
//  Created by Douglas Galante on 11/30/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation
import UIKit

class EditGoalViewController: UIViewController {
    
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    
    var textForOptions = ["Set As Active Goal", "Saving Goal", "Savings For", "Saving On", "Timeframe", "Daily Budget?", "Delete"]
    
    
    //Collection View Cell Size and Spacing
    var spacing: CGFloat!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var numberOfCellsPerRow: CGFloat = 2
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension EditGoalViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textForOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = optionsCollectionView.dequeueReusableCell(withReuseIdentifier: "editGoalCell", for: indexPath) as! EditGoalCustomCell
        cell.backgroundColor = UIColor.themeAccentGoldColor
        cell.cellLabel.text = textForOptions[indexPath.row]
        return cell
    }
    
}

//MARK: Flow Layout
extension EditGoalViewController: UICollectionViewDelegateFlowLayout {
    
    func configureLayout () {
        
        let screenWidth = UIScreen.main.bounds.width
        let desiredSpacing: CGFloat = 15
        let whiteSpace: CGFloat = numberOfCellsPerRow + 1.0
        let itemWidth = (screenWidth - (whiteSpace * desiredSpacing)) / numberOfCellsPerRow
        let itemHeight = itemWidth
        
        spacing = desiredSpacing
        sectionInsets = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        itemSize = CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}


class EditGoalCustomCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
}
