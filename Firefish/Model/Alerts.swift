//
//  Alerts.swift
//  Firefish
//
//  Created by Brigitte on 2/10/18.
//  Copyright © 2018 Nativapps. All rights reserved.
//

import Foundation
import UIKit
class Alerts {
    
    static  func showAlert (alertMessage : String , alertTitle : String , viewController : UIViewController) {
        
        //Create the AlertController
        let actionSheetController: UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        actionSheetController.view.tintColor = UIColor.black
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Present the AlertController
        viewController.present(actionSheetController, animated: true, completion: nil)
        
    }
}
