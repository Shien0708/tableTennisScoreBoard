//
//  ViewController.swift
//  tableTennisScoreBoard
//
//  Created by 方仕賢 on 2022/3/3.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet var roundLabels: [UILabel]!
    @IBOutlet var scoreLabels: [UILabel]!
    @IBOutlet var addScoreButtons: [UIButton]!
    
    @IBOutlet var nameLabels: [UILabel]!
    @IBOutlet var serveLabels: [UILabel]!
    
    var player1Rounds = 0
    var player2Rounds = 0
    var player1 = 0
    var player2 = 0
    var pressedTimes = 0
    var process = [(Int, Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func changeServe(){
        if serveLabels[0].isHidden {
            serveLabels[0].isHidden = false
            serveLabels[1].isHidden = true
        } else {
            serveLabels[1].isHidden = false
            serveLabels[0].isHidden = true
        }
    }
    
    
    @IBAction func addScore(_ sender: UIButton) {
        pressedTimes += 1
        
        //幫兩邊球員加分
        if sender == addScoreButtons[0] {
            player1 += 1
            scoreLabels[0].text = "\(player1)"
        } else {
            player2 += 1
            scoreLabels[1].text = "\(player2)"
        }
        
        //判斷輪替發球次數
        if player1 >= 10 && player2 >= 10 {
            if player1 == 12 || player2 == 12 {
                showResult()
            }
            //交換發球
            changeServe()
            pressedTimes = 0
        } else {
            if player1 == 11 || player2 == 11 {
                showResult()
            }
            if pressedTimes == 2 {
                pressedTimes = 0
                //交換發球
                changeServe()
            }
        }
        
        //記錄得分過程
        process.append((player1, player2))
    }
    
    func showResult(){
        resultView.isHidden = false
        if player1 > player2 {
            resultLabel.text = "\(String(describing: nameLabels[1].text!)) wins"
                player1Rounds += 1
                roundLabels[0].text = "\(player1Rounds)"
            } else {
                resultLabel.text = "\(String(describing: nameLabels[0].text!)) wins"
                player2Rounds += 1
                roundLabels[1].text = "\(player2Rounds)"
            }
    }
    
    
    @IBAction func reset(_ sender: Any) {
        let alert = UIAlertController(title: "Reset", message: "Do you want to reset the game?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.again(reset: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func again(reset: Bool){
        player1 = 0
        player2 = 0
        process.removeAll()
        
        if reset {
            player1Rounds = 0
            player2Rounds = 0
            for i in 0...scoreLabels.count-1 {
                scoreLabels[i].text = "0"
                roundLabels[i].text = "0"
            }
        } else {
            for i in 0...scoreLabels.count-1 {
                scoreLabels[i].text = "0"
            }
        }
    }
    
    
    @IBAction func rewind(_ sender: Any) {
        if process.count > 0 {
            process.removeLast()
            
            if process.count > 0 {
                scoreLabels[0].text = "\(process[process.count-1].0)"
                scoreLabels[1].text = "\(process[process.count-1].1)"
                player1 = process[process.count-1].0
                player2 = process[process.count-1].1
            } else {
                scoreLabels[0].text = "0"
                scoreLabels[1].text = "0"
                player1 = 0
                player2 = 0
            }
            
        }
    }
    
    @IBAction func next(_ sender: Any) {
        resultView.isHidden = true
        again(reset: false)
    }
    
    @IBAction func changeSide(_ sender: Any) {
        var temp = 0
        var name = ""
        temp = player1
        player1 = player2
        player2 = temp
        
        temp = player1Rounds
        player1Rounds = player2Rounds
        player2Rounds = temp
        
        if process.count > 0 {
            for i in 0...process.count-1 {
                temp = process[i].0
                process[i].0 = process[i].1
                process[i].1 = temp
            }
        }
        
        name = nameLabels[0].text!
        nameLabels[0].text = nameLabels[1].text
        nameLabels[1].text = name
        
        
        if serveLabels[0].isHidden {
            serveLabels[0].isHidden = false
            serveLabels[1].isHidden = true
        } else {
            serveLabels[1].isHidden = false
            serveLabels[0].isHidden = true
        }
        
        scoreLabels[0].text = "\(player1)"
        scoreLabels[1].text = "\(player2)"
        roundLabels[0].text = "\(player1Rounds)"
        roundLabels[1].text = "\(player2Rounds)"
    }
    
}

