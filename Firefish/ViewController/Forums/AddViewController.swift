//
//  AddViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/11/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//
//  AddForumViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class AddViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var comments: UITextView!
    var userData = UserDefaultsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        comments.delegate = self
        name.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    @IBAction func didBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didAdd(_ sender: Any) {
        if self.name.text! == "" {
            Alerts.showAlert(alertMessage: "Title can not be empty", alertTitle: "Required", viewController: self)
        }else if comments.text! == "" {
            Alerts.showAlert(alertMessage: "Description can not be empty", alertTitle: "Required", viewController: self)
        }else {
            sendForum()
        }
    }
    
    func sendForum(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/topic",
            method: .post,
            parameters: ["body":self.comments.text!, "title": self.name.text!],
            headers: ["Authorization": "Token \(self.userData.getUserToken())", "Content-Type": "application/x-www-form-urlencoded"])
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                self.comments.text! = ""
                let response = JSON as! NSDictionary
                fromAdd = true
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let destViewController = storyboard.instantiateViewController(withIdentifier: "MainNav") as! UINavigationController
                self.present(destViewController, animated: false, completion: nil)
            case .failure(let error):
                Alerts.showAlert(alertMessage: "It was not possible to add this forum", alertTitle: "Please, try again", viewController: self)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextTextView = self.view.viewWithTag(nextTag) {
            nextTextView.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.commentsLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.commentsLabel.isHidden = false
        }else{
            self.commentsLabel.isHidden = true
        }
        self.view.endEditing(true)
    }
    
    
}

