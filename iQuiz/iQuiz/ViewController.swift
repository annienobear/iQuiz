//
//  ViewController.swift
//  iQuiz
//
//  Created by Hailun Zhang on 5/5/21.
//  fetch part according to: https://www.youtube.com/watch?v=_TrPJQWD8qs

import UIKit

struct Quiz: Codable{
    let title: String
    let desc: String
    let questions: [Question]
}

struct Question: Codable{
    let text: String
    let answer: String
    let answers: [String]
}

class QuizCell: UITableViewCell {
    @IBOutlet var title : UILabel?
    @IBOutlet var subtitle : UILabel?
    @IBOutlet var picture : UIImageView?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    static let CELL_STYLE = "quizCellType"
    public var refreshControl = UIRefreshControl()
//    let defaults = UserDefaults.standard
    public var urlString: String = "http://tednewardsandbox.site44.com/questions.json"
//    public var urlString: String = "http://test449.site44.com/ques.json"
    // TRY THIS
    public var questionInfo : [Quiz]? = nil
    public var quizzes : [String] = []
    public var subtitle : [String] = []
    var text: UITextField = UITextField()
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
            questionView.questionData = questionInfo
            questionView.url = urlString
        }
    }
        
    @IBOutlet weak var tableView: UITableView!
    @IBAction func setting(_ sender: UIBarButtonItem) {
        let controller = UIAlertController(title: "Settings", message: "Enter URL", preferredStyle: .alert)
        controller.addTextField { (textField: UITextField) in
            self.text = textField
            self.text.placeholder = "Enter url here"
        }
        controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        controller.addAction(UIAlertAction(title: NSLocalizedString("Check Now", comment: "Good to go"), style: .default, handler: {_ in
            if((self.text.text) != nil){
                NSLog("try")
                self.fetchData(self.text.text!)
            }
        }))
        present(controller, animated: true, completion: {NSLog("fetch attempted")})
    }
    
    func fetchData(_ fetchString: String) {
        urlString = fetchString
        let url = URL(string: fetchString)
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = "data.json"
        guard url != nil else {
            self.alertMessage(mess: "Empty JSON Error")
            return
        }
        if Reachability().isInternetAvailable() {
            let session = URLSession.shared
                let dataTask = session.dataTask(with: url!) {
                (data, response, error) in
                if error == nil && data != nil {
                    do {
                        let decoder = JSONDecoder()
                        let newQuiz = try decoder.decode([Quiz].self, from: data!)
//                        self.defaults.set(fetchString, forKey: "url")
//                        self.defaults.set(data, forKey:"data")
                        self.questionInfo = newQuiz
                        self.quizzes = []
                        self.subtitle = []
                        for quiz in newQuiz {
                            self.quizzes.append(quiz.title)
                            self.subtitle.append(quiz.desc)
                        }
                        if directory != nil {
                            let filePath = directory?.appendingPathComponent(fileName)
                            do {
                                try data!.write(to: filePath!, options: Data.WritingOptions.atomic)
                            }
                            catch { self.alertMessage(mess: "cannot save data")}
                        } else {
                            self.alertMessage(mess: "cannot download data")
                        }
                    } catch{
                        self.alertMessage(mess: "Error on Parsing Data")
                    }
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
            dataTask.resume()
        } else {
            alertMessage(mess: "Cannot connect to internet, loading local data")
            DispatchQueue.global(qos: .userInitiated).async {
                if directory != nil {
                    let fileurl = directory?.appendingPathComponent(fileName)
                    var data: Data? = nil
                    do {
                        try data = Data(contentsOf: fileurl!)
                    }
                    catch { NSLog(error.localizedDescription) }
                    if data != nil && data!.count > 0 {
                        let decoder = JSONDecoder()
                        do {
                            let newQuiz = try decoder.decode([Quiz].self, from: data!)
                            DispatchQueue.main.async {
//                                self.defaults.set(fetchString, forKey: "url")
//                                self.defaults.set(data, forKey:"data")
                                self.questionInfo = newQuiz
                                self.quizzes = []
                                self.subtitle = []
                                for quiz in newQuiz {
                                    self.quizzes.append(quiz.title)
                                    self.subtitle.append(quiz.desc)
                                }
                                self.tableView?.reloadData()
                            }
                        } catch {
                            self.alertMessage(mess: "cannot load data from local")
                        }
                    }
                    else {
                        self.alertMessage(mess: "No internet and no local data")
                    }
                }
            }
        }
    }
    
    @objc func refresh(sender:AnyObject)
    {
        fetchData(urlString)
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "QuizCell", bundle: nil), forCellReuseIdentifier: "QuizCell")
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
//        if defaults.object(forKey: "url") != nil{
//            self.urlString = defaults.object(forKey: "url") as! String
//            self.questionInfo = defaults.object(forKey: "data") as? [Quiz]
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
            if questionInfo == nil {
                fetchData(urlString)
            }
//        } else {
//            alertMessage(mess: "No internet access, check internet")
//            let data = defaults.object(forKey: "data")
//            if data == nil {
//                alertMessage(mess: "No local storage data found")
//            }else{
//                do{
//                    let questions = try JSONDecoder().decode([Quiz].self, from: data as! Data)
//                    self.questionInfo = questions
//                    for q in questions{
//                        self.quizzes.append(q.title)
//                        self.subtitle.append(q.desc)
//                    }
//                }catch{
//                    self.alertMessage(mess: "Fail to fetch")
//                }
//                self.tableView.reloadData()
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func alertMessage(mess: String) {
        let controller = UIAlertController(title: "Error", message: mess, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Good to go"), style: .default, handler: {
            _ in NSLog("k")
        }))
        present(controller, animated: true, completion: {NSLog("kk")})
    }
}
