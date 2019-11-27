//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sourabh kehar on 2019-11-12.
//  Copyright © 2019 Sourabh kehar. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.separatorStyle = .none
        
        
       
    }
    // MARK:- TABLEVIEW DATASOURCE METHOD
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            
            cell.textLabel?.text = Category.className()
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf( categoryColour, returnFlat: true)
        }
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO AUTHENTICATION"
////         cell.delegate = self
//        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
//
        return cell
    }
    
     // MARK:- TABLEVIEW DELEGATE METHOD
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

  

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "ADD NEW CATEGORY", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ADD", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
           
            
            self.save(category: newCategory)
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "ADD NEW CATEGORY"
        }
        
    present(alert, animated: true, completion: nil)
    }
    
    
    
   
    
    // MARK:- DATA MANIPULATION METHODS
    
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("ERROR SAVING CATEGORIES \(error)")
        }
        
    tableView.reloadData()
    }
    
    func loadCategories(){
        
         categories = realm.objects(Category.self)
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do{
//       categories =  try context.fetch(request)
//        }catch{
//            print("ERROR LOADING CATEGORIES \(error)")
//        }
        
        tableView.reloadData()
    }
    // delete data from Swipe
    
    override func updateModel(at indexpath: IndexPath) {
        
        
        if let categoryForDeletion = self.categories?[indexpath.row]{
                            do{
                                try self.realm.write {
                                    self.realm.delete(categoryForDeletion)
                                }}catch{
                                    print("error deleting category,\(error)")
                            }
                            //                tableView.reloadData()
                        }
    }
}


