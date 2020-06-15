//
//  ExamplesTableViewController.swift
//  OpenGLES-Samples
//
//  Created by BLU on 2020/06/10.
//  Copyright © 2020 BLU. All rights reserved.
//

import UIKit

class ExamplesTableViewController: UITableViewController {

    private let titles = ["DrawTriangle", "DrawSquare", "Cube"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = titles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: titles[indexPath.row], sender: nil)
    }

}
