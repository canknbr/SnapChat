//
//  SnapVC.swift
//  SnapChat
//
//  Created by Can Kanbur on 6.04.2023.
//

import UIKit
import ImageSlideshow
import Kingfisher

class SnapVC: UIViewController {
    
    var selectedSnap : Snap?
    var selectedTime : Int?
 var inputArray = [KingfisherSource]()
    @IBOutlet weak var timeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "Time left: \(selectedTime!)"
        // Do any additional setup after loading the view.
        
        
        if let snap = selectedSnap {
            for imageUrl in  snap.imageArray {
                inputArray.append(KingfisherSource(urlString: imageUrl)!)
                
            }
            
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95, height: self.view.frame.height * 0.9))
            let pageIndicator = UIPageControl()
            pageIndicator.currentPageIndicatorTintColor = UIColor.black
            pageIndicator.pageIndicatorTintColor = UIColor.lightGray
            
            imageSlideShow.backgroundColor = UIColor.white
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            imageSlideShow.pageIndicator = pageIndicator
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(timeLabel)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
