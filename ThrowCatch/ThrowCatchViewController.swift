//
//  ThrowCatchViewController.swift
//  ThrowCatch
//
//  Created by Kaveti, Dheeraj on 12/26/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

import UIKit

class ThrowCatchViewController: UIViewController {
    @IBOutlet weak var btnThrow: UIButton!
    
    @IBOutlet weak var btnCatch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.animateButton(button: self.btnCatch)
        self.animateButton(button: self.btnThrow)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func animateButton(button: UIButton) {
        UIView.animate(withDuration: 0.6, animations: {
            button.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
            }, completion: { (finish) in
            UIView.animate(withDuration: 0.6, animations: {
                button.transform = CGAffineTransform.identity
            })
        })
    }
    
    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
