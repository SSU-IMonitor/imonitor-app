//
//  MainViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/31.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutButtonPressed(){
        dismiss(animated: true, completion: nil)
    }

}
