//
//  ViewController.swift
//  calculator2
//
//  Created by Yusuke Inoue on 2023/11/19.
//

import UIKit

class ViewController: UIViewController {
    // 入力された数字や計算結果を表示するテキスト
    @IBOutlet weak var displayLabel: UILabel!
    var currentOperation: String?
    var firstNumber: Double?
    // 電卓の状態を表すenum
    enum State {
        case initial
        case inputNumber
        case inputOperation
    }
    // 現在の状態を保持する変数
    var currentState: State = .initial


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // 0から9の数字が押された時に呼ばれる関数
    @IBAction func onTapNumberButton(_ sender: Any) {
        guard let button = sender as? UIButton,
              let numberString = button.titleLabel?.text else { return }

        switch currentState {
        // 初期値または演算子が走った場合(onTapOperationButtonが起動した後)
        case .initial, .inputOperation:
            displayLabel.text = numberString
            currentState = .inputNumber
        // inputNumberフェーズが続いていた場合　例：５を入力した後にも一度５を入力し５５にする場合。
        case .inputNumber:
            displayLabel.text = displayLabel.text! + numberString
        }
    }
    
    // +, -, ×, ÷のボタンが押された時に呼ばれる関数
    @IBAction func onTapOperationButton(_ sender: Any) {
        guard let button = sender as? UIButton,
              let operation = button.titleLabel?.text,
              let currentText = displayLabel.text,
              let number = Double(currentText) else { return }
        
        // ２つ目以降の演算子が入力された場合（計算可能）
        if let firstNum = firstNumber, let currentOperation = currentOperation {
            let result = performOperation(firstNum: firstNum, secondNum: number, operation: currentOperation)
            displayLabel.text = String(result)
            firstNumber = result
        // １つ目の演算子が入力された場合（計算不可能）
        } else {
            firstNumber = number
        }
        // オプショナルバインディングで弾かれようが弾かれまいが演算子が走ることは確実なのでcurrentOperationに最新の演算子を代入
        self.currentOperation = operation
        currentState = .inputOperation
    }

    // = ボタンが押された時の呼ばれる関数
    @IBAction func onTapEqualButton(_ sender: Any) {
        guard let operation = currentOperation,
              let firstNum = firstNumber,
              let secondNumText = displayLabel.text,
              let secondNum = Double(secondNumText) else { return }

        if currentState != .inputOperation {
            let result = performOperation(firstNum: firstNum, secondNum: secondNum, operation: operation)
            displayLabel.text = String(result)
            firstNumber = result
        }
        currentState = .initial
        currentOperation = nil
        firstNumber = nil
    }
    
    @IBAction func onTapACButton(_ sender: UIButton) {
        displayLabel.text = "0" // ディスプレイを0にリセット
        firstNumber = nil       // 最初の数値をリセット
        currentOperation = nil  // 現在の演算子をリセット
        currentState = .initial // 状態を初期状態にリセット
    }
    
    // 計算メソッドは再利用性がありそうだから切り出す（適当）
    func performOperation(firstNum: Double, secondNum: Double, operation: String) -> Double {
        switch operation {
        case "+":
            return firstNum + secondNum
        case "-":
            return firstNum - secondNum
        case "×":
            return firstNum * secondNum
        case "÷":
            return firstNum / secondNum
        default:
            fatalError("未知の演算子")
        }
    }

}

