//
//  HomeViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var content = [HomeData]()
    var filteredContent = [HomeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredContent = content
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        imageView.contentMode = .scaleAspectFill
        
        // 4
        let image = UIImage(named: "Banner")
        imageView.image = image
        navigationItem.titleView = imageView
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.tableView.addGestureRecognizer(tap)
    }
    
    @IBAction func didSearch(_ sender: Any) {
        didFilter()
    }
    
    func didFilter() {
        if self.searchText.text! == "" {
            self.filteredContent = self.content
        }else{
            filteredContent = [HomeData]()
            for i in content {
                if  i.name == self.searchText.text! {
                    self.filteredContent.append(i)
                }
            }
        }

        self.tableView.reloadData()
    }
    
    func setPicker() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.didSearch(_:)))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        self.searchText.inputAccessoryView = toolBar
    }
    
    //MARK:- To show and hide keyboard
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK:- Server integration
    func getItems() {
        self.content = [HomeData]()
//        self.activityIndicator.isHidden = false
//        self.activityIndicator.startAnimating()
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/mock/topics",
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
                }
            case .failure(let error):
                print("Error = \(error.localizedDescription)")
//                self.activityIndicator.isHidden = true
//                self.activityIndicator.stopAnimating()
                break;
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeCell
        cell.title.text! = self.filteredContent[indexPath.row].name
        cell.datePublished.text! = dateToString(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", fromDate: self.filteredContent[indexPath.row].datePublished)
        return cell
    }
}
