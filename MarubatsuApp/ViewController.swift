//
//  ViewController.swift
//  MarubatsuApp
//
//  Created by 鳥山彰仁 on 2022/10/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    //効果音の変数
    var player: AVAudioPlayer?
    //ラベル
    @IBOutlet weak var questionLabel: UILabel!
    var currentQuestionNum: Int = 0
    var questions: [[String: Any]] = []
    @IBOutlet weak var maruButton: UIButton! //◯ボタン
    @IBOutlet weak var batsuButton: UIButton! //✗ボタン
    
    //ViewControllerのコンテンツビューが追加される直前に呼び出される
    override func viewWillAppear(_ animated: Bool) {
        calling()
    }
    
    //呼び出しメソッド
    func calling() {
        let myUserDefaults = UserDefaults.standard
        if myUserDefaults.object(forKey: "questionsAdd") != nil {
            questions = myUserDefaults.object(forKey: "questionsAdd") as! [[String: Any]]
        }
        showQuestion()
        buttonControl()
    }
    
    //問題作成ボタン
    @IBAction func questionCreationButton(_ sender: Any) {
    }
    
    //まるボタン
    @IBAction func tappedYesButton(_ sender: Any) {
        answerCheck(yourAnswer: true)
    }
    //ばつボタン
    @IBAction func tappedNoButton(_ sender: Any) {
        answerCheck(yourAnswer: false)
    }
    
    //　◯Ｘボタン制御メソッド
    func buttonControl() {
        // questionsの中身が空であれば
        if questions.isEmpty {
            //isEnabledがfalseでボタンを押せない
            maruButton.isEnabled = false
            batsuButton.isEnabled = false
            //alphaでボタンを透明にする
            maruButton.alpha = 0.7
            batsuButton.alpha = 0.7
        } else {
            // questionsの中身があればボタンが押せる
            maruButton.isEnabled = true
            maruButton.alpha = 1
            batsuButton.isEnabled = true
            batsuButton.alpha = 1
        }
    }
    
    
    //問題を表示する関数
    func showQuestion(){
        //問題が空であれば
        if questions.isEmpty == true {
            questionLabel.text =  "問題がありません。問題を作りましょう"
        } else {
            //let question = questions[currentQuestionNum]
            //問題をシャッフルしquestionに代入
            let question = questions.shuffled()[currentQuestionNum]
            print(question)
            if let que = question["textFieldAdd"] as? String {
                questionLabel.text = que
            }
        }
    }
    
    
    // 回答をチェックする関数
    func answerCheck(yourAnswer: Bool) {
        let question = questions[currentQuestionNum]
        //問題文が空でなければ
        if questions.isEmpty != true {
            //アンラップ
            if let ans = question["boolAnswer"] as? Bool {
                //yourAnswerがtrueであれば
                if yourAnswer == ans {
                    // currentQuestionNumを1足して次の問題に進む
                    currentQuestionNum += 1
                    showAlert(message: "正解")
                    //効果音(正解)
                    if let soundURL = Bundle.main.url(forResource: "正解", withExtension: "mp3") {
                        do {
                            player = try AVAudioPlayer(contentsOf: soundURL)
                            player?.play()
                        } catch {
                            print("error")
                        }
                    }
                } else {
                    // 不正解
                    showAlert(message: "不正解")
                    //効果音(不正解)
                    if let soundURL = Bundle.main.url(forResource: "不正解", withExtension: "mp3") {
                        do {
                            player = try AVAudioPlayer(contentsOf: soundURL)
                            player?.play()
                        } catch {
                            print("error")
                        }
                    }
                }
            } else {
                print("答えが入ってません")
                return
            }
            //currentQuestionNumの値が問題数以上だったら最初の問題に戻す
            if currentQuestionNum >= questions.count {
                currentQuestionNum = 0
            }
            showQuestion()
        }
    }
    
    // アラートを表示する関数
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
}
