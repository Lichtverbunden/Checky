//
//  ViewController.swift
//  Checky
//
//  Created by Ken Krippeler on 12.03.18.
//  Copyright © 2018 Lichtverbunden. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController
{
    var itemArray = [Item]()
    
    var selectedCategory: Category?
    {
        didSet
        {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    //MARK - TableViewDataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
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
                let newItem = Item(context: self.context)
                newItem.title = item
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                self.saveItems()
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
    
    func saveItems()
    {
        do
        {
            try context.save()
        }
        catch
        {
            print("Error saving context: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil)
    {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
       
        if let additionalPredicate = predicate
        {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }
        
        do
        {
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
        
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
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            loadItems(with: request, predicate: predicate)
        }
    }
}

