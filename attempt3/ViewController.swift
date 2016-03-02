//
//  ViewController.swift
//  attempt3
//
//  Created by Michelle Emamdie on 9/12/15.
//  Copyright © 2015 Michelle Emamdie. All rights reserved.
//

import UIKit
import Foundation

//Used to differentiate who is playing
enum Player: Int {
    case  User1 = 2, User2 = 3
}

class ViewController: UIViewController {
    var globalScores = NSUserDefaults.standardUserDefaults()
    var winCounter = 0
    //Contains the 9 image blocks
    @IBOutlet var images: [UIImageView]!
    
    @IBOutlet var scoreLink: UIButton!
    
    //Clears the board
    @IBOutlet var resetBtn : UIButton!
    
    //Message to display whose turn it is and when a win has occurred
    @IBOutlet var userMessage : UILabel!
    
    var numberOfImages = 0
    var plays = [Int:Int]()
    //Check to see if the game is done
    var done = false
    //Check to see if the computer is choosing a move
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for imageView in images {
            
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageClicked:"))
        }
        userMessage.text = "\(player1Name) make the first move!"
        userMessage.hidden = false
    }
    
    func checkForWin(){
        let whoWon = ["\(player1Name)": 2, "\(player2Name)": 3]
    
        for (key,value) in whoWon {
            if ((plays[6] == value && plays[7] == value && plays[8] == value) || //across the bottom
                (plays[3] == value && plays[4] == value && plays[5] == value) || //across the middle
                (plays[0] == value && plays[1] == value && plays[2] == value) || //across the top
                (plays[6] == value && plays[3] == value && plays[0] == value) || //down the left side
                (plays[7] == value && plays[4] == value && plays[1] == value) || //down the middle
                (plays[8] == value && plays[5] == value && plays[2] == value) || //down the right side
                (plays[6] == value && plays[4] == value && plays[2] == value) || //diagonal
                (plays[8] == value && plays[4] == value && plays[0] == value)){//diagonal
                    somebodyWon(key)
            }
        }
    }
    
    func somebodyWon(winner: String) {
        var foundWinner = false
        userMessage.hidden = false
        userMessage.font = userMessage.font.fontWithSize(30)
        userMessage.text = "Looks like \(winner) won!"
        scoreLink.hidden = false
        resetBtn.hidden = false
        done = true;
        var indexPosition = 0
        print("\(winner) initially had \(scores[winner]) wins")
        getDefaults()
        if scores[winner] == nil {
            scores[winner] = 0
        }
        scores[winner]!++
        setDefaults()
        print("Since \(winner) won, we incremented their wins to \(scores[winner]!)")
    }
    
    func setDefaults() {
        NSUserDefaults.standardUserDefaults().setObject(scores, forKey: "scoresArray")
        NSUserDefaults.standardUserDefaults().synchronize()
        print("Hopefully something was added to NSUserDefaults")
    }
    
    func getDefaults() {
        scores = [String:Int]()
        if NSUserDefaults.standardUserDefaults().objectForKey("scoresArray") != nil {
            let tempContent = NSUserDefaults.standardUserDefaults().objectForKey("scoresArray")! as? [String: Int]

            for (key, value) in tempContent! {
                scores[key] = value
                print("The key is \(key) and the value is \(value)")
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    //Gesture Reocgnizer method
    func imageClicked(reco: UITapGestureRecognizer) {
        let imageViewTapped = reco.view as! UIImageView
        //Prevents the system from recognizing a tap in a box that is already filled
        if(plays[imageViewTapped.tag] == nil) {
                if plays[imageViewTapped.tag] == nil && !done {
                    if whoseTurn == 1 {
                        setImageForSpot(imageViewTapped.tag, player:.User1)
                        numberOfImages++
                        userMessage.text = "\(player2Name) it is your turn."
                        userMessage.hidden = false
                        whoseTurn = 2
                    }
                    else if whoseTurn == 2 {
                        setImageForSpot(imageViewTapped.tag, player:.User2)
                        numberOfImages++
                        userMessage.text = "\(player1Name) it is your turn."
                        userMessage.hidden = false
                        whoseTurn = 1
                    }
                }
                checkForWin()
                checkTie()
            }
    }
    
    func checkTie() {
        if numberOfImages == 9  && !done {
            userMessage.hidden = false
            userMessage.font = userMessage.font.fontWithSize(30)
            userMessage.text = "Looks like it is a tie!"
            scoreLink.hidden  = false
            resetBtn.hidden = false;
            done = true;
        }
    }
    
    @IBAction func resetBtnClicked(sender : UIButton) {
        done = false
        resetBtn.hidden = true
        reset()
    }
    
    func reset() {
        plays = [:]
        images[0].image = nil
        images[1].image = nil
        images[2].image = nil
        images[3].image = nil
        images[4].image = nil
        images[5].image = nil
        images[6].image = nil
        images[7].image = nil
        images[8].image = nil
        userMessage.font = userMessage.font.fontWithSize(21)
        userMessage.text = "\(player1Name), start the new game!"
        numberOfImages = 0
        scoreLink.hidden = true
        whoseTurn = 1
    }
    
    func setImageForSpot(spot:Int, player: Player){
        var playerMark: String
        if player == .User1 || player == .User1 {
            playerMark = "x"
        }
        else {
            playerMark = "o"
        }
        plays[spot] = player.rawValue
        
        images[spot].image = UIImage(named: playerMark)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}