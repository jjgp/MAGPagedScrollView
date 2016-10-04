//
//  ViewController.swift
//  MAGPagedScrollViewDemo
//
//  Created by Ievgen Rudenko on 21/08/15.
//  Copyright (c) 2015 MadAppGang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: PagedScrollView!
    
    var colors = [
        UIColor.red,
        UIColor.blue,
        UIColor.green,
        UIColor.magenta
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //alternate way to add subviews
//        createView(0)
//        createView(1)
//        createView(2)
//        createView(3)

        scrollView.addSubviews([
            createView(0),
            createView(1),
            createView(2),
            createView(3)
        ])
    }
    
    @IBAction func goToLast(_ sender: AnyObject) {
        self.scrollView.goToPage(3, animated: true)
    }
    
    func createView(_ color: Int) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = colors[color]
        view.layer.cornerRadius = 10.0
        return view
    }
    
    func createAndAddView(_ color: Int) {
        let width = scrollView.frame.width
        let height = scrollView.frame.height
        
        let x = CGFloat(scrollView.subviews.count) * width

        let view = UIView(frame: CGRect(x: x, y: 0, width: width, height: height))
        view.backgroundColor = colors[color]
        
        view.layer.cornerRadius = 10.0
        scrollView.addSubview(view)
        scrollView.contentSize = CGSize(width: x+width, height: height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func segmentedViewChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: scrollView.transition = .slide
        case 2: scrollView.transition = .dive
        case 3: scrollView.transition = .roll
        case 4: scrollView.transition = .cards
        default: scrollView.transition = .none
        }
    }
}

