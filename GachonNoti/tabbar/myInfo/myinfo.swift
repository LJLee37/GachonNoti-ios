//
//  infoMain.swift
//  GachonNoti
//
//  Created by USER on 20/07/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit

class infoMain: UIViewController {
    
    @IBAction func changeCate(_ sender: Any) {
        checkToShow()
    }
    
    @objc func move(sender: UIBarButtonItem) {
        if(connectedToNetwork()){
            notiSidOFF()
            setData("id","")
            setData("pass","")
            checkToShow()
        }else{
            self.justAlert(title: "로그아웃 오류",msg: "인터넷 연결을 확인해주세요.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkToShow()
    }
    
    func checkToShow(){
        if ((getData("id") == "") || (getData("pass") == "")){
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(move))
            remove(asChildViewController: notlogin)
            add(asChildViewController: login)
        }else{
            notiSidON()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(move))
            remove(asChildViewController: login)
            add(asChildViewController: notlogin)
        }
    }
    
    private lazy var login: myInfo = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "myInfo") as! myInfo
        return viewController
    }()
    
    private lazy var notlogin: tabMain = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "tabMain") as! tabMain
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
        viewController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabBarHeight)
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    private func justAlert(title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

