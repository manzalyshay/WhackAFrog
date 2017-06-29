//
//  GameViewController.swift
//  WhackAFrog
//
//  Created by Shay Manzaly on 5/15/17.
//  Copyright © 2017 Shay Manzaly. All rights reserved.
/////

import UIKit
import CoreLocation

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    
    
    @IBOutlet var board: UICollectionView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    var frogs = [#imageLiteral(resourceName: "frog1"), #imageLiteral(resourceName: "frog2"), #imageLiteral(resourceName: "frog3"), #imageLiteral(resourceName: "frog4"), #imageLiteral(resourceName: "sickfrog1"), #imageLiteral(resourceName: "sickfrog2")]
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var frogTimer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var shakesLeft = 3
    var shakeCounter = 0
    var phoneShook = false
    var speed = 0.0
    var score = 0
    var randpic = 0
    var isFrogSick = false
    var frogCell : BoardCollectionViewCell!
    var frogPath : IndexPath!
    let manager = CLLocationManager()
    var userLocation : CLLocation? = nil
    let recordsManager = RecordsManager()
    
    private var _gameLevel = Int()
    
    var gameLevel : Int{
        get {
            return _gameLevel
        }
        set {
            _gameLevel = newValue
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "sunny-background")
        self.view.insertSubview(backgroundImage, at: 0)
        initSpeed()
        self.board.delegate = self
        self.board.dataSource = self
        self.becomeFirstResponder() // To get shake gesture

        showToast(message: "Go!")
    }
    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if (shakesLeft == 0){
            showToast(message: "No shakes left!")
            }
            else{
                phoneShook = true
                speed += 2
                shakesLeft-=1
                showToast(message: String(shakesLeft)+" Shakes left")
            }
        }
    }

    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timeLabel.text = String(seconds) //This will update the label.
        if (seconds == 0){
            timer.invalidate()
            finishGame()
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        runTimer()
        playGame()
    }
    
    func initSpeed(){
        switch gameLevel{
        case 1:
            speed = 3
        case 2:
            speed = 2
        case 3:
            speed = 1
        default:
            speed = 0
        }
    }
    
    var previousCell: UInt32? // used in randomNumber()
    
    func randomCell() -> UInt32 {
        var randomNumber = arc4random_uniform(16)
        while previousCell == randomNumber {
            randomNumber = arc4random_uniform(16)
        }
        previousCell = randomNumber
        return randomNumber
    }
    
    var previousPic: UInt32? // used in randomNumber()
    
    func randomPic() -> UInt32 {
        var randomNumber = arc4random_uniform(6)
        while previousPic == randomNumber {
            randomNumber = arc4random_uniform(6)
        }
        previousPic = randomNumber
        return randomNumber
    }
    
    func playGame(){
        let randrow:Int = Int(randomCell())
        self.randpic = Int(randomPic())
        
        if (randpic > 3){
            self.isFrogSick = true
        }
        
            self.frogPath = IndexPath(row: randrow, section: 0)
            board.reloadData()
            self.frogTimer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(dismissFrog), userInfo: nil, repeats: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath == frogPath){
            if (frogTimer.isValid)
            {
                frogTimer.invalidate()
            }
            if (self.isFrogSick == true){
                let when = DispatchTime.now() + 3
                DispatchQueue.main.asyncAfter(deadline: when) {
                   self.dismissFrog()
                }
            }
        else {
        self.score += 1
        self.scoreLabel.text = String(score)

        self.dismissFrog()
        }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = view.frame.width
        let widthPerItem = availableWidth / 4
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func dismissFrog(){
        if (frogCell != nil){
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.frogCell.cellPic.alpha = 0.0
        }, completion: nil)
        }
        self.isFrogSick=false
        
        if (phoneShook == true){
            if (shakeCounter == 2){
                phoneShook=false
                speed-=2
                shakeCounter=0
            }
            else {
                shakeCounter+=1
            }
        }
        
        playGame()

    }
    

    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BoardCollectionViewCell = self.board.dequeueReusableCell(withReuseIdentifier: ("collection_cell"), for: indexPath) as! BoardCollectionViewCell
        if (self.frogPath != nil && indexPath.row == self.frogPath.row) {
            let imageName = frogs[self.randpic]
            if (isFrogSick == true){
            cell.cellPic.image = cell.convertImageToBW(image: imageName)
            }
            else  {
            cell.cellPic.image = imageName
            }
            self.frogCell = cell;
            self.frogCell.cellPic.alpha = 1.0
            self.frogCell.rotate()
        }
        return cell
    }
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    func finishGame(){
        self.dismiss(animated: true, completion: nil)
        if (recordsManager.isLimit() == false){
            showSaveRecordDialod()
        }
        else {
            if (Int(recordsManager.getWorst()) < score){
                recordsManager.deleteRecord()
                showSaveRecordDialod()
            }
            else{
                showGameOverDialog(text: "Time is UP!")
            }
        }

        
    }
    func showSaveRecordDialod(){
        manager.startUpdatingLocation()
        //1. Create the alert controller.
        let alert = UIAlertController(title: "It's a Record!", message: "Please enter your name:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Full name"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.recordsManager.saveRecord(name: (textField?.text!)!, level: Int64(self.gameLevel), score: Int64(self.score), lat: (self.userLocation?.coordinate.latitude)!, long: (self.userLocation?.coordinate.longitude)!)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        self.performSegue(withIdentifier: "gameover", sender: nil)
    }
    
    func showGameOverDialog(text: String){
    let action = UIAlertAction(title: "Ok", style: .default) { action in
    self.performSegue(withIdentifier: "gameover", sender: nil)
    }
    let alert = UIAlertController(title: "Game Over",
    message: text,
    preferredStyle: .alert)
    alert.addAction(action)
    present(alert, animated: true)
    }
    

    
    
}

