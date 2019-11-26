//
//  ViewController.swift
//  Todoey
//
//  Created by Sourabh kehar on 2019-10-23.
//  Copyright © 2019 Sourabh kehar. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet{
            loadItems()
        }
    }
   
//     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       print (FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask).first?.appendingPathComponent("item.plist"))
        //print(dataFilePath)
    
        
       
        
    }
// table view data source method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            // ternary operator
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            
        }else {
            
            cell.textLabel?.text = " NO ITEMS ADDED"
        }
        
       
       
        
        return cell
    }

    // Mark - tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if let item = toDoItems?[indexPath.row]{
            do{
           try realm.write {
                item.done = !item.done
//            realm.delete(item)   - to delete item in a row.
            }
            }catch{
                print("error saving done status \(error)")
            }
        }
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
//        toDoItems?[indexPath.row].done = !toDoItems[indexPath.row].done
//
//
//        saveItems()
//
        tableView.reloadData()
            
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "to add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "ADD ITEM", style: .default) { (action) in
            // WHAT WILL HAPPEN WHEN USER ADD ITEM BUTTON IN OUR UI ALERT
            
            if let currentCategory = self.selectedCategory{
                do{
              try self.realm.write {
                    let newItem = Item()
            newItem.title = textField.text!
                newItem.dateCreated = Date()
                currentCategory.items.append(newItem)
                    }}catch{
                        print("ERROR SAVING NEW ITEMS,\(error)")
                }
            }
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//            self.saveItems()
            
            self.tableView.reloadData()
         //  let encoder = PropertyListEncoder()
          //  do{
          //  let data = try encoder.encode(self.itemArray)
           //     try data.write(to: self.dataFilePath!)}
           // catch{
           //     print("printing error in item, \(error)")
          //  }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "ADD NEW ITEM"
            
        textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - model completion method
//    func saveItems(){
//
//        do{
//            try context.save()}
//        catch{
//            print("printing error in item, \(error)")
//        }
//    }
    
    func loadItems(){
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }else{
//
//            request.predicate = categoryPredicate
//        }
////        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
////
////        request.predicate = compoundPredicate
////
//        do{
//        itemArray = try context.fetch(request)
//
//        }catch{
//            print("ERROR FETCHING CONTEXT, \(error)")
//        }
//    }



}
}

//MARK: - SEARCH BAR BUTTON

 extension ToDoListViewController : UISearchBarDelegate{

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        
        toDoItems = toDoItems?.filter("title contains [cd] %a", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//       let predicate = NSPredicate(format: "title contains [cd] %a", searchBar.text!)
//
//
//
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//       loadItems(with: request)

//        do{
//            itemArray = try context.fetch(request)
//
//        }catch{
//            print("ERROR FETCHING CONTEXT, \(error)")
//        }
    
        //tableView.reloadData()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


