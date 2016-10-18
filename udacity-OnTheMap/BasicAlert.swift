//
//  BasicAlert.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import Foundation
import UIKit


func showBasicAlert(onController controller: UIViewController, withTitle title: String?, message: String?, onOkPressed: ((_ action: UIAlertAction) -> Void)?) {
  let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
  let okAction = UIAlertAction(title: "Ok", style: .default, handler: onOkPressed)
  alertController.addAction(okAction)
  controller.present(alertController, animated: true, completion: nil)
}
