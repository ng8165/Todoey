//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Nelson Gou on 7/6/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    var categories: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            if category.color.isEmpty {
                do {
                    try realm.write {
                        category.color = UIColor.randomFlat().hexValue()
                    }
                } catch {
                    print(error)
                }
            }
            
            cell.backgroundColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Realm Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        var textField = UITextField()
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            self.save(category: Category(name: textField.text ?? ""))
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - SwipeTableViewController Methods
    
    override func updateModel(at indexPath: IndexPath) {
        if let deleteCategory = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(deleteCategory)
                }
            } catch {
                print(error)
            }
        }
    }
}
