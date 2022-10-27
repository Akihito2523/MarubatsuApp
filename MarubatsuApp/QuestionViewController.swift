//
//  QuestionViewController.swift
//  MarubatsuApp
//
//  Created by 鳥山彰仁 on 2022/10/24.
//
import UIKit

class QuestionViewController: UIViewController {
    
    //空の質問文の配列
    var questions: [[String: Any]] = []
    //問題文テキストフィールド
    @IBOutlet weak var textField: UITextField!
    //　◯Ｘセグメンテッドコントローラー
    @IBOutlet weak var outletSegmentedControl: UISegmentedControl!
    //　◯Ｘ表示ラベル
    @IBOutlet weak var selectionSegment: UILabel!
    
    
    //アプリが起動したときに呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.placeholder = "問題文を入力してください"
        selectionSegment.text = "✗が選択されてます"
        //セグメンテッドコントローラー選択している項目の背景色
        outletSegmentedControl.selectedSegmentTintColor = UIColor.systemMint
        outletSegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor:UIColor.black], for: .normal)
    }
    
    //テキストフィールドに最初からフォーカスが表示される
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
    
    
    //TOPに戻るボタン
    @IBAction func topScreenButton(_ sender: Any) {
        //前の画面に遷移
        dismiss(animated: false, completion: nil)
    }
    
    
    //セグメンテッドコントローラー◯Ｘスイッチ
    @IBAction func actionSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("✗が選択されてます")
            selectionSegment.text = "✗が選択されてます"
        case 1:
            print("◯が選択されてます")
            selectionSegment.text = "◯が選択されてます"
        default:
            print("存在しない番号")
        }
    }
    
    
    //問題を保存するボタン
    @IBAction func saveQuestionButton(_ sender: Any) {
        //もしテキストフィールドが空であれば
        if textField.text?.isEmpty ?? true {
            showAlert(message: "問題文を入力してください。")
        } else {
            //真偽値の初期化
            var boolAnswer: Bool
            //0であればfalse、1であればtrueを代入する
            if outletSegmentedControl.selectedSegmentIndex == 0 {
                boolAnswer = false
            } else {
                boolAnswer = true
            }
            
            //UserDefaultsのインスタンスの生成
            let myUserDefaults = UserDefaults.standard
            //データの読み込み
            questions = myUserDefaults.object(forKey: "questionsAdd") as! [[String: Any]]
            //questionsに問題文と◯✗を追加する
            questions.append(["textFieldAdd": textField.text!, "boolAnswer": boolAnswer])
            //questionsに入った配列をquestionsAddとして保存
            myUserDefaults.set(questions, forKey: "questionsAdd")
            print(questions)
            
            if let problem = textField.text {
                showAlert(message: "\(problem)\n問題文を保存しました。")
                //テキストフィールドを空にする
                textField.text = ""
            }
        }
    }
    
    
    //問題を全て削除ボタン
    @IBAction func deleteAllQuestionButton(_ sender: Any) {
        //配列を空にする
        questions = []
        UserDefaults.standard.set(questions, forKey: "questionsAdd")
        deleteAlert()
    }
    
    
    // メッセージアラート
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }
    
    
    //削除アラート
    func deleteAlert(){
        let alert = UIAlertController(title: "　◯Ｘクイズ", message: "問題を全て削除しますか？", preferredStyle: .alert)
        let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (action) -> Void in
            
        })
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
            
        })
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}
