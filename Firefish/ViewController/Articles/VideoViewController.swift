//
//  VideoViewController.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        imageView.contentMode = .scaleAspectFill
        
        // 4
        let image = UIImage(named: "Banner")
        imageView.image = image
        navigationItem.titleView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
