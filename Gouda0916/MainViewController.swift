//
//  MainViewController2.swift
//  Gouda0916
//
//  Created by Marie Park on 12/5/16.
//  Copyright © 2016 Flatiron. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import CoreData
import CoreGraphics


class MainViewController: UIViewController {

    let store = DataStore.sharedInstance
    let rootRef = "https://gouda0916-4bb79.firebaseio.com/"
    var menuIsShowing = false
    let velocity = Velocity()

    @IBOutlet weak var viewForPercentLabels: UIView!
    @IBOutlet weak var gradient: UIView!
    @IBOutlet weak var addNewGoalView: UIView!
    @IBOutlet weak var didYouSpendTodayView: UIView!
    @IBOutlet weak var blackOverlayView: UIView!
    @IBOutlet weak var completedGoalView: UIView!
    @IBOutlet weak var viewForInfo: UIView!
    @IBOutlet weak var addGoalImageView: UIImageView!
    @IBOutlet weak var completedYesCheckmarkImageView: UIImageView!
    @IBOutlet weak var progressPercentLabel: UILabel!
    @IBOutlet weak var daysPercentLabel: UILabel!
    @IBOutlet weak var velocityPercentLabel: UILabel!
    @IBOutlet weak var didSpendTodayLabel: UILabel!
    @IBOutlet weak var alreadySpentTodayLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var logDayButton: UIButton!
    @IBOutlet weak var daysInfoButton: UIButton!
    @IBOutlet weak var velocityInfoButton: UIButton!
    @IBOutlet weak var progressInfoButton: UIButton!
    @IBOutlet weak var footerView: FooterView!
    @IBOutlet weak var userInputTextField: UITextField!
    @IBOutlet weak var didYouSubmitTrailingConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    @IBAction func velocityInfoButton(_ sender: Any) {
        viewForPercentLabels.isHidden = true
        viewForInfo.isHidden = false
        infoLabel.text = "Velocity shows your average score over the past three days."
    }

    
    @IBAction func progressInfoButton(_ sender: Any) {
        viewForPercentLabels.isHidden = true
        viewForInfo.isHidden = false
        infoLabel.text = "Progress shows the percentage of completion towards your goal."
    }


    @IBAction func daysInfoButton(_ sender: Any) {
        viewForPercentLabels.isHidden = true
        viewForInfo.isHidden = false
        infoLabel.text = "Days shows the percentage of days completed."
    }
    

    @IBAction func exitInfoButtonClicked(_ sender: Any) {
        viewForPercentLabels.isHidden = false
        viewForInfo.isHidden = true

    }


    func hideAndUnhideInfoButtons(_ addView: Bool) {
        if addView {
            daysInfoButton.isHidden = false
            velocityInfoButton.isHidden = false
            progressInfoButton.isHidden = false
        } else {
            daysInfoButton.isHidden = true
            velocityInfoButton.isHidden = true
            progressInfoButton.isHidden = true
        }
    }


    func checkButtonTapped() {
        completedGoalView.isHidden = true
        NotificationCenter.default.post(name: .openMainVC, object: nil)
        store.velocityHistory = [Velocity.lastCentury : 0]
        store.velocity = 0
    }

    
    @IBAction func xButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.didYouSubmitTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { success in
            self.userInputTextField.resignFirstResponder()
            self.userInputTextField.isHidden = false
            self.submitButton.isHidden = false
            self.didSpendTodayLabel.isHidden = false
            self.alreadySpentTodayLabel.isHidden = true
        })
    }


    @IBAction func goToGoalVC(_ sender: UIButton) {
        NotificationCenter.default.post(name: .openGoalVC, object: nil)
    }
    

    @IBAction func logDayButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.didYouSubmitTrailingConstraint.constant = UIScreen.main.bounds.width
            self.view.layoutIfNeeded()
        }, completion: { success in
            self.userInputTextField.becomeFirstResponder()
        })
        
        if let first = store.goals.first {
            if let enteredSpending = first.loggedGoalToday {
                if enteredSpending {
                    userInputTextField.isHidden = true
                    submitButton.isHidden = true
                    didSpendTodayLabel.isHidden = true
                    alreadySpentTodayLabel.isHidden = false
                }
            }
        }
    }
    

    func menuButtonPressed(_ sender: Any) {
        if !menuIsShowing {
            logDayButton.isEnabled = false
            logDayButton.titleLabel?.textColor = UIColor.themeLightGrayColor
            NotificationCenter.default.post(name: .unhideBar, object: nil)
            menuIsShowing = true
            UIView.animate(withDuration: 0.3) {
                self.blackOverlayView.alpha = 0.8
                self.view.layoutIfNeeded()
            }
        } else {
            logDayButton.isEnabled = true
            logDayButton.titleLabel?.textColor = UIColor.themeBlackColor
            NotificationCenter.default.post(name: .hideBar, object: nil)
            menuIsShowing = false
            UIView.animate(withDuration: 0.3) {
                self.blackOverlayView.alpha = 0
                self.view.layoutIfNeeded()
            }
        }
    }

    
    func calculateProgress() {
        guard let checkSaved = store.goals.first?.currentAmountSaved else { print ("nothing saved"); return }
        guard let checkGoalAmount = store.goals.first?.goalAmount else {print ("no goal"); return}
        let progressPercentage = (checkSaved/checkGoalAmount)
        store.progress = 812.0 * progressPercentage
        progressPercentLabel.text = "\(Int(progressPercentage * 100))%"
    }
    

    func numberOfDaysLeft (startDate: Date, goalEntity: [Goal]) -> Int {
        let currentDate = Date()
        let timeSinceStartDateInSeconds = currentDate.timeIntervalSince((goalEntity.first?.startDate)! as Date)
        let timeSinceStartDateInDays = timeSinceStartDateInSeconds/(24*60*60)
        let daysLeft = (DataStore.sharedInstance.goals.first?.timeframe)! - Double(timeSinceStartDateInDays)
        print(Int(daysLeft))
        return Int(daysLeft)
    }

    
    func daysPercentCalculation() {
        if let first = store.goals.first {
            let dayPercentage = first.dayCounter/first.timeframe
            store.days = CGFloat(dayPercentage * 312.0)
            daysPercentLabel.text = "\(Int(dayPercentage * 100))%"
        }
    }
    

    func updateVelocityForCircle() {
        let roundedVelocity = Double(store.currentVelocityScore).rounded()
        velocityPercentLabel.text = String(roundedVelocity)

        let velocityPercentage = store.velocity * 0.1
        store.velocity = velocityPercentage * 552
    }
    

    func checkIfGoalExists() {
        if store.goals.isEmpty {
            logDayButton.isHidden = true
            addNewGoalView.isHidden = false
            footerView.hamburgerMenuImageView.isHidden = true
        } else {
            addNewGoalView.isHidden = true
            footerView.hamburgerMenuImageView.isHidden = false
            logDayButton.isHidden = false
        }
    }

    
    func setUpMenuButtonGesture() {
        let tapGR = UITapGestureRecognizer.init(target: self, action: #selector(menuButtonPressed))
        footerView.hamburgerMenuImageView.addGestureRecognizer(tapGR)
    }
    

    func setGradient() {
        let startingColorOfGradient = UIColor.themePaleGreenColor.cgColor
        let endingColorOFGradient = UIColor.themeLightPrimaryBlueColor.cgColor
        let gradient1: CAGradientLayer = CAGradientLayer()
        gradient1.frame = gradient.bounds
        gradient1.colors = [startingColorOfGradient , endingColorOFGradient]
        self.gradient.layer.insertSublayer(gradient1, at: 0)
    }
    
    
    func setUpView() {
        navigationController?.navigationBar.isHidden = true
        setGradient()
        calculateProgress()
        daysPercentCalculation()
        checkIfGoalExists()
        setUpMenuButtonGesture()
        setUpTextFieldForValidation()
        updateVelocityForCircle()
        completedGoalView.isHidden = true
        viewForInfo.isHidden = true
        checkIfProgressHasBeenLogged()
        velocity.updateGraph(for: "This Week")
        let sortedVelocityHistory = store.velocityHistory.sorted(by: { $0.0 > $1.0 })
        
        if let currentDay = sortedVelocityHistory.first {
            store.currentVelocityScore = currentDay.value
            velocityPercentLabel.text = "\(store.currentVelocityScore)"
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(goToGoalVC))
        addGoalImageView.addGestureRecognizer(tapGR)
        
        let checkTapGR = UITapGestureRecognizer(target: self, action: #selector(checkButtonTapped))
        completedYesCheckmarkImageView.addGestureRecognizer(checkTapGR)
        
        let blackOverlayGesture = UITapGestureRecognizer(target: self, action: #selector(menuButtonPressed))
        blackOverlayView.addGestureRecognizer(blackOverlayGesture)
        
        hideAndUnhideInfoButtons(addNewGoalView.isHidden)
    }
}

//MARK: - Handling user input
extension MainViewController: UserInputProtocol {

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        let stayedUnderBudget = checkForVelocity(goal: store.goals.first!, textField: userInputTextField)
        updateVelocity(success: stayedUnderBudget)

        if let goal = store.goals.first {
            incrementDayAndAmount(goal: goal, textField: userInputTextField)
            checkIfComplete(goal: goal) { (success) in
                if success {
                    completedGoalView.isHidden = false
                    store.clearVelocity()
                } else {
                    print("🐹YOU DIDNT REACH YOUR GOAL YET")
                }
            }
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.didYouSubmitTrailingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { success in
                self.userInputTextField.resignFirstResponder()
                if goal.goalAmount > goal.currentAmountSaved {
                    NotificationCenter.default.post(name: .openMainVC, object: nil)
                }
            })
        }
        velocity.updateGraph(for: "This Week")
        velocityPercentLabel.text = "\(store.currentVelocityScore)"
    }

    
    func checkIfProgressHasBeenLogged() {
        if let first = store.goals.first {
            if let loggedGoalToday = first.loggedGoalToday {
                if !loggedGoalToday {
                    logDayButtonTapped(logDayButton)
                }
            }
        }
    }
    

    func setUpTextFieldForValidation() {
        userInputTextField.addTarget(self, action: #selector(checkForTextFieldEdit), for: UIControlEvents.editingChanged)
    }
    

    func checkForTextFieldEdit(_ textField: UITextField) {
        if let input = textField.text {
            let validInput = Double(input) != nil
            if validInput {
                textField.textColor = UIColor.themeBlackColor
                submitButton.titleLabel?.textColor = UIColor.themeAccentGoldColor
                submitButton.isUserInteractionEnabled = true
            } else {
                textField.textColor = .red
                submitButton.titleLabel?.textColor = UIColor.themeLightGrayColor
                submitButton.isUserInteractionEnabled = false
            }
        }
    }
}
