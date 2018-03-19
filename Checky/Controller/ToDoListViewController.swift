//
//  ViewController.swift
//  Checky
//
//  Created by Ken Krippeler on 12.03.18.
//  Copyright © 2018 Lichtverbunden. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController
{
    var itemArray = ["Play Kingdom Hearts", "Go out eating", "Learn Programming", "Watch Stargate Atlantis"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.reloadData()
    }

    //MARK - TableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Checky Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default)
        {(action) in
            //What will happen after tapping button
            
            if let item = textField.text
            {
                self.itemArray.append(item)
                self.tableView.reloadData()
            }
        }
        
        action.isEnabled = false
        
        alert.addTextField
        {(alertTextField) in
            alertTextField.placeholder = "Create a new item"

            NotificationCenter.default.addObserver(forName: .UITextFieldTextDidChange, object: alertTextField, queue: OperationQueue.main, using:
                {_ in
                    let textCount = alertTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    action.isEnabled = textIsNotEmpty
                })
            
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
}

