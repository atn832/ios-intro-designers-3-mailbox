//
//  ViewController.swift
//  Mailbox
//
//  Created by Anh Tuan on 9/16/14.
//  Copyright (c) 2014 Anh Tuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mail: UIImageView!
    var originalMailX: CGFloat!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var mailBackground: UIView!
    
    @IBOutlet weak var laterView: UIImageView!
    
    @IBOutlet weak var todoView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        laterView.alpha = CGFloat(0)
        todoView.alpha = CGFloat(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onMessagePan(panGestureRecognizer: UIPanGestureRecognizer) {
        let break1 = CGFloat(-60.0)
        let break2 = CGFloat(-160.0)
        let maxX = view.frame.width
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            println("Gesture began at: \(point)")
            originalMailX = mail.frame.origin.x
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            println("Gesture changed at: \(point)")
            mail.frame.origin.x = originalMailX + translation.x
            
            let u = -Float(translation.x) / 60
            laterIcon.alpha = CGFloat(u)
            // frictional drag
//            if (mail.frame.maxX < maxX) {
//                mail.frame.origin.x = maxX - mail.frame.width + (mail.frame.maxX - maxX) / CGFloat(10.0)
//            }
            if (translation.x < break2) {
                // brown background, list options
                self.mailBackground.backgroundColor = UIColor(red: CGFloat(215/255.0), green: CGFloat(166/255.0), blue: CGFloat(120/255.0), alpha: CGFloat(1.0))
            } else if (translation.x < break1) {
                // yellow
                self.mailBackground.backgroundColor = UIColor(red: CGFloat(249/255.0), green: CGFloat(209/255.0), blue: CGFloat(69/255.0), alpha: CGFloat(1.0))
            }
        
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("Gesture ended at: \(point)")
            // decide to go up and down
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                println(translation.x)
                if (translation.x < break2) {
                    self.mail.frame.origin.x = -maxX
                    // brown background, list options
                    self.todoView.alpha = CGFloat(1.0)
                } else if (translation.x < break1) {
                    self.mail.frame.origin.x = -maxX
                    // later options
                    self.laterView.alpha = CGFloat(1.0)
                } else {
                    // expand
                    self.mail.frame.origin.x = 0
                }
                }, completion: { (flag: Bool) -> Void in
            })
        }
    }
}

