//
//  NavigationViewController.swift
//  RESTLightningFramework
//
//  Created by Matthew Ramsden on 1/3/19.
//  Copyright © 2019 Matthew Ramsden. All rights reserved.
//

import UIKit

public class NavigationViewController: UIViewController {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        
        let resultSavedGet = Current.lightningSaved.fetchSaved()
        switch resultSavedGet {
        case .success(_):
            let bundle = Bundle(for: ViewNodeViewController.self)
           let storyboard = UIStoryboard(name: "ViewNodeViewController", bundle: bundle)
          let vc = storyboard.instantiateViewController(withIdentifier: "ViewNodeViewController") as! ViewNodeViewController
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               self.navigationController?.pushViewController(vc, animated: true)
          }
        case .failure(_):
            let bundle = Bundle(for: AddNodeViewController.self)
            let storyboard = UIStoryboard.init(name: "AddNodeViewController", bundle: bundle)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddNodeViewController") as! AddNodeViewController
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}
