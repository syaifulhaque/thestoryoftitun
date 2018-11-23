//
//  ViewController.swift
//  StoviTheStoryVideo
//
//  Created by Egi Muhamad Saefulhaqi on 21/11/18.
//  Copyright © 2018 Egi Muhamad Saefulhaqi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var menuThumbnailTableView: UITableView!

    var story : Story?
    var stories: [Story] = []
    
   // typealias onFetchReccordSuccess = ([Story]) -> Void
    var ab :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        menuThumbnailTableView.delegate = self
        menuThumbnailTableView.dataSource = self
        CloudKitHelper().fetchStoryRecord{(stories) in
          //  print(stories)
            DispatchQueue.main.async {
                for story in stories {
                    self.stories.append(story)
                    self.ab += 1
                    self.menuThumbnailTableView.reloadData()
                    
                }
                print("stories \(stories)")
              //  self.menuThumbnailTableView.reloadData()

            }
            


        }
        print("stories1 \(stories)")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print(ab)
        return self.stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 224
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! FrontMenuTableViewCell
//        CloudKitHelper().fetchStoryRecord{(stories) in
//            //  print(stories)
//            DispatchQueue.main.async {
//          
                cell.titleLabel.text = stories[indexPath.row].title
                //cell.descriptionLabel.text = stories[indexPath.row].content
                cell.thumbnailVideo.image = UIImage(named: stories[indexPath.row].image)
//
//            }
//
//        }
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.performSegue(withIdentifier: "toDetail", sender: self)
        self.story = stories[indexPath.row]
        self.performSegue(withIdentifier: "toDetail", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let vc = segue.destination as! DetailViewController
            vc.story = self.story
        }
    }
    
    
    
}
