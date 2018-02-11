//
//  CommentsViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class CommentsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var newComment: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var id: HomeData!
    var content = [Comments]()
    var filteredContent = [Comments]()
    var body = String()
    var userData = UserDefaultsData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDescription()
        self.newComment.delegate = self
        name.text! = id.name
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.tableView.addGestureRecognizer(tap)
    }

    @IBAction func didBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didSend(_ sender: Any) {
        sendComment()
    }
    
    //MARK:- To show and hide keyboard
    
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
    
    //MARK:- Server integration
    func getDescription() {
        self.content = [Comments]()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/topic/\(self.id.id!)",
            method: .get)
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                DispatchQueue.main.async {
                    let response = JSON as! NSDictionary
                    self.content.append(
                            Comments(id: self.id.id!,
                                     user: self.userData.getUserName(),
                                     body: response.value(forKey: "body") as! String,
                                     datePost: self.id.datePublished))
                    self.getComments()
                }
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                break;
            }
        }
    }
    
    func sendComment(){
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/topic/\(self.id.id!)/comments",
            method: .post,
            parameters: ["body":self.newComment.text!],
            headers: ["Authorization": "Token \(self.userData.getUserToken())", "Content-Type": "application/x-www-form-urlencoded"])
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                self.newComment.text! = ""
                let response = JSON as! Array<NSDictionary>
                for item in response {
                    self.content.append(Comments(id: item.value(forKey: "id") as! String,
                                                     user: item.value(forKey: "name") as! String,
                                                     body: item.value(forKey: "body") as! String,
                                                     datePost: item.value(forKey: "date") as! String))
                }
                self.tableView.reloadData()
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            case .failure(let error):
                Alerts.showAlert(alertMessage: "It was not possible to send your comment", alertTitle: "Please, try agaib", viewController: self)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func getComments() {
        self.content = [Comments]()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/topic/\(self.id.id!)/comments",
            method: .get)
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                DispatchQueue.main.async {
                    let response = JSON as! Array<NSDictionary>
                    for item in response {
                        self.content.append(Comments(id: item.value(forKey: "id") as! String,
                                                     user: item.value(forKey: "name") as! String,
                                                     body: item.value(forKey: "body") as! String,
                                                     datePost: item.value(forKey: "date") as! String))
                    }
                    self.tableView.reloadData()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                break;
                }
        }
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("content.count = \(self.content.count)")
        print("content = \(self.content)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsCell
        cell.name.text! = self.content[indexPath.row].user
        cell.body.text! = self.content[indexPath.row].body
        cell.datePublished.text! = dateComments(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", fromDate: self.content[indexPath.row].datePost)
        return cell
    }
}
