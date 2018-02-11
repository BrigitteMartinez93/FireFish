//
//  ForumViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit

class ForumViewController: UIViewController {

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didSearch(_ sender: Any) {
    }
    
}

extension ForumViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forumCell", for: indexPath) as! ForumCell
        return cell
    }
}
