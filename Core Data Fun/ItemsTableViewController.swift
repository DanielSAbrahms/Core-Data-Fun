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
    
    var category: Category? = nil
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
        cell.textLabel?.text = item

        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = itemArray.remove(at: sourceIndexPath.row)
        itemArray.insert(item, at: destinationIndexPath.row)
        tableView.reloadData()
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
            self.itemArray.append(text)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
