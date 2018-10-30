//
//  ViewController.swift
//  Core Data Fun
//
//  Created by Gina Sprint on 10/24/18.
//  Copyright © 2018 Gina Sprint. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Core Data
// we've made a DataModel that abstracts a SQLite database for us
// there is some Core Data jargon to learn
// Core Data Entity <--> Swift Type <--> database table
// Core Data Attribute <--> Swift Property <--> database field
// therefore a row in a table is like an object of a type

// all of the underlying data store queries and methods are managed through an interface of type NSPersistentContainer
// NSPersistentContainer has a NSManagedObjectContext which is like an intelligent scratchpad
// think of the context like the staging area of a git repo
// saving the context is like comitting in git, its when our changes are actually written to disk

class CategoryViewController: UITableViewController {
    
    // recall: a persistent container abstracts a data store for us
    // by default the data store for core data is a SQLite database
    // we work with a persistent container's context instead of with the persistent container directly
    // we will use the context for common DB style operations
    // CRUD: Create, Read, Update, Delete
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categoryArray.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            categoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let category = categoryArray.remove(at: sourceIndexPath.row)
        categoryArray.insert(category, at: destinationIndexPath.row)
        tableView.reloadData()
    }

    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name of Category"
            alertTextField = textField
        }
        
        let action = UIAlertAction(title: "Create", style: .default) { (alertAction) in
            let text = alertTextField.text!
            // need to CREATE a Category object using context
            let newCategory = Category(context: self.context)
            newCategory.name = text
            self.categoryArray.append(newCategory)
            self.saveCategories()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategories() {
        // this method will write the changes we have made to our context to disk (SQLite DB)
        // try to save the context
        do {
            try context.save() // like a git commit
        }
        catch {
            print("Error saving categories")
        }
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "ShowItemsSegue"  {
            
            guard let itemsTableVC = segue.destination as? ItemsTableViewController else {
                return
            }
        
            guard let selectedIndexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let category = categoryArray[selectedIndexPath.row]
            itemsTableVC.category = category
        }
    }
}

