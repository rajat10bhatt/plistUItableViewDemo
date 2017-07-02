//
//  PlistAccessMethods.swift
//  EmployeeList
//
//  Created by Rajat Bhatt on 02/07/17.
//  Copyright © 2017 Rajat Bhatt. All rights reserved.
//

import Foundation

class PlistAccessMetods {
    let fileManager = FileManager.default
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    
    
    func checkPlistExist() -> Bool {
        var fileExist = false
        let path = documentDirectory + "/employee.plist"
        if(!fileManager.fileExists(atPath: path)){
            fileExist = false
        }else{
            print("file exists")
            fileExist = true
        }
        return fileExist
    }
    
    func createPlist(newEmployee: Employee, completion: ()->()) {
        let path = documentDirectory + "/employee.plist"
        let name = newEmployee.name
        let phoneNo = newEmployee.mobileNo
        let data : [String: String] = [
            name : phoneNo
        ]
        
        let someData = NSDictionary(dictionary: data)
        let isWritten = someData.write(toFile: path, atomically: true)
        if isWritten {
            completion()
        }
        print("is the file created: \(isWritten)")
    }
    
    func readDataFromPlist(completion: ([String:String])->()) {
        let path = documentDirectory + "/employee.plist"
        
        let getEmployee = NSDictionary(contentsOfFile: path) as! [String : String]
        completion(getEmployee)
        
    }
    
    func writeDataOnPlist(oldEmplyee:[String:String], newEmployee: Employee, completion: ()->()) {
        let path = documentDirectory + "/employee.plist"
        let name = newEmployee.name
        let phoneNo = newEmployee.mobileNo
        var employees = oldEmplyee
        employees[name] = phoneNo
        
        let someData = NSDictionary(dictionary: employees)
        let isWritten = someData.write(toFile: path, atomically: true)
        print("is the file created: \(isWritten)")
        if isWritten {
            completion()
        }
    }
}
