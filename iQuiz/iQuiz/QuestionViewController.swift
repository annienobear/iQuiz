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
    public var currentSection: [String]! = []
    public var totalScore: Int! = nil
    public var currentAnsList: [String]! = []
    public var currentAns: String! = nil
    public var questionData: [Quiz]! = nil
    @IBOutlet weak var questionLabel: UILabel!
    public var selectedAns: String! = nil
    public var url: String! = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentAnsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AnswerCell = self.tableView.dequeueReusableCell(withIdentifier: QuestionViewController.CELL_STYLE) as! AnswerCell
        cell.ans?.text = currentAnsList[indexPath.row]
        return cell
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("QuestionView" + String(sectionNum))
        self.tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        tableView.dataSource = self
        tableView.delegate = self
        if questionNum == nil {
            questionNum = 0
        }
        if totalScore == nil {
            totalScore = 0
        }
        let question = questionData[sectionNum]
        for q in question.questions {
            currentSection.append(q.text)
        }
        currentAnsList = question.questions[questionNum].answers
        questionLabel.text = currentSection[questionNum]
        currentAns = question.questions[questionNum].answer
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
            vc.data = questionData
            vc.url = url
            let temp = Int(currentAns) ?? 0
            vc.correctAns = currentAnsList[temp - 1]
        }
        
        if let v = segue.destination as? ViewController{
            v.urlString = url
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        selectedAns = currentAnsList[didSelectRowAt.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}

