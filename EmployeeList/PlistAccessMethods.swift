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
    
    func checkFavouritePlistExist() -> Bool {
        var fileExist = false
        let path = documentDirectory + "/favourite.plist"
        if(!fileManager.fileExists(atPath: path)){
            fileExist = false
        }else{
            print("file exists")
            fileExist = true
        }
        return fileExist
    }
    
    
    
    func createPlist(newEmployee: Employee , completion: ()->()) {
        let path = documentDirectory + "/employee.plist"
        let name = newEmployee.name
        let phoneNo = newEmployee.mobileNo
        let data : [String: String] = [
            name : phoneNo
        ]
        
        let someData = NSDictionary(dictionary: data)
        let isWritten = someData.write(toFile: path, atomically: true)
        
        let pathofFavourite = documentDirectory + "/favourite.plist"
        let favourite = false
        let favouriteData : [String:Bool] = [
            name : favourite
        ]
        
        let someFavouriteData = NSDictionary(dictionary: favouriteData)
        let isFavouriteWritten = someFavouriteData.write(toFile: pathofFavourite, atomically: true)
        
        if isWritten && isFavouriteWritten {
            completion()
        }
        print("is the file created: \(isWritten)")
    }
    
    func readDataFromPlist(completion: ([String:String], [String:Bool])->()) {
        let path = documentDirectory + "/employee.plist"
        let pathofFavourite = documentDirectory + "/favourite.plist"
        let getEmployee = NSDictionary(contentsOfFile: path) as! [String : String]
        let getFavourite = NSDictionary(contentsOfFile: pathofFavourite) as! [String : Bool]
        completion(getEmployee, getFavourite)
        
    }
    
    func writeDataOnPlist(oldEmplyee:[String:String], newEmployee: Employee, oldFavourite:[String: Bool], completion: ()->()) {
        let path = documentDirectory + "/employee.plist"
        var employees = oldEmplyee
        employees[newEmployee.name] = newEmployee.mobileNo
        
        let someData = NSDictionary(dictionary: employees)
        let isWritten = someData.write(toFile: path, atomically: true)
        print("is the file created: \(isWritten)")
        
        let pathofFavourite = documentDirectory + "/favourite.plist"
        var favourite = oldFavourite
        favourite[newEmployee.name] = false
        
        let someFavouriteData = NSDictionary(dictionary: favourite)
        let isFavouriteWritten = someFavouriteData.write(toFile: pathofFavourite, atomically: true)
        if isWritten && isFavouriteWritten {
            completion()
        }
    }
    
    func writeDataOnFavouritePlist(oldFavourite:[String: Bool], newfavourite: Bool, forKey: String, completion: ()->()) {
        let pathofFavourite = documentDirectory + "/favourite.plist"
        var favourite = oldFavourite
        favourite[forKey] = newfavourite
        
        let someFavouriteData = NSDictionary(dictionary: favourite)
        let isFavouriteWritten = someFavouriteData.write(toFile: pathofFavourite, atomically: true)
        if isFavouriteWritten {
            completion()
        }
    }
}
