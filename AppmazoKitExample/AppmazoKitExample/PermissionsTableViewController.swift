//
//  PermissionsManagerTableViewController.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class PermissionsManagerTableViewController: UITableViewController, PermissionPromptTableViewCellDelegate {
    static let segueIdentifier = "PermissionsManagerTableViewControllerSegueIdentifier"
    
    private let UITableViewCellReuseIdentifier = "UITableViewCellReuseIdentifier"
    private let permissionsManager = PermissionsManager()
    
    enum Section: Int {
        case location
//        case pushNotifications
//        case biometricID
//        case camera
//        case microphone
//        case photoLibrary
        case count
    }
    
    enum LocationRow: Int {
        case always
        case whenInUse
        case count
    }
    
    // MARK: - UITableViewController
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Permissions Manager"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCellReuseIdentifier)
        tableView.register(PermissionPromptTableViewCell.self, forCellReuseIdentifier: PermissionPromptTableViewCell.reuseIdentifier)
        
        permissionsManager.permissionsUpdatedBlock = { [weak self] (permissionType) in
            switch permissionType {
            case .location:
                self?.tableView.reloadSections([Section.location.rawValue], with: .automatic)
            default:
                break
            }
        }
    }

    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.location.rawValue:
            return "Location"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.location.rawValue:
            return LocationRow.count.rawValue
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PermissionPromptTableViewCell.reuseIdentifier, for: indexPath) as? PermissionPromptTableViewCell {
            cell.delegate = self

            switch indexPath.section {
            case Section.location.rawValue:
                switch indexPath.row {
                case LocationRow.always.rawValue:
                    cell.permissionType = .locationAlways
                    cell.enabled = !permissionsManager.isLocationAuthorizedAlways()
                case LocationRow.whenInUse.rawValue:
                    cell.permissionType = .locationWhenInUse
                    cell.enabled = !permissionsManager.isLocationsAuthorized() // Should be enabled for both 'whenInUse' and 'always'
                default:
                    break
                }
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate
    
    // MARK: - PermissionPromptTableViewCellDelegate
    
    func permissionPromptTableViewCell(_ permissionPromptTableViewCell: PermissionPromptTableViewCell, buttonPressed: UIButton) {
        let indexPath = tableView.indexPath(for: permissionPromptTableViewCell)
        
        switch indexPath?.section {
        case Section.location.rawValue:
            switch indexPath?.row {
            case LocationRow.always.rawValue:
                permissionsManager.requestLocationPermission(.authorizedAlways)
            case LocationRow.whenInUse.rawValue:
                permissionsManager.requestLocationPermission(.authorizedWhenInUse)
            default:
                break
            }
        default:
            break
        }
    }
}
