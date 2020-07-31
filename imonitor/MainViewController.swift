//
//  MainViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/31.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let data = ["apples" , "oranges", "grapes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        
            
        let nameLabel = UILabel(frame: CGRect(x: 230, y: -30, width:150, height:150))
        let collegeNameLabel = UILabel(frame: CGRect(x: 230, y: 0, width:150, height:150))
        let deptNameLabel = UILabel(frame: CGRect(x: 230, y: 30, width:150, height:150))
        let image = UIImage(named: "person.jpg")
        
        var imgStudent: UIImageView!
        
            
        tableView.delegate = self
        tableView.dataSource = self
        
        header.backgroundColor =  UIColor(red: 93/255, green: 155/255, blue: 197/255, alpha: 1)
        
        
        imgStudent = UIImageView(frame: CGRect(x: 75, y: 35, width:75, height: 75))
        imgStudent.image = image
        imgStudent.layer.cornerRadius = 20.0
        imgStudent.layer.masksToBounds = true
        //imgStudent.layer.position =  CGPoint(x:self.view.bounds.width/10, y: self.view.bounds.height/10)
        
        header.addSubview(imgStudent)

        nameLabel.text = "허예은"
        nameLabel.textColor = UIColor.white
        //nameLabel.textAlignment = .center
        header.addSubview(nameLabel)
            
        collegeNameLabel.text = "IT대학"
        //deptNameLabel.textAlignment = .center
        collegeNameLabel.textColor = UIColor.white
        header.addSubview(collegeNameLabel)
            
        deptNameLabel.text = "소프트웨어학부"
        //deptNameLabel.textAlignment = .center
        deptNameLabel.textColor = UIColor.white
        header.addSubview(deptNameLabel)
        
        tableView.tableHeaderView = header
    }
    
    @IBAction func logoutButtonPressed(){
        dismiss(animated: true, completion: nil)
    }

}

extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
          tableView.deselectRow(at: indexPath, animated: true)
      }
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
           return 0
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}
