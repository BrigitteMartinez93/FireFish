//
//  VideoViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit
import Alamofire

class VideoViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var id: HomeData!
    var code = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        imageView.contentMode = .scaleAspectFill
        
        // 4
        let image = UIImage(named: "Banner")
        imageView.image = image
        navigationItem.titleView = imageView
        
        self.name.text! = self.id.name
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        getVideoDetail()
    }
    
    @IBAction func didBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didDisplayVideo() {
        let link = URL(string: "https://www.youtube.com/embed/\(self.code)")
        self.webView.loadRequest(URLRequest(url: link!))
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    //MARK:- Get info
    
    func getVideoDetail() {
        Alamofire.request(
            "https://firefish.herokuapp.com/api/articles/hack/article/\(self.id.id!)",
            method: .get)
            .validate()
            .responseJSON { response in switch response.result {
            case .success(let JSON):
                DispatchQueue.main.async {
                    let response = JSON as! NSDictionary
                    self.code = response.value(forKey: "body") as! String
                self.didDisplayVideo()
                }
            case .failure(let error):
                Alerts.showAlert(alertMessage: error.localizedDescription, alertTitle: "Error", viewController: self)
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                break;
            }
        }
    }
}
