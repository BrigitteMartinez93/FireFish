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

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        imageView.contentMode = .scaleAspectFill
        
        // 4
        let image = UIImage(named: "Banner")
        imageView.image = image
        navigationItem.titleView = imageView
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        return cell
    }
}
