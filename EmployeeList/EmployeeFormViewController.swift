//
//  EmployeeFormViewController.swift
//  EmployeeList
//
//  Created by Rajat Bhatt on 01/07/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import UIKit

class EmployeeFormViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var molbileTextFiled: UITextField!
    
    let plistAccessMethods = PlistAccessMetods()
    var selectedName = ""
    var selectedPhone = ""
    var fromCell = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Employee Form"
        if self.selectedName != "" && self.selectedPhone != "" {
            self.nameTextField.text = self.selectedName
            self.molbileTextFiled.text = self.selectedPhone
        }
    }

    @IBAction func addNewEmployee(_ sender: UIButton) {
        let plistExist = plistAccessMethods.checkPlistExist()
        if plistExist {
            if fromCell {
                if nameTextField.text != "" && molbileTextFiled.text != "" {
                    let e1 = Employee(name: nameTextField.text! , mobileNo: molbileTextFiled.text!)
                    //plistAccessMethods.writeDataOnPlist(newEmployee: e1)
                    plistAccessMethods.readDataFromPlist(completion: { (oldEmpoyees:[String : String]) in
                        var employees = oldEmpoyees
                        employees.removeValue(forKey: self.selectedName)
                        plistAccessMethods.writeDataOnPlist(oldEmplyee: employees, newEmployee: e1, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                }
            } else {
                if nameTextField.text != "" && molbileTextFiled.text != "" {
                    let e1 = Employee(name: nameTextField.text! , mobileNo: molbileTextFiled.text!)
                    //plistAccessMethods.writeDataOnPlist(newEmployee: e1)
                    plistAccessMethods.readDataFromPlist(completion: { (oldEmpoyees:[String : String]) in
                        plistAccessMethods.writeDataOnPlist(oldEmplyee: oldEmpoyees, newEmployee: e1, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                    })
                }
            }
        } else {
            if nameTextField.text != "" && molbileTextFiled.text != "" {
                let e1 = Employee(name: nameTextField.text! , mobileNo: molbileTextFiled.text!)
                plistAccessMethods.createPlist(newEmployee: e1, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
        }
    }
}
