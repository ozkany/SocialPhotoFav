//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop
import SwiftyJSON

private let numberOfCards: Int = 5
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: UIViewController {

    @IBOutlet weak var kolodaView: CustomKolodaView!
    
    var imageList = [Image]()
    
    var imageURLs: [String] = ["https://i.pinimg.com/originals/8b/90/2f/8b902f3b8e4d39ebecc9784bca68cbb5.png",
                               "https://cf.girlsaskguys.com/a54462/19874751-cc6f-447a-99bf-03d3a170493d.jpg",
                               "https://cf.girlsaskguys.com/q2068889/099b7e3d-58f6-4595-ac31-55b0b9c0a910.jpg",
                               "https://magpiescloset.files.wordpress.com/2013/08/20130820-113154.jpg?w=690",
                               "https://cf.girlsaskguys.com/q2728025/d77d90a8-14c0-4f59-a6a9-8d8990465a40.jpg",
                               "https://i.pinimg.com/736x/59/c5/33/59c5333b6b10db02d593883161a9f7f8--hair-girls-girls-girls-girls.jpg",
                               "https://cf.girlsaskguys.com/q1782275/e5fe0b71-88e9-4b42-920e-4369ccc71c57.jpg",
                               "https://cf.girlsaskguys.com/q2768366/4af1aee7-5598-4893-903c-1394ae94f6fa.jpg",
                               "https://cf.kizlarsoruyor.com/q5606604/1aab8c5a-7bad-46cc-a831-c792bbb3a6cf.jpg",
                               "https://cf.kizlarsoruyor.com/q5501264/4bea3a74-f479-4594-8493-62e2fd266e43.jpg"
                               ]
    
    //MARK: Lifecycle
   
    override func viewDidLoad() {
        getImageList()
        super.viewDidLoad()
        
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    func getImageList() {
        guard let url = URL(string: "https://www.instagram.com/explore/tags/beautifulgirl/?__a=1") else { return }
        let imageHelper = ImageHelper()
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do
            {
                let json = try JSON(data: dataResponse)
                self.imageList = imageHelper.getImageList(fromJson: json)
                DispatchQueue.main.async() {
                    self.kolodaView.reloadData()
                }
                
            } catch let parsingError {
                print("Error while fetching data from network !!", parsingError)
            }
        }
        task.resume()
        
    }
    
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
//        return numberOfCards
        return imageList.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        //return UIImageView(image: UIImage(named: "cards_\(index + 1)"))
        let imageView: UIImageView = UIImageView()
        
        if imageList.count == 0 || imageList.count <= index { return imageView }
        
        //Ozkan:
        
        //imageView.downloaded(from: imageURLs[index])
        imageView.downloaded(from: imageList[index].url)

        return imageView
        
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
