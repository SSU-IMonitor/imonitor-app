//
//  SearchViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/14.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 시작
        print("--> 검색어: \(searchBar.text)")
    }
}
