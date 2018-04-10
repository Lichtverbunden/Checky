//
//  ViewController.swift
//  Checky
//
//  Created by Ken Krippeler on 12.03.18.
//  Copyright © 2018 Lichtverbunden. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController
{
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?
    {
        didSet
        {
           loadItems()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    //MARK - TableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]
        {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else
        {
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let item = todoItems?[indexPath.row]
        {
            do
            {
                try realm.write
                {
                    item.done = !item.done
                }
            }
            catch
            {
                print("Error saving done status: \(error.localizedDescription)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
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
                if let currentCategory = self.selectedCategory
                {
                    do
                    {
                        try self.realm.write
                        {
                            let newItem = Item()
                            newItem.title = item
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    }
                    catch
                    {
                        print("Error saving new items: \(error.localizedDescription)")
                    }
                }
                
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
    
    //MARK - Model Manipulation Methods
    
    func loadItems()
    {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

//MARK - Search bar methods

extension ToDoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        fetchText(in: searchBar)
        DispatchQueue.main.async
        {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        fetchText(in: searchBar)
    }

    func fetchText(in searchBar: UISearchBar)
    {
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async
            {
                searchBar.resignFirstResponder()
            }
        }
        else if (searchBar.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            loadItems()
        }
        else
        {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        }
        
        tableView.reloadData()
    }
}


