//
//  ViewController.swift
//  EmployeeList
//
//  Created by Rajat Bhatt on 01/07/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    let plistAccessMethods = PlistAccessMetods()
    var dataForTableView: [String:String] = [:]
    var favourite = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.customView?.backgroundColor = UIColor.orange
        
        var titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.automaticallyAdjustsScrollViewInsets = false
        let plistExist = self.plistAccessMethods.checkPlistExist()
        if plistExist{
            self.plistAccessMethods.readDataFromPlist { (allEmployees:[String:String]) in
                for _ in 1...allEmployees.count {
                    favourite.append(false)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let plistExist = self.plistAccessMethods.checkPlistExist()
        print(plistExist)
        if plistExist{
            self.plistAccessMethods.readDataFromPlist { (allEmployees:[String:String]) in
                self.dataForTableView = allEmployees
                DispatchQueue.main.async {
                    self.employeeTableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        cell.titleLbl.text = Array(dataForTableView.keys)[indexPath.section]
        cell.subtitleLbl.text = Array(dataForTableView.values)[indexPath.section]
        if favourite[indexPath.section] {
            cell.favouriteButton.setImage(#imageLiteral(resourceName: "filledStar"), for: .normal)
        } else {
            cell.favouriteButton.setImage(#imageLiteral(resourceName: "emptyStar"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        self.performSegue(withIdentifier: "fromCell", sender: indexPath.section)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromCell" {
            let destination = segue.destination as! EmployeeFormViewController
            destination.selectedName = Array(dataForTableView.keys)[sender as! Int]
            destination.selectedPhone = Array(dataForTableView.values)[sender as! Int]
            destination.fromCell = true
        }
    }
}

