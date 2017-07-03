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
        self.molbileTextFiled.delegate = self
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
                    let mobileNo: NSString = molbileTextFiled.text! as NSString
                    if mobileNo.length < 10 {
                        self.showAlert("Error", msg: "Enter Valid Mobile No.")
                    } else {
                        let e1 = Employee(name: nameTextField.text! , mobileNo: molbileTextFiled.text!)
                        //plistAccessMethods.writeDataOnPlist(newEmployee: e1)
                        plistAccessMethods.readDataFromPlist(completion: { (oldEmpoyees:[String : String], favourite:[String: Bool]) in
                            var employees = oldEmpoyees
                            employees.removeValue(forKey: self.selectedName)
                            plistAccessMethods.writeDataOnPlist(oldEmplyee: employees, newEmployee: e1, oldFavourite: favourite, completion: {
                                var favouritenew = favourite
                                if favourite[self.selectedName]! {
                                    favouritenew.removeValue(forKey: self.selectedName)
                                    plistAccessMethods.writeDataOnFavouritePlist(oldFavourite: favouritenew, newfavourite: true, forKey: e1.name, completion: {
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                } else {
                                    self.navigationController?.popViewController(animated: true)
                                }
                            })
                        })
                    }
                } else {
                    self.showAlert("Error", msg: "Name or Mobile No. Cannot Be Empty")
                }
            } else {
                if nameTextField.text != "" && molbileTextFiled.text != "" {
                    let mobileNo: NSString = molbileTextFiled.text! as NSString
                    if mobileNo.length < 10{
                        self.showAlert("Error", msg: "Enter Valid Mobile No.")
                    } else {
                        let e1 = Employee(name: nameTextField.text! , mobileNo: molbileTextFiled.text!)
                        //plistAccessMethods.writeDataOnPlist(newEmployee: e1)
                        plistAccessMethods.readDataFromPlist(completion: { (oldEmpoyees:[String : String], favourite: [String:Bool]) in
                            plistAccessMethods.writeDataOnPlist(oldEmplyee: oldEmpoyees, newEmployee: e1, oldFavourite: favourite, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        })
                    }
                } else {
                    self.showAlert("Error", msg: "Name or Mobile No. Cannot Be Empty")
                }
            }
        } else {
            if nameTextField.text != "" && molbileTextFiled.text != "" {
                let mobileNo: NSString = molbileTextFiled.text! as NSString
                if mobileNo.length < 10{
                   self.showAlert("Error", msg: "Enter Valid Mobile No.") 
                } else {
                    let e1 = Employee(name: nameTextField.text! , mobileNo: molbileTextFiled.text!)
                    plistAccessMethods.createPlist(newEmployee: e1, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            } else {
                self.showAlert("Error", msg: "Name or Mobile No. Cannot Be Empty")
            }
        }
    }
    
    func showAlert(_ title: String, msg: String) {
        //Dialog with a button
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert);
        //no event handler (just close dialog box)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil));
        self.present(alert, animated: true, completion: nil)
    }
}

extension EmployeeFormViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = self.molbileTextFiled.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
