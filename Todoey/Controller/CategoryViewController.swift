//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sourabh kehar on 2019-11-12.
//  Copyright © 2019 Sourabh kehar. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
       
    }
    // MARK:- TABLEVIEW DATASOURCE METHOD
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
     // MARK:- TABLEVIEW DELEGATE METHOD
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

  

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "ADD NEW CATEGORY", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categories.append(newCategory)
            
            self.saveCategories()
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "ADD NEW CATEGORY"
        }
        
    present(alert, animated: true, completion: nil)
    }
    
    
    
   
    
    // MARK:- DATA MANIPULATION METHODS
    
    func saveCategories(){
        do{
        try context.save()
        }catch{
            print("ERROR SAVING CATEGORIES \(error)")
        }
        
    tableView.reloadData()
    }
    
    func loadCategories(){
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
       categories =  try context.fetch(request)
        }catch{
            print("ERROR LOADING CATEGORIES \(error)")
        }
        
        tableView.reloadData()
    }
}
