//
//  PinsOnTableViewController.swift
//  udacity-OnTheMap
//
//  Created by Akshar Patel on 18/10/16.
//  Copyright © 2016 Ekantik Tech Studio. All rights reserved.
//

import UIKit

class PinsOnTableViewController: UIViewController {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var studentLocations = [StudentLocation]()
  
  @IBOutlet weak var studentLocationsTableView: UITableView!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UOTMClient.shared.getStudentLocations(completion: {
      result, error in
      
      guard let result = result, error == nil else {
        //FIXME: Handle error here
        return
      }
      
      self.studentLocations = result
      
      DispatchQueue.main.async {
        self.studentLocationsTableView.reloadData()
      }
    })
  }
  
  @IBAction func logOutOfSession(_ sender: UIBarButtonItem) {
    UOTMClient.shared.deleteSession(completion: {
      result, error in
      
      guard error == nil else {
        return
      }
      
      DispatchQueue.main.async {
        self.appDelegate.window?.rootViewController = self.storyboard?.instantiateInitialViewController()
      }
    })
  }
}

extension PinsOnTableViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return studentLocations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.pins, for: indexPath)
    cell.textLabel?.text = studentLocations[indexPath.row].fullName
    cell.detailTextLabel?.text = studentLocations[indexPath.row].mediaUrl
    return cell
  }
}
