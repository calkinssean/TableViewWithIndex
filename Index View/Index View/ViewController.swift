//
//  ViewController.swift
//  Index View
//
//  Created by Sean Calkins on 3/29/16.
//  Copyright © 2016 Sean Calkins. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var arrayOfFood = ["Apple", "Banana", "Cheeseburger", "Dragonfruit", "Enchilada", "Fries", "Guacamole", "Hamburger", "Icecream", "Jalapeno", "Kiwi", "Lemon", "Mango", "Nachos", "Okrah", "Potato", "Quiche", "Rice", "Sandwiches", "Tomato", "Ugli", "Venison", "Waffle", "Xacuti", "Yucca", "Zuchinni"]
    
    var foodDictionary = [String: [String]]()
    var foodSectionTitles = [String]()
    
    let foodIndexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createFoodDict()
    }
    
    //MARK: - Add Tapped
    @IBAction func addTapped(sender: UIBarButtonItem) {
        
        self.presentAlert()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let foodKey = foodSectionTitles[section]
        
        if let foodValues = foodDictionary[foodKey] {
            return foodValues.count
        }
        
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return foodSectionTitles.count
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        
        return foodIndexTitles
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
        return foodSectionTitles[section]
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 44
        
    }
    
    //MARK: - Cell For Row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let foodKey = foodSectionTitles[indexPath.section]
        
        if let foodValues = foodDictionary[foodKey] {
            
            cell.textLabel?.text = foodValues[indexPath.row]
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        guard let index = foodSectionTitles.indexOf(title) else {
            return -1
        }
        
        return index
    }
    
    //MARK: - Created a dictionary from array of food
    func createFoodDict() {
        self.foodDictionary.removeAll()
        for foodItem in arrayOfFood {
            
            let foodKey = foodItem.substringToIndex(foodItem.startIndex.advancedBy(1))
            
            if var foodValues = foodDictionary[foodKey] {
                
                foodValues.append(foodItem)
                foodDictionary[foodKey] = foodValues
            } else {
                
                foodDictionary[foodKey] = [foodItem]
            }
        }
        
        // Get the section titles from the dictionary's keys and sort them in ascending order
        foodSectionTitles = [String](foodDictionary.keys)
        foodSectionTitles = foodSectionTitles.sort { $0 < $1 }
    }

    //MARK: - Cell Rotate Function
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let rotationAngleInRadians = 90.0 * CGFloat(M_PI/180.0)
        let rotationTransform = CATransform3DMakeRotation(rotationAngleInRadians, 0, 0, 1)
        cell.layer.transform = rotationTransform
        

        UIView.animateWithDuration(1.0, animations: { cell.layer.transform = CATransform3DIdentity })
   
    }
    
    //MARK: - Editing/Deleting Cells
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            arrayOfFood.removeAtIndex([indexPath.row].hash)
            print([indexPath.row].count)
            self.createFoodDict()
            self.tableView.reloadData()
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        }
    }
    
    
    //MARK: - Alert Controller
    func presentAlert() {
        let alertController = UIAlertController(title: "New Food", message: nil, preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default) { (action: UIAlertAction) -> Void in
                                        
                                        let foodNameField = alertController.textFields![0]
                                        
                                        if let foodName = foodNameField.text {
                                        self.arrayOfFood.append(foodName)
                                        
                                            self.createFoodDict()
                                            self.tableView.reloadData()
                                        }
                                        
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
                                        
        }
        
        alertController.addTextFieldWithConfigurationHandler {
            (foodNameField) -> Void in
            foodNameField.placeholder = "Enter a new food"
            
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController,
                              animated: true,
                              completion: nil)

        
    }
    
}

