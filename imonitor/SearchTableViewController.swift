//
//  SearchTableViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/11.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}

class SearchViewModel{
    var courseInfo: CourseInfo?
    
    func update(model: CourseInfo?){
        courseInfo = model
    }
}
