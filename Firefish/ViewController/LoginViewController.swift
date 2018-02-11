//
//  LoginViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

var fromAdd = false
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signBtn: UIButton!
    
    var userData = UserDefaultsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.email.delegate = self
        self.password.delegate = self
        self.signBtn.layer.cornerRadius = 2.5
        self.email.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSAttributedStringKey.foregroundColor : UIColor.yellow])
        self.password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor.yellow])
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @IBAction func didSignIn(_ sender: Any) {
        if self.email.text! == "" {
            Alerts.showAlert(alertMessage: "Email must be provided", alertTitle: "Required", viewController: self)
        }else if self.password.text! == "" {
            Alerts.showAlert(alertMessage: "Password can not be blank", alertTitle: "Required", viewController: self)
        }else{
            self.login()
        }
    }
    
    
    //MARK:- Show and hide keyboard -
    
    @objc func keyboardWillShow(notification:NSNotification){
        var punto = CGFloat()
        
        if let textfield = UIResponder.getCurrentFirstResponder() as? UITextField {
            punto = textfield.layer.anchorPoint.y
        }
        
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        self.scrollView.contentInset.bottom = keyboardFrame.size.height + 10
        self.scrollView.contentOffset = CGPoint(x: 0, y: punto)
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        self.scrollView.contentInset.bottom = UIEdgeInsets.zero.bottom
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
    //MARK:- Set extra
    func login() {
        
        let myURL = NSURL (string: "https://firefish.herokuapp.com/api/users/login")
        let request = NSMutableURLRequest(url: myURL! as URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST";
        let postString = "{\"user\":{\"email\":\"\(self.email.text!)\",\"password\":\"\(self.password.text!)\"}}"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
            if error != nil {
                print("error=\(error)")
            }else{
                if let httpResponse = response as? HTTPURLResponse {
                    do{
                        let json = try JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        DispatchQueue.main.async {
                            if httpResponse.statusCode == 200 {
                                let user = json.value(forKey: "user") as! NSDictionary
                            self.userData.setUserToken(user.value(forKey: "token") as! String)
                                self.userData.setUserName(self.email.text!)
                                self.userData.setUserPassword(self.password.text!)
                                
                                print("Token = \(self.userData.getUserToken())")
                                
                                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let destViewController = storyboard.instantiateViewController(withIdentifier: "MainNav") as! UINavigationController
                                self.present(destViewController, animated: false, completion: nil)
                            } else{
                              Alerts.showAlert(alertMessage: "Email and password does not match", alertTitle: "Try again!", viewController: self)
                            }
                        }
                    } catch let error as NSError {
                        DispatchQueue.main.async {
                            Alerts.showAlert(alertMessage: "Email and password does not match", alertTitle: "Try again!", viewController: self)
                        }
                    }
                    
                }
            }
        }
        task.resume()
    }
    

}
