//
//  ImageViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {

    var id: HomeData!
    var body = String()
    var link = String()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.name.text! = self.id.name
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        getImageDetail()
    }

    //MARK:- Get info
    @IBAction func didBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getImageDetail() {

        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/article/\(self.id.id!)",
            method: .get)
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                DispatchQueue.main.async {
                    let response = JSON as! NSDictionary
                    self.body = response.value(forKey: "body") as! String
                    self.link = response.value(forKey: "link") as! String
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

extension ImageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.body != "" {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageCell
            if self.link != "" {
                print("link = \(link)")
                getDataFromUrl(url: URL(string: self.link)!) { (data, response, error)  in
                    guard let data = data, error == nil else {
                        print("Error downloading image"); return}
                    DispatchQueue.main.async() { () -> Void in
                        cell.photo.image = UIImage(data: data)
                    }
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell2", for: indexPath) as! ImageCell
            cell.body.text! = self.body
            return cell
        }
    }
}
