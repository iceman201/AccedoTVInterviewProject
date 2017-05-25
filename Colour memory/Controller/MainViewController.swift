//
//  ViewController.swift
//  Colour memory
//
//  Created by Liguo Jiao on 25/05/17.
//  Copyright © 2017 Liguo Jiao. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBAction func startGameAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showGame", sender: self)
    }
    
    @IBAction func rankAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showRank", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}

