//
//  ViewController.swift
//  EmployeeList
//
//  Created by Rajat Bhatt on 01/07/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //MARK: Properties
    let plistAccessMethods = PlistAccessMetods()
    var dataForTableView: [String:String] = [:]
    var favouriteData: [String:String] = [:]
    var favourite :[String:Bool] = [:]
    var segmentFavouriteSelected = false
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        //Back button title
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        
        //Segment control UI
        var titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    //MARK: View will apper
    override func viewWillAppear(_ animated: Bool) {
        //Check if plist exists
        let plistExist = self.plistAccessMethods.checkPlistExist()
        print(plistExist)
        if plistExist{
            // Read data from plist
            self.plistAccessMethods.readDataFromPlist { (allEmployees:[String:String], favourite:[String:Bool]) in
                self.dataForTableView = allEmployees
                self.favourite = favourite
                //Reload tableView
                DispatchQueue.main.async {
                    self.employeeTableView.reloadData()
                }
            }
        }
    }
    
    //MARK: Segment Change Action
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("All")
            self.segmentFavouriteSelected = false
            self.employeeTableView.reloadData()
        case 1:
            print("Favourite")
            self.favouriteData.removeAll()
            // Create favourite data
            for (key, value) in dataForTableView {
                if favourite[key]! {
                    self.favouriteData[key] = value
                }
            }
            self.segmentFavouriteSelected = true
            self.employeeTableView.reloadData()
        default:
            print("default")
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCell" {
            let destination = segue.destination as! EmployeeFormViewController
            if segmentFavouriteSelected {
                destination.selectedName = Array(favouriteData.keys)[sender as! Int]
                destination.selectedPhone = Array(favouriteData.values)[sender as! Int]
            } else {
                destination.selectedName = Array(dataForTableView.keys)[sender as! Int]
                destination.selectedPhone = Array(dataForTableView.values)[sender as! Int]
            }
            destination.fromCell = true
        }
    }
}

//MARK: TableView Delegate and DataSource
extension EmployeeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if segmentFavouriteSelected {
            return favouriteData.count
        }
        return dataForTableView.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmployeeTableViewCell
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowRadius = 10
        cell.favouriteClicked = self as TableViewCellFavouriteButtonClicked
        // IF favourite segment is selected
        if segmentFavouriteSelected {
            cell.titleLbl.text = Array(favouriteData.keys)[indexPath.section]
            cell.subtitleLbl.text = Array(favouriteData.values)[indexPath.section]
            cell.favouriteButton.tag = indexPath.section
            cell.favouriteButton.setImage(#imageLiteral(resourceName: "filledStar"), for: .normal)
        // If all segment is selected
        } else {
            let name = Array(dataForTableView.keys)[indexPath.section]
            cell.titleLbl.text = Array(dataForTableView.keys)[indexPath.section]
            cell.subtitleLbl.text = Array(dataForTableView.values)[indexPath.section]
            cell.favouriteButton.tag = indexPath.section
            if favourite[name]! {
                cell.favouriteButton.setImage(#imageLiteral(resourceName: "filledStar"), for: .normal)
            } else {
                cell.favouriteButton.setImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        // Perform segue on cell selection
        self.performSegue(withIdentifier: "fromCell", sender: indexPath.section)
    }
}

// Callback on cell celection
extension EmployeeListViewController: TableViewCellFavouriteButtonClicked {
    func onclick(tag: Int, favourite: Bool) {
        let indexPath = IndexPath(row: 0, section: tag)
        let cell = self.employeeTableView.cellForRow(at: indexPath) as! EmployeeTableViewCell
        if segmentFavouriteSelected {
            // If favourite clicked remove it from favourite data
            if favourite {
                self.favouriteData.removeValue(forKey: cell.titleLbl.text!)
            }
        }
        // Write favourite on plist
        self.plistAccessMethods.writeDataOnFavouritePlist(oldFavourite: self.favourite, newfavourite: !favourite, forKey: cell.titleLbl.text!, completion: {
            self.plistAccessMethods.readDataFromPlist(completion: { (_:[String : String], favourite:[String : Bool]) in
                self.favourite = favourite
                DispatchQueue.main.async {
                   self.employeeTableView.reloadData()
                }
            })
        })
    }
}
