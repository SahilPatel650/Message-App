//
//  ViewController.swift
//  Message
//
//  Created by Sahil Patel on 11/22/20.
//

import UIKit
import FirebaseAuth


class ConversationsViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView
        //table.register(<#T##self: UITableView##UITableView#>)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
        
    }
    
    
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false) 
        }
    }


}

