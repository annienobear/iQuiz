//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Hailun Zhang on 5/11/21.
//

import UIKit

class AnswerViewController: UIViewController {
    
    public var ans: String! = nil
    public var section: Int! = nil
    public var questionNum: Int! = nil
    public var maxNum: Int! = nil
    public var totalScore: Int! = nil
    public var questionText: String! = nil
    public var correctAns: String! = nil
    public var data: [Quiz]? = nil
    public var url: String! = nil
    @IBOutlet weak var alarm: UILabel!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var Ans: UILabel!
    @IBAction func getNext(_ sender: UIButton) {
        if maxNum == questionNum {
            performSegue(withIdentifier: "toFinish", sender: self)
        } else {
            performSegue(withIdentifier: "toQues", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? QuestionViewController {
            vc.sectionNum = section
            vc.questionNum = questionNum
            vc.totalScore = totalScore
            vc.questionData = data
            vc.url = url
        }
        if let vc = segue.destination as? FinishViewController {
            vc.scoreOnQuiz = totalScore
            vc.totalQuestion = maxNum
            vc.url = url
        }
        if let v = segue.destination as? ViewController{
            v.urlString = url
        }
    }
    
    @objc func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if maxNum == questionNum {
            performSegue(withIdentifier: "toFinish", sender: self)
        } else {
            performSegue(withIdentifier: "toQues", sender: self)
        }
    }
    
    @objc func swipeRight(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("AnsView" + String(section))

        if ans == correctAns {
            alarm.text = "You got it right"
            totalScore += 1
        } else {
            alarm.text = "You got it wrong"
        }
        let recognizerL: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
        let recognizerR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        recognizerL.direction = .left
        recognizerR.direction = .right
        self.view .addGestureRecognizer(recognizerL)
        self.view.addGestureRecognizer(recognizerR)
        Ans.text = "Correct: " + correctAns
        question.text = questionText
        questionNum = questionNum + 1
    }
    
}
