//
//  PostInfoNavigationController.swift
//  udacity-OnTheMap
//
//  Created by Techniexe on 20/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit

class PostInfoNavigationController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationBar.shadowImage = UIImage()
  }
}
