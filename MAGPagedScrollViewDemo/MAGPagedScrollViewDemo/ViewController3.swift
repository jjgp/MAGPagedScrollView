//
//  ViewController3.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 23/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

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

    
}


extension ViewController3: PagedReusableScrollViewDataSource {
    
    func scrollView(_ scrollView: PagedReusableScrollView, viewIndex index: Int) -> ViewProvider {
        var newView:SimpleCardViewController? = scrollView.dequeueReusableView(tag:  1 ) as? SimpleCardViewController
        if newView == nil {
            newView =  SimpleCardViewController()
        }
        newView?.imageName = "photo\(index%5).jpg"
        return newView!
    }
    
    func numberOfViews(forScrollView scrollView: PagedReusableScrollView) -> Int {
        return 10
    }
    
}
