//
//  ViewController.swift
//  Todoey
//
//  Created by Sourabh kehar on 2019-10-23.
//  Copyright © 2019 Sourabh kehar. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController{
    
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let newItem = Item()
        newItem.title = "SOURABH"
       
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "kehar"
        
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "bhanu"
        
        itemArray.append(newItem3)
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
       }
    }
// table view data source method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // ternary operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        
       
        
        return cell
    }

    // Mark - tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
      
        
        tableView.reloadData()
            
            
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "to add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ADD ITEM", style: .default) { (action) in
            // WHAT WILL HAPPEN WHEN USER ADD ITEM BUTTON IN OUR UI ALERT
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.tableView.reloadData()
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "ADD NEW ITEM"
            
        textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}


