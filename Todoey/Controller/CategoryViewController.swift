//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Keval Korat on 5/14/21.
//  Copyright © 2021 Keval Korat. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework
import RandomColorSwift

class CategoryViewController: SwipeKitViewController {
    
    //create an empty category
    var categories: Results<Category>?
    
    //create a context to our database model
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: nil, action: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }

    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? ""
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "#fff")
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categories![indexPath.row].color) ?? .white, returnFlat: true)
        cell.tintColor = ContrastColorOf(UIColor(hexString: categories![indexPath.row].color) ?? .white, returnFlat: true)
        
        
        
        return cell
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categories?[indexPath.row]
        }
        
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let color = RandomFlatColorWithShade(.light).hexValue()
            let demoColor = randomColor(hue: .random, luminosity: .random)
            print(demoColor)
            let category = Category()
            category.name = textField.text!
            category.color = color
            
            self.save(category: category)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Name of category goes here"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error saving the context, \(error.localizedDescription)")
            
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        // Get all categories in the realm
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func deleteCells(at indexPath: IndexPath) {
        if let currentCategory = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(currentCategory)                    
                }
            } catch {
                print("error deleting the category, \(error.localizedDescription)")
                
            }
            
        }
    }
}





