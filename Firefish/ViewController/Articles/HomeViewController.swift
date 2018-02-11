//
//  HomeViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var content = [HomeData]()
    var filteredContent = [HomeData]()
    var indexSelected = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        getItems()
        self.searchText.delegate = self
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
    
    //MARK:- To show and hide keyboard
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func didSelectBtn(_ sender: UIButton) {
        self.indexSelected = sender.tag
        print("Filter = \(self.filteredContent[sender.tag].typePost)")
        
        if self.filteredContent[sender.tag].typePost == "article" {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destViewController = storyboard.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
            destViewController.id = self.filteredContent[sender.tag]
            self.present(destViewController, animated: false, completion: nil)
        } else if self.filteredContent[sender.tag].typePost == "video" {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destViewController = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            destViewController.id = self.filteredContent[sender.tag]
            self.present(destViewController, animated: false, completion: nil)
        }else if self.filteredContent[sender.tag].typePost == "image" {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let destViewController = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
            destViewController.id = self.filteredContent[sender.tag]
            self.present(destViewController, animated: false, completion: nil)
        }
    }
    
    //MARK:- Server integration
    func getItems() {
        self.content = [HomeData]()
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/articles",
            method: .get)
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                DispatchQueue.main.async {
                    let response = JSON as! Array<NSDictionary>
                    for item in response {
                        self.content.append(HomeData(id: item.value(forKey: "id") as! String,
                                                     name: item.value(forKey: "title") as! String,
                                                     numComments: 0,
                                                     datePublished: item.value(forKey: "published") as! String,
                                                     typePost: item.value(forKey: "type") as! String))
                    }
                    self.didFilter()
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                Alerts.showAlert(alertMessage: "", alertTitle: "No Articles piblished", viewController: self)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
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
        switch self.filteredContent[indexPath.row].typePost! {
        case "video":
            cell.photo.image = UIImage(named: "video")
        case "article":
            cell.photo.image = UIImage(named: "article")
        case "image":
            cell.photo.image = UIImage(named: "imageIcon")
        default:
            break;
        }
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(self.didSelectBtn(_:)), for: .touchUpInside)
        return cell
    }

}
