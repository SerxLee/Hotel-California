//
//  PickerDateViewController.swift
//  PopupControl
//
//  Created by Serx on 1/23/16.
//  Copyright © 2016 serx. All rights reserved.
//

import UIKit


public protocol MyDatePickerViewControllerDelegate{
    func myPickDateViewConrollerDidFinish(controller: PickerDateViewController, andSelectedDate selected: NSDate)
}

public class PickerDateViewController: UIViewController {

    @IBOutlet weak var datePickerView: UIDatePicker!
    
    public var delegate: MyDatePickerViewControllerDelegate?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(){
        
        let resourcesBundle = NSBundle(forClass: PickerDateViewController.self)
        super.init(nibName: "PickerDateViewController", bundle: resourcesBundle)
    }
    
    public func showInView(superview: UIView){
        
        if self.view.superview == nil{
            superview.addSubview(self.view)
        }
        
        self.view.center = CGPointMake(self.view.center.x, 900)
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
            superview.frame.size.width, self.view.frame.size.height)
        
        UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.view.center = CGPointMake(superview.center.x, superview.frame.size.height - self.view.frame.size.height / 2)
            
            }, completion: nil)
    }
    
    public func hideInView(){
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.view.center = CGPointMake(self.view.center.x, 900)
            }, completion: nil)
    }

    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
    
        self.hideInView()
        self.delegate?.myPickDateViewConrollerDidFinish(self, andSelectedDate: self.datePickerView.date)
    }

    @IBAction func done(sender: AnyObject) {
        
        self.hideInView()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
