//
//  ItemsTableViewController.swift
//  Core Data Fun
//
//  Created by Gina Sprint on 10/24/18.
//  Copyright © 2018 Gina Sprint. All rights reserved.
//

import UIKit
import CoreData

class ItemsTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var category: Category? = nil {
        didSet {
            // MARK: lab #6
            loadItems()
        }
    }
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = category, let name = category.name {
            self.navigationItem.title = "\(name) Items"
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return itemArray.count
        }
        else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)

        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.name
        // MARK: lab #8.d.
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none

        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // MARK: lab #7
            context.delete(itemArray[indexPath.row])
            // Delete the row from the data source
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItems()
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = itemArray.remove(at: sourceIndexPath.row)
        itemArray.insert(item, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: lab #8.d.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = UIAlertController(title: "Create New Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name of Item"
            alertTextField = textField
        }
        
        let action = UIAlertAction(title: "Create", style: .default) { (alertAction) in
            let text = alertTextField.text!
            let newItem = Item(context: self.context)
            newItem.name = text
            newItem.parentCategory = self.category
            // MARK: lab #8.c.
            newItem.done = false
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving items \(error)")
        }
        self.tableView.reloadData()
    }
    
    // MARK: lab #6
    func loadItems(withPredicate predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        // MARK: lab #14
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
        request.sortDescriptors = [sortDescripter]
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        
        // MARK: lab #11.b
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error loading items \(error)")
        }
        tableView.reloadData()
    }
    
}

// MARK: lab #13 and 10.b.
extension ItemsTableViewController: UISearchBarDelegate {
    
    // MARK: lab #10.b.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        // MARK: lab #12
        if searchText.isEmpty {
            loadItems()
            searchBar.resignFirstResponder()
        }
        else {
            // perform search
            performSearch(searchBar: searchBar)
        }
    }
    
    // MARK: lab #11
    func performSearch(searchBar: UISearchBar) {
        if let text = searchBar.text {
            // MARK: lab #11.a.
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
            loadItems(withPredicate: predicate)
        }
    }
}
