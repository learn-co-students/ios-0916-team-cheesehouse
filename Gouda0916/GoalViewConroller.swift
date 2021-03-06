//
//  CreateGoalViewConroller.swift
//  Gouda0916
//
//  Created by Douglas Galante on 11/14/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class GoalViewController: UIViewController {
    let store = DataStore.sharedInstance
    let delegate = UIApplication.shared.delegate as? AppDelegate
    var thereIsCellExpanded = false
    var selectedRowIndex = -1
    var buttonTag = 0
    var menuShowing = false
    var menuIsShowing = false
    
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var goalTableView: UITableView!
    @IBOutlet weak var blackCoverView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if store.goals.isEmpty {
            self.performSegue(withIdentifier: "goalVCToCreateGoalVC", sender: self)
        }
        goalTableView.reloadData()
    }
    
    
    func pressedHamburger(sender: UITapGestureRecognizer) {
        if !menuShowing {
            NotificationCenter.default.post(name: .unhideBar, object: nil)
            menuShowing = true
            UIView.animate(withDuration: 0.3) {
                self.blackCoverView.alpha = 0.8
                self.view.layoutIfNeeded()
            }
        } else {
            NotificationCenter.default.post(name: .hideBar, object: nil)
            menuShowing = false
            UIView.animate(withDuration: 0.3) {
                self.blackCoverView.alpha = 0.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    func editIconTapped(_ sender: UITapGestureRecognizer) {
        if let senderView = sender.view {
            buttonTag = senderView.tag
        }
        performSegue(withIdentifier: "toEditGoal", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goalVCToCreateGoalVC" {
            let destVC = segue.destination as! CreateGoalViewController
            destVC.goalsTableView = goalTableView
        }
        
        if segue.identifier == "toEditGoal" {
            let destVC = segue.destination as! EditGoalViewController
            destVC.goal = store.goals[buttonTag]
            destVC.goalIndex = buttonTag
            destVC.delegate = self
        }
    }
    
    
    func setUpView() {
        for (index, goal) in store.goals.enumerated() {
            if goal.isActiveGoal == true {
                store.goals.remove(at: index)
                store.goals.insert(goal, at: 0)
                break
            }
        }
        
        if let delegate = delegate {
            delegate.backupFirebase(goals: store.goals)
        }

        navigationController?.navigationBar.isHidden = true
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(pressedHamburger))
        footerView.hamburgerMenuImageView.addGestureRecognizer(tapGesture)
        footerView.hamburgerMenuImageView.isUserInteractionEnabled = true
        let blackCoverTG = UITapGestureRecognizer.init(target: self, action: #selector(pressedHamburger))
        blackCoverView.addGestureRecognizer(blackCoverTG)
    }
}


//MARK: Table View Delegate and Datasource
extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.goals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as! CustomGoalCell
        cell.floatingView.goal = store.goals[indexPath.row]
        cell.floatingView.editIconImageView.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editIconTapped))
        cell.floatingView.editIconImageView.addGestureRecognizer(tapGesture)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex && thereIsCellExpanded || indexPath.row == 0 {
            return 260
        }
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedRowIndex != indexPath.row {
            thereIsCellExpanded = true
            selectedRowIndex = indexPath.row
        } else {
            thereIsCellExpanded = false
            selectedRowIndex = -1
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}


//MARK: Edit Gaol Delegate
protocol EditGoalDelegate {
    
    func resetTableView()
}


extension GoalViewController: EditGoalDelegate {
    
    func resetTableView() {
        self.selectedRowIndex = -1
        self.buttonTag = 0
        self.goalTableView.reloadData()
    }
}




