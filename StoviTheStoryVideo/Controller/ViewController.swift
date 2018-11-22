//
//  ViewController.swift
//  StoviTheStoryVideo
//
//  Created by Egi Muhamad Saefulhaqi on 21/11/18.
//  Copyright © 2018 Egi Muhamad Saefulhaqi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var array = [ArrayOfData()]
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        array = [
        ArrayOfData(name: "Batman", image: #imageLiteral(resourceName: "batman banner")),
        ArrayOfData(name: "Batman", image: #imageLiteral(resourceName: "batman banner")),
        ArrayOfData(name: "Batman", image: #imageLiteral(resourceName: "batman banner")),
        ArrayOfData(name: "Batman", image: #imageLiteral(resourceName: "batman banner"))
        ]
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Menu") as! MenuTableVC
//        cell.imageList = array[indexPath.row].image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "detail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    
}
