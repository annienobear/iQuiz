//
//  ViewController.swift
//  iQuiz
//
//  Created by Hailun Zhang on 5/5/21.
//

import UIKit

class QuizCell: UITableViewCell {
    @IBOutlet var title : UILabel?
    @IBOutlet var subtitle : UILabel?
    @IBOutlet var picture : UIImageView?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    static let CELL_STYLE = "quizCellType"
    let quizzes = ["Mathematics", "Marvel Super Heroes", "Science"]
    let subtitle = ["Yeah. We all love Math", "The world needs Heroes", "Learn the world."]
    let images = ["Math", "Marvel", "Science"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuizCell = self.tableView.dequeueReusableCell(withIdentifier: ViewController.CELL_STYLE) as! QuizCell
        cell.title?.text = quizzes[indexPath.row]
        cell.subtitle?.text = subtitle[indexPath.row]
        cell.picture?.image = UIImage(named: images[indexPath.row])
        return cell
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow{
            let questionSet = indexPath.row
            let questionView = segue.destination as! QuestionViewController
            questionView.sectionNum = questionSet
        }
    }
        
    @IBOutlet weak var tableView: UITableView!
    @IBAction func setting(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "Settings", message: "Settings go here", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Good to go"), style: .default, handler: {
            _ in NSLog("k")
        }))
        present(controller, animated: true, completion: {NSLog("kk")})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "QuizCell", bundle: nil), forCellReuseIdentifier: "QuizCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //check which cell is pressed, and send over data
//        if segue.destination is QuestionViewController {
//        }
//    }
}

