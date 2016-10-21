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
  
  @IBOutlet weak var studentLocationsTableView: UITableView!
  @IBOutlet weak var reloadButton: UIBarButtonItem!
  @IBOutlet weak var newPinButton: UIBarButtonItem!
  @IBOutlet weak var logoutButton: UIBarButtonItem!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if StudentLocation.locations.count == 0 {
      reloadStudentLocations(reloadButton)
    } else {
      studentLocationsTableView.reloadData()
    }
  }
  
  @IBAction func logOutOfSession(_ sender: UIBarButtonItem) {
    
    prepareUiForNetworkRequest()
    
    UOTMClient.shared.deleteSession(completion: {
      result, error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        
        DispatchQueue.main.async {
          if let error = error as? URLError, error.errorCode == NSURLErrorNotConnectedToInternet {
            showBasicAlert(onController: self, withTitle: Constants.ErrorMessages.noInternetTitle, message: Constants.ErrorMessages.noInternetMessage, onOkPressed: nil)
          } else {
            showBasicAlert(onController: self, withTitle: Constants.ErrorMessages.sorryTitle, message: Constants.ErrorMessages.logOutMessage, onOkPressed: nil)
          }
        }

        return
      }
      
      DispatchQueue.main.async {
        self.appDelegate.window?.rootViewController = self.storyboard?.instantiateInitialViewController()
      }
    })
  }
  
  @IBAction func reloadStudentLocations(_ sender: UIBarButtonItem) {
    
    prepareUiForNetworkRequest()
    
    UOTMClient.shared.getStudentLocationsFromServer(completion: {
      error in
      
      self.updateUiAfterNetworkRequest()
      
      guard error == nil else {
        
        handleStudentLocationsRequestError(onViewController: self, error: error!)
        
        return
      }
      
      DispatchQueue.main.async {
        self.studentLocationsTableView.reloadData()
      }
    })
  }
  
  func prepareUiForNetworkRequest() {
    DispatchQueue.main.async {
      self.newPinButton.isEnabled = false
      self.logoutButton.isEnabled = false
      self.reloadButton.isEnabled = false
    }
  }
  
  func updateUiAfterNetworkRequest() {
    DispatchQueue.main.async {
      self.newPinButton.isEnabled = true
      self.logoutButton.isEnabled = true
      self.reloadButton.isEnabled = true
    }
  }
}

extension PinsOnTableViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return StudentLocation.locations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.pins, for: indexPath)
    cell.textLabel?.text = StudentLocation.locations[indexPath.row].fullName
    cell.detailTextLabel?.text = StudentLocation.locations[indexPath.row].mediaUrlString

    return cell
  }
}

extension PinsOnTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let url = StudentLocation.locations[indexPath.row].mediaUrl {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
  }
}
