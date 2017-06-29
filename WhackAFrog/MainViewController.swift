//
//  MainViewController.swift
//  WhackAFrog
//
//  Created by Shay Manzaly on 5/15/17.
//  Copyright © 2017 Shay Manzaly. All rights reserved.
/////

import UIKit

class MainViewController: UIViewController {

    var lvlpicked = 0
    
 
    @IBAction func easybtn(_ sender: UIButton) {
        lvlpicked = 1
        performSegue(withIdentifier: "startgame", sender: lvlpicked)
        return
    }
    
    @IBAction func medbtn(_ sender: UIButton) {
        lvlpicked = 2
        performSegue(withIdentifier: "startgame", sender: lvlpicked)
        return
    }

    @IBAction func hardbtn(_ sender: UIButton) {
        lvlpicked = 3
        performSegue(withIdentifier: "startgame", sender: lvlpicked)
        return
    }
    
    @IBAction func ldrbtn(_ sender: UIButton) {
                performSegue(withIdentifier: "leaderboards", sender: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "sunny-background")
        self.view.insertSubview(backgroundImage, at: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "startgame"){
        if let dest = segue.destination as? GameViewController{
            
            if let lvl = sender as? Int{
                dest.gameLevel = lvl
            }
        }
    }

            
        
    }


}

