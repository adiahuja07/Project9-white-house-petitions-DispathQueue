//
//  ViewController.swift
//  Project7
//
//  Created by Appinventiv on 13/12/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petetions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(credit))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTitle))
        
        performSelector(inBackground: #selector(getData), with: nil)
        
    }
    
    @objc func getData() {
        let urlString : String
         if navigationController?.tabBarItem.tag == 0 {
             urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
         } else {
             urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
         }
         
         if let url = URL(string: urlString) {
             if let data = try? Data(contentsOf: url) {
                 parse(json: data)
                 return
             }
         }

        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func searchTitle() {
        
        let ac = UIAlertController(title: "", message: "What intrest's you?", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak self, weak ac] _ in
            print()
            
            guard let title = ac?.textFields?[0].text else { return }
            self?.search(title)
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    func search(_ title: String) {
//
//        performSelector(inBackground: #selector(searchTitleInTable(title), with: nil)
        searchTitleInTable(title)
    }
    
    @objc func credit() {
        
        let ac = UIAlertController(title: "CREDITS", message: "This data is provided to us by whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true, completion: nil)
    }
    
    func searchTitleInTable(_ searchText: String) {
        DispatchQueue.main.async {
            if searchText != "" {
                self.filteredPetitions = self.petetions.filter{ $0.title.contains(searchText)}//petetions[title].contains(searchText)
            }
            else {
                self.filteredPetitions = self.petetions
            }
            self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showError() {
        
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed. Please try again later.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.navigationController?.present(ac, animated: true, completion: nil)
        }
    }
    
    func parse(json : Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petetions = jsonPetitions.results
            filteredPetitions = petetions
            self.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
        else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let petetion = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petetion.title
        cell.detailTextLabel?.text = petetion.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

