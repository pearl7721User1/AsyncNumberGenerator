//
//  DigitSlotsView.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/01/28.
//

import UIKit

@IBDesignable
class IntegerSlotView: UIView {

    private var firstDigit: Int?
    private var secondDigit: Int?
    private var thirdDigit: Int?
    
    private (set) var isCompleted: Bool = false {
        didSet {
            if isCompleted == false {
                self.backgroundColor = UIColor.red
            } else {
                self.backgroundColor = UIColor.init(red: 0/255.0, green: 150/255.0, blue: 28/255.0, alpha: 1.0)
            }
        }
    }
    
    private let firstDigitLabel = UILabel()
    private let secondDigitLabel = UILabel()
    private let thirdDigitLabel = UILabel()
    
    var allLabels: [UILabel] {
        return [firstDigitLabel, secondDigitLabel, thirdDigitLabel]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func input(array: [Int]) {
        guard array.count == 3 else { return }
        
        self.firstDigit = array[0]
        self.secondDigit = array[1]
        self.thirdDigit = array[2]
        updateStatesAndViews()
    }
    
    func reset() {
        firstDigit = nil
        secondDigit = nil
        thirdDigit = nil
        updateStatesAndViews()
    }
    
    private func commonInit() {
        
        allLabels.forEach({
            self.addSubview($0)
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.black.cgColor
            $0.font = UIFont.boldSystemFont(ofSize: 25)
            $0.textAlignment = .center
            $0.backgroundColor = UIColor.white
            $0.layer.cornerRadius = 5.0
            $0.layer.masksToBounds = true
        })
        
        self.backgroundColor = UIColor.red
    }
    
    override func layoutSubviews() {
        
        allLabels.forEach({$0.frame = CGRect.init(x: 0, y: 0, width: 25, height: 45)})
        
        secondDigitLabel.center = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY)
        firstDigitLabel.center = CGPoint.init(x: secondDigitLabel.center.x - 35, y: self.bounds.midY)
        thirdDigitLabel.center = CGPoint.init(x: secondDigitLabel.center.x + 35, y: self.bounds.midY)
        
    }
    
    
    private func updateStatesAndViews() {
        
        // update view State
        if self.firstDigit != nil, self.secondDigit != nil, self.thirdDigit != nil {
            self.isCompleted = true
        } else {
            self.isCompleted = false
        }
        
        // update view
        if let firstDigit = self.firstDigit {
            self.firstDigitLabel.text = "\(firstDigit)"
        } else {
            self.firstDigitLabel.text = ""
        }
        
        if let secondDigit = self.secondDigit {
            self.secondDigitLabel.text = "\(secondDigit)"
        } else {
            self.secondDigitLabel.text = ""
        }
        
        if let thirdDigit = self.thirdDigit {
            self.thirdDigitLabel.text = "\(thirdDigit)"
        } else {
            self.thirdDigitLabel.text = ""
        }
    }

}

// MARK: - Integer Slot Data
struct IntegerSlotData {
    let firstDigit: Int
    let secondDigit: Int
    let thirdDigit: Int
    
    var integer: Int {
        return firstDigit * 100 + secondDigit * 10 + thirdDigit
    }
    
    var array: [Int] {
        return [firstDigit, secondDigit, thirdDigit]
    }
    
    init(sum: Int) {
        firstDigit = (sum % 1000) / 100
        secondDigit = (sum % 100) / 10
        thirdDigit = (sum % 10) / 1
    }
    
    init(firstDigit: Int, secondDigit: Int, thirdDigit: Int) {
        self.firstDigit = firstDigit
        self.secondDigit = secondDigit
        self.thirdDigit = thirdDigit
    }
}
