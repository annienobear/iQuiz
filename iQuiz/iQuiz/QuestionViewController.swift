//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Hailun Zhang on 5/6/21.
//
import UIKit

class AnswerCell: UITableViewCell {
    @IBOutlet var ans : UILabel?
}

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    static let CELL_STYLE = "ansCellType"
    public var sectionNum: Int! = nil
    public var questionNum: Int! = nil
    public var currentSection: [String]! = nil
    public var totalScore: Int! = nil
    public var currentAns: [String]! = nil
    @IBOutlet weak var questionLabel: UILabel!
    let mathAns = [["2", "3", "4", "5"], ["0", "1", "2", "3"]]
    let marvelAns = [["1", "2", "3", "0"]]
    let scienceAns = [["O2", "CO2", "N2", "Noble gasses"]]
    let mathQuestions = ["What is 1 + 1?", "What is 5 - 4?"]
    let marvelQuestions = ["Hawkeye has how many children?"]
    let scienceQuestions = ["What does air consist of most?"]
    public var selectedAns: String! = nil
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnswerCell = self.tableView.dequeueReusableCell(withIdentifier: QuestionViewController.CELL_STYLE) as! AnswerCell
        cell.ans?.text = currentAns[indexPath.row]
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        tableView.dataSource = self
        tableView.delegate = self
        if questionNum == nil {
            questionNum = 0
        }
        if totalScore == nil {
            totalScore = 0
        }
        NSLog(String(sectionNum))
        switch sectionNum {
        case 1:
            currentSection = marvelQuestions
            currentAns = marvelAns[questionNum]
        case 2:
            currentSection = scienceQuestions
            currentAns = scienceAns[questionNum]
        default:
            currentSection = mathQuestions
            currentAns = mathAns[questionNum]
        }
        questionLabel.text = currentSection[questionNum]
        let recognizerR: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
        recognizerR.direction = .right
        self.view.addGestureRecognizer(recognizerR)
    }
    
    
    @objc func swipeRight(_ sender : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "toMain", sender: self)
    }
    
    @IBAction func goNext(_ sender: UIButton) {
        if selectedAns == nil {
            let controller = UIAlertController(title: "Oops", message: "Please select one answer", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Go"), style: .default, handler: {
                _ in NSLog("k")
            }))
            present(controller, animated: true, completion: {NSLog("kk")})
        } else {
            performSegue(withIdentifier: "toAns", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?  AnswerViewController{
            vc.ans = selectedAns
            vc.section = sectionNum
            vc.questionNum = questionNum
            vc.questionText = currentSection[questionNum]
            vc.maxNum = currentSection.count
            vc.totalScore = totalScore
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        selectedAns = currentAns[didSelectRowAt.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

