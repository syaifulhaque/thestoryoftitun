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
    var thumbnailImage : [UIImage] = [#imageLiteral(resourceName: "Choco Vanilla"),#imageLiteral(resourceName: "Cappucino"),#imageLiteral(resourceName: "ChocoFIllingnya EGI")]
    var thumbnail : [UIImageView] = []
    var story : Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuThumbnailTableView.delegate = self
        menuThumbnailTableView.dataSource = self
        CloudKitHelper().fetchStoryRecord{(stories) in
            print(stories)}
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        storiesMap = StoriesMap()
//        guard let storiesMap = storiesMap else {return}
//        for story in storiesMap.dummyStories {
//            let beautifulMorningAnnotation = StoriesAnnotation(coordinate: story.coordinate)
//            beautifulMorningAnnotation.titleVideo = story.title
//            beautifulMorningAnnotation.thumbnailVideo = story.thumbnail
//
//            storiesMapView.addAnnotation(beautifulMorningAnnotation)
//        }
//    }

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thumbnailImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! FrontMenuTableViewCell
        
        cell.thumbnailVideo.image = thumbnailImage[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //
    }
    
    
}
