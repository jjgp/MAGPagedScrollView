//
//  ViewController2.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 22/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var scrollView: PagedReusableScrollView!

    var colors = [
        UIColor.red,
        UIColor.blue,
        UIColor.green,
        UIColor.magenta,
        UIColor.lightGray
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.dataSource = self
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func styleChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: scrollView.transition = .slide
        case 2: scrollView.transition = .dive
        case 3: scrollView.transition = .roll
        case 4: scrollView.transition = .cards
        default: scrollView.transition = .none
        }
    }

    @IBAction func goToEnd(_ sender: AnyObject) {
        self.scrollView.goToPage(9, animated: true)
    }
}


extension ViewController2: PagedReusableScrollViewDataSource {
    
    func scrollView(_ scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider {
        var newView = scrollView.dequeueReusableView(tag: index > 4 ? 1 : 2 )
        if newView == nil {
            if index > 4 {
                newView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            } else {
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
                imageView.contentMode = .scaleAspectFill
                newView = imageView
            }
            newView?.view.tag = index > 4 ? 1 : 2
        }

        if index > 4 {
            newView?.view.backgroundColor = colors[ index-5 ]
        } else {
            let imageView = newView as! UIImageView
            imageView.image = UIImage(named:"photo\(index).jpg")
        }
        newView?.view.clipsToBounds = true
        return newView!
    }
    
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int {
        return 10
    }
    
}
