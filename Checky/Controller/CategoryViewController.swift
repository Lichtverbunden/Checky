//
//  CategoryViewController.swift
//  Checky
//
//  Created by Ken Krippeler on 27.03.18.
//  Copyright © 2018 Lichtverbunden. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController
{
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadItems()
    }
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    
    //MARK - TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow
        {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //MARK - Add New Categories

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default)
        {(action) in
            //What will happen after tapping button
            
            if let category = textField.text
            {
                let newCategory = Category(context: self.context)
                newCategory.name = category
                
                self.categoryArray.append(newCategory)
                self.saveItems()
            }
        }
        
        action.isEnabled = false
        
        alert.addTextField
            {(alertTextField) in
                alertTextField.placeholder = "Create a new category"
                
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
    
    
    //MARK - Data Manipulation Methods
    
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
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest())
    {
        do
        {
            categoryArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
}
