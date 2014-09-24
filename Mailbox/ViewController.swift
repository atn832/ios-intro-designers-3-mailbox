//
//  ViewController.swift
//  Mailbox
//
//  Created by Anh Tuan on 9/16/14.
//  Copyright (c) 2014 Anh Tuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var originalMailX: CGFloat!
    @IBOutlet weak var mail: UIImageView!
    
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    
    @IBOutlet weak var mailBackground: UIView!
    
    @IBOutlet weak var laterView: UIImageView!
    @IBOutlet weak var mailsView: UIImageView!
    @IBOutlet weak var todoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        laterView.alpha = CGFloat(0)
        todoView.alpha = CGFloat(0)
        listIcon.hidden = true
        laterIcon.hidden = true
        archiveIcon.hidden = true
        deleteIcon.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onActionViewTap(sender: UITapGestureRecognizer) {
        let originY = self.mailsView.frame.origin.y
        println("tap tap")
        //fade out
        //collapse mail
        //show mail again
        //expand mail
        UIView.animateWithDuration(0.7, animations: { () -> Void in
                //fade out
                self.laterView.alpha = CGFloat(0)
                self.todoView.alpha = CGFloat(0)
            }, completion: { (flag: Bool) -> Void in
                UIView.animateWithDuration(0.7, animations: { () -> Void in
                    self.mailsView.frame.origin.y = self.mailsView.frame.origin.y - self.mail.frame.height
                    }, completion: { (flag: Bool) -> Void in
                        self.mail.frame.origin.x = CGFloat(0)
                        UIView.animateWithDuration(0.7, animations: { () -> Void in
                            self.mailsView.frame.origin.y = originY
                            }, completion: { (flag: Bool) -> Void in
                                println("done")
                        })
                })

        })
    }
    
    @IBAction func onMessagePan(panGestureRecognizer: UIPanGestureRecognizer) {
        let break1 = CGFloat(-60.0)
        let break2 = CGFloat(-160.0)
        
        let break1r = CGFloat(60)
        let break2r = CGFloat(160)
        
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
            
            if (translation.x < 0) {
                // translate left
                archiveIcon.hidden = true
                deleteIcon.hidden = true
                
                let u = -Float(translation.x) / 60
                laterIcon.alpha = CGFloat(u)
                
                laterIcon.frame.origin.x = min(320 - 48.0, mail.frame.maxX + 32)
                listIcon.frame.origin.x = laterIcon.frame.origin.x
                
                if (translation.x < break2) {
                    // brown background, list options
                    self.mailBackground.backgroundColor = UIColor(red: CGFloat(215/255.0), green: CGFloat(166/255.0), blue: CGFloat(120/255.0), alpha: CGFloat(1.0))
                    listIcon.hidden = false
                    laterIcon.hidden = true
                } else if (translation.x < break1) {
                    // yellow
                    self.mailBackground.backgroundColor = UIColor(red: CGFloat(249/255.0), green: CGFloat(209/255.0), blue: CGFloat(69/255.0), alpha: CGFloat(1.0))
                    listIcon.hidden = true
                    laterIcon.hidden = false
                }
            } else {
                // translate right
                listIcon.hidden = true
                laterIcon.hidden = true
                
                archiveIcon.hidden = false
                deleteIcon.hidden = true
                
                let u = Float(translation.x) / 60
                archiveIcon.alpha = CGFloat(u)
                
                archiveIcon.frame.origin.x = max(16.0, mail.frame.origin.x - 48)
                deleteIcon.frame.origin.x = archiveIcon.frame.origin.x
                
                if (translation.x < break1r) {
                    // gray
                    self.mailBackground.backgroundColor = UIColor(red: CGFloat(226/255.0), green: CGFloat(226/255.0), blue: CGFloat(226/255.0), alpha: CGFloat(1.0))
                } else if (translation.x < break2r) {
                    // green
                    self.mailBackground.backgroundColor = UIColor(red: CGFloat(115/255.0), green: CGFloat(212/255.0), blue: CGFloat(103/255.0), alpha: CGFloat(1.0))
                } else {
                    // red
                    self.mailBackground.backgroundColor = UIColor(red: CGFloat(222/255.0), green: CGFloat(81/255.0), blue: CGFloat(56/255.0), alpha: CGFloat(1.0))
                    archiveIcon.hidden = true
                    deleteIcon.hidden = false
                }
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            println("Gesture ended at: \(point)")
            
            var hideMessageOnComplete = false
            
            // decide to go up and down
            UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                self.listIcon.hidden = true
                self.laterIcon.hidden = true
                self.archiveIcon.hidden = true
                self.deleteIcon.hidden = true
                
                if (translation.x < 0) {
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
                } else {
                    if (translation.x > break2r) {
                        self.mail.frame.origin.x = maxX
                        // brown background, list options
//                        self.todoView.alpha = CGFloat(1.0)
                        hideMessageOnComplete = true
                    } else if (translation.x > break1r) {
                        self.mail.frame.origin.x = maxX
                        hideMessageOnComplete = true
                        // later options
//                        self.laterView.alpha = CGFloat(1.0)
                    } else {
                        // expand
                        self.mail.frame.origin.x = 0
                    }
                }
                }, completion: { (flag: Bool) -> Void in
                    if hideMessageOnComplete {
                        UIView.animateWithDuration(0.7, animations: { () -> Void in
                            self.mailsView.frame.origin.y = self.mailsView.frame.origin.y - self.mail.frame.height
                            }, completion: { (flag: Bool) -> Void in
                                    println("done")
                        })
                    }
            })
        }
    }
}

