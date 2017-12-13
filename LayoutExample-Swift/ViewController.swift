//
//  ViewController.swift
//  LayoutExample-Swift
//
//  Created by 胡金友 on 2017/12/10.
//

import UIKit
import AUULayout_Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let view1 = UIView()
        view1.backgroundColor = UIColor.red
        self.view.addSubview(view1)
        
        let view2 = UIView()
        view2.backgroundColor = UIColor.blue
        self.view.addSubview(view2)
        
        H[20][view1[view2]][20][view2][20].end()
        V[100][view1[100]].cut()
        V[100][view2[100]].cut()
        
        
        LayoutAssistant.debugEnableLog(enable: true)
        LayoutAssistant.setRepetitionLayoutConstrantsHandler { (oldLayoutConstraints, newLayoutConstraints) in
            NSLayoutConstraint.deactivate([oldLayoutConstraints])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

