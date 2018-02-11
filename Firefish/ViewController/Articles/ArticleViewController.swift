//
//  ArticleViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class ArticleViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var id: HomeData!
    var body = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableViewAutomaticDimension
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        imageView.contentMode = .scaleAspectFill
        
        // 4
        let image = UIImage(named: "Banner")
        imageView.image = image
        navigationItem.titleView = imageView
        getArticleDetail()
    }
    
    @IBAction func didBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Get info
    
    func getArticleDetail() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        Alamofire.request(
        "https://firefish.herokuapp.com/api/articles/hack/article/\(self.id.id!)",
        method: .get)
        .validate()
        .responseJSON { response in switch response.result {
            case .success(let JSON):
                DispatchQueue.main.async {
                    let response = JSON as! NSDictionary
                    self.body = response.value(forKey: "body") as! String
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

extension ArticleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
            cell.title.text! = self.id.name
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell2", for: indexPath) as! ArticleCell
            cell.body.text! = self.body
            return cell
        }

    }
}
