//
//  ViewController.swift
//  EmployeeList
//
//  Created by Rajat Bhatt on 01/07/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController {
    
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let plistAccessMethods = PlistAccessMetods()
    var dataForTableView: [String:String] = [:]
    var favouriteData: [String:String] = [:]
    var favourite :[String:Bool] = [:]
    var segmentFavouriteSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        
        var titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let plistExist = self.plistAccessMethods.checkPlistExist()
        print(plistExist)
        if plistExist{
            self.plistAccessMethods.readDataFromPlist { (allEmployees:[String:String], favourite:[String:Bool]) in
                self.dataForTableView = allEmployees
                self.favourite = favourite
                DispatchQueue.main.async {
                    self.employeeTableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            print("All")
            self.segmentFavouriteSelected = false
            self.employeeTableView.reloadData()
        case 1:
            print("Favourite")
            self.favouriteData.removeAll()
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
        if segmentFavouriteSelected {
            cell.titleLbl.text = Array(favouriteData.keys)[indexPath.section]
            cell.subtitleLbl.text = Array(favouriteData.values)[indexPath.section]
            cell.favouriteButton.tag = indexPath.section
            cell.favouriteButton.setImage(#imageLiteral(resourceName: "filledStar"), for: .normal)
        } else {
            cell.titleLbl.text = Array(dataForTableView.keys)[indexPath.section]
            cell.subtitleLbl.text = Array(dataForTableView.values)[indexPath.section]
            cell.favouriteButton.tag = indexPath.section
            if Array(favourite.values)[indexPath.section] {
                cell.favouriteButton.setImage(#imageLiteral(resourceName: "filledStar"), for: .normal)
            } else {
                cell.favouriteButton.setImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        self.performSegue(withIdentifier: "fromCell", sender: indexPath.section)
    }
}

extension EmployeeListViewController: TableViewCellFavouriteButtonClicked {
    func onclick(tag: Int, favourite: Bool) {
        let indexPath = IndexPath(row: 0, section: tag)
        let cell = self.employeeTableView.cellForRow(at: indexPath) as! EmployeeTableViewCell
        if segmentFavouriteSelected {
            if favourite {
                self.favouriteData.removeValue(forKey: cell.titleLbl.text!)
            }
        }
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
