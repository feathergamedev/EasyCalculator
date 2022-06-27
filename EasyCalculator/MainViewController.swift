//
//  MainViewController.swift
//  EasyCalculator
//
//  Created by 鍾羽揚 on 2021/9/25.
//
extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

import UIKit

class MainViewController: UIViewController {
    
    enum OperatorType : String
    {
        case none = "none"
        case add = "add"
        case minus = "minus"
        case multiply = "multiply"
        case divide = "divide"
    }
    
    var resultNumber : Float = 0.0
    var lastInput : String = ""
    var tempNumber : Float = 0.0
    var currentOperator : OperatorType = OperatorType.none
    
    var isInDecimalMode : Bool = false
    var decimalIndex : Float = 0
    
    @IBOutlet weak var resultLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = "0"
        
        // Do any additional setup after loading the view.
    }
           
    @IBAction func NumberButtonClicked(_ sender: UIButton)
    {
        if let number = Float(sender.restorationIdentifier!)
        {
            if lastInput == ""
            {
                resultLabel.text = "\(number.clean)"
                resultNumber = number
            }
            else
            {
                //正在輸入第二個數字
                if currentOperator != OperatorType.none
                {
                    if isInDecimalMode
                    {
                        if number != 0
                        {
                            tempNumber = tempNumber + (number / decimalIndex)
                        }

                        decimalIndex *= 10
                    }
                    else
                    {
                        tempNumber = tempNumber * 10 + number
                    }
                    
                    resultLabel.text = "\(tempNumber.clean)"
                }
                else
                {
                    if IsNumber(str: lastInput) || lastInput == "."
                    {
                        if isInDecimalMode
                        {
                            if number != 0
                            {
                                resultNumber = resultNumber + (number / decimalIndex)
                            }
                            decimalIndex *= 10
                        }
                        else
                        {
                            resultNumber = resultNumber * 10 + number
                        }
                        
                        resultLabel.text?.append("\(number.clean)")
                    }
                }
            }
                            
            lastInput = sender.restorationIdentifier!
        }
    }
    
    @IBAction func OperatorButtonClicked(_ sender: UIButton)
    {
        if (lastInput == ".")
        {
            isInDecimalMode = false
            resultLabel.text?.removeLast()
        }
        
        if currentOperator != OperatorType.none
            && tempNumber != 0
        {
            ComputeResult()
            resultLabel.text = "\(resultNumber.clean)"
        }
                
        if let identifier = sender.restorationIdentifier
        {
            currentOperator = OperatorType(rawValue: identifier)!
            lastInput = identifier
        }
                
        isInDecimalMode = false
    }
    
    @IBAction func DecimalButtonClicked(_ sender: UIButton)
    {
        if isInDecimalMode || !IsNumber(str: lastInput)
        {
            return
        }
        
        lastInput = "."
        resultLabel.text?.append(".")

        isInDecimalMode = true
        decimalIndex = 10
    }
    
    @IBAction func CalculateButtonClicked(_ sender: UIButton)
    {
        ComputeResult()
        resultLabel.text = "\(resultNumber.clean)"
    }
    
    func ComputeResult()
    {
        if currentOperator == OperatorType.none
        {
            return
        }
        
        switch currentOperator
        {
            case OperatorType.add:
                resultNumber += tempNumber
            case OperatorType.minus:
                resultNumber -= tempNumber
            case OperatorType.multiply:
                resultNumber *= tempNumber
            case OperatorType.divide:
                resultNumber /= tempNumber
            default:
                break
        }
        
        if (decimalIndex != 0)
        {            
            resultNumber *= decimalIndex
            resultNumber.round(FloatingPointRoundingRule.toNearestOrAwayFromZero)
            resultNumber /= decimalIndex
        }
        
        ResetData()
    }
    
    @IBAction func ClearButtonClicked(_ sender: UIButton)
    {
        resultNumber = 0
        resultLabel.text = "0"
        
        ResetData()
    }
    
    func ResetData()
    {
        currentOperator = OperatorType.none
        isInDecimalMode = false
        lastInput = ""
        decimalIndex = 0
        tempNumber = 0
    }
    
    func IsNumber(str: String) -> Bool
    {
        return Int(str) != nil
    }
    
    func IsOperator(str: String) -> Bool
    {
        return str == "add" ||
            str == "minus" ||
            str == "multiply" ||
            str == "divide"
    }
}
