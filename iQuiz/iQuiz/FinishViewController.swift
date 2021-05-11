//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Hailun Zhang on 5/11/21.
//

import UIKit

class FinishViewController: UIViewController {
    public var scoreOnQuiz: Int! = nil
    public var totalQuestion: Int! = nil
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBAction func goNext(_ sender: UIButton) {
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @objc func swipeRight(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        score.text = "You got " + String(scoreOnQuiz) + " of " + String(totalQuestion) + " right"
        if totalQuestion == scoreOnQuiz {
            message.text = "Perfect"
        } else {
            message.text = "Almost"
        }
        let recognizerR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        recognizerR.direction = .right
        self.view.addGestureRecognizer(recognizerR)
    }
}
