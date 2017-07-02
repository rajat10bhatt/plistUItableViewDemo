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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
        
        var titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        self.automaticallyAdjustsScrollViewInsets = false
        //      let person1 = Person(name: "Rajat", mobileNo: "8505802601", isFavourite: false)
        //let plistExist = self.plistAccessMethods.checkPlistExist()
        //print(plistExist)
        //if plistExist{
        // self.plistAccessMethods.readDataFromPlist { (allEmployees:[String:String]) in
        //  self.dataForTableView = allEmployees
        //  DispatchQueue.main.async {
        //     self.employeeTableView.reloadData()
        // }
        //}
        //}
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
        return 50
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.contentView.layer.shadowColor = UIColor.black.cgColor
        //        cell?.contentView.layer.shadowOpacity = 1
        //        cell?.contentView.layer.shadowOffset = CGSize.zero
        cell?.contentView.layer.shadowRadius = 10
        cell?.textLabel?.text = Array(dataForTableView.keys)[indexPath.section]
        cell?.detailTextLabel?.text = Array(dataForTableView.values)[indexPath.section]
        return cell!
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

