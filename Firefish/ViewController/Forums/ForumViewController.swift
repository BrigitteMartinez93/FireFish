//
//  ForumViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class ForumViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var content = [HomeData]()
    var filteredContent = [HomeData]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fromAdd = false
        getItems()
        self.searchText.delegate = self
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        addBtn.layer.cornerRadius = 4.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.tableView.addGestureRecognizer(tap)
    }

    @IBAction func didSearch(_ sender: Any) {
        didFilter()
    }
    
    @IBAction func didAdd(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destViewController = storyboard.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.present(destViewController, animated: false, completion: nil)
    }
    
    func didFilter() {
        if self.searchText.text! == "" {
            self.filteredContent = self.content
        }else{
            filteredContent = [HomeData]()
            for i in content {
                var nameArray = [String]()
                nameArray = i.name.components(separatedBy: " ")
                for item in nameArray {
                    if item.lowercased() == searchText.text!.lowercased() {
                        if !filteredContent.contains(where: {$0.id == i.id}) {
                            self.filteredContent.append(i)
                        }
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.endEditing(true)
        self.didFilter()
    }
    
    @objc func didSelectBtn(_ sender: UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let destViewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        destViewController.id = self.filteredContent[sender.tag]
        self.present(destViewController, animated: false, completion: nil)
    }
    
    //MARK:- To show and hide keyboard
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK:- Server integration
    func getItems() {
        self.content = [HomeData]()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/topics",
            method: .get)
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                DispatchQueue.main.async {
                    let response = JSON as! Array<NSDictionary>
                    for item in response {
                        self.content.append(HomeData(id: item.value(forKey: "id") as! String,
                                                     name: item.value(forKey: "title") as! String,
                                                     numComments: item.value(forKey: "comments") as! Int,
                                                     datePublished: item.value(forKey: "published") as! String,
                                                     typePost: item.value(forKey: "type") as! String))
                    }
                    self.didFilter()
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

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.filteredContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumCell", for: indexPath) as! ForumCell

        cell.title.text! = self.filteredContent[indexPath.row].name
        cell.datePublished.text! = dateToString(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", fromDate: self.filteredContent[indexPath.row].datePublished)
        cell.numComments.text! = "\(self.filteredContent[indexPath.row].numComments!)"
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(self.didSelectBtn(_:)), for: .touchUpInside)
        return cell
    }
}

