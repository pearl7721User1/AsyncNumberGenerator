//
//  Calculator.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/01/26.
//

import UIKit

class NumberGenerator {
    
    static let totalNumberOfDigits = 6
    
    // MARK: - public
    @Published var firstSlotDigitAProcess: CGFloat = 0
    @Published var firstSlotDigitBProcess: CGFloat = 0
    @Published var firstSlotDigitCProcess: CGFloat = 0
    
    @Published var secondSlotDigitAProcess: CGFloat = 0
    @Published var secondSlotDigitBProcess: CGFloat = 0
    @Published var secondSlotDigitCProcess: CGFloat = 0
    
    @Published var firstIntegerSlotData: IntegerSlotData?
    @Published var secondIntegerSlotData: IntegerSlotData?
    
    
    func startGeneratingNumbers() {
        
    }
    
    func resetDigit(index: Int) {
        
    }
    
    func cancelTasks() {
        
    }

}
