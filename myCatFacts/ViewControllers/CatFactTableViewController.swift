//
//  CatFactTableViewController.swift
//  myCatFacts
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import UIKit

class CatFactTableViewController: UITableViewController {
    
    // MARK:- Properties
    private var currentPage = 0
    var catFacts: [CatFact] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK:- ACTIONS
    @IBAction func addCatFactButtonTapped(_ sender: UIBarButtonItem) {
        presentPostAlert()
    }
    
    // MARK:- CUSTOM METHODS
    func fetchFacts() {
        currentPage += 1
        CatFactController.fetchCatFacts(page: currentPage) { (result) in
            DispatchQueue.main.async {
                switch result {
                    case .success(let returnedResult):
                        self.catFacts = returnedResult
                    case .failure(let error):
                        self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    func presentPostAlert() {
        let alertController = UIAlertController(
            title: "Cat Facts",
            message: "Add a new Cat Fact",
            preferredStyle: .alert
        )
        
        alertController.addTextField { (textField: UITextField) -> Void in
            textField.placeholder = "Enter a cat fact"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned alertController] _ in
            
            guard
                let catFactDetailTextField = alertController.textFields?[0],
                let catFactDetail = catFactDetailTextField.text,
                !catFactDetail.isEmpty else { return }
            
            CatFactController.postCatFact(details: catFactDetail) { (result) in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let returnedResponse):
                            self.catFacts.append(returnedResponse)
                        case .failure(let error):
                            self.presentErrorToUser(localizedError: error)
                    }
                }
            }
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catFacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == catFacts.count - 1 {
            fetchFacts()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "catCell", for: indexPath)
        let catFact = catFacts[indexPath.row]
        let catFactID = catFact.id ?? 0
        let catFactDetail = catFact.details
        
        cell.textLabel?.text = catFactDetail
        cell.detailTextLabel?.text = String(catFactID)
        return cell
    }
}
