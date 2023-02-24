//
//  NumberGeneratorWithOperation.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/02/07.
//

import UIKit

class NumberGeneratorWithOperation: NumberGenerator {
    
    private var operationQueue = OperationQueue()
    private var observation : NSKeyValueObservation?
    
    // intermediate values
    private var firstSlotDigitA: Int? = nil
    private var firstSlotDigitB: Int? = nil
    private var firstSlotDigitC: Int? = nil
    
    private var secondSlotDigitA: Int? = nil
    private var secondSlotDigitB: Int? = nil
    private var secondSlotDigitC: Int? = nil
    
    // firstSlotDigits operations
    var operationA: DigitGenerationOperation!
    var operationB: DigitGenerationOperation!
    var operationC: DigitGenerationOperation!
    
    // secondSlotDigits operations
    var operationD: DigitGenerationOperation!
    var operationE: DigitGenerationOperation!
    var operationF: DigitGenerationOperation!
    
    //
    var firstIntegerSlotOperation: BlockOperation!
    var secondIntegerSlotOperation: BlockOperation!
    
    override func cancelTasks() {
        operationQueue.cancelAllOperations()
    }
    
    override func startGeneratingNumbers() {
        startGenerateNumbersForFirstSlot()
        startGenerateNumbersForSecondSlot()
    }
    
    private func startGenerateNumbersForFirstSlot() {
        // for first slot operations
        let firstIntegerSlotOperation = createIntermediateOperation(integerSlotIndex: 0)
        
        for i in 0..<3 {
            let operation = createOperation(digitSlotIndex: i)
            
            // add dependency
            firstIntegerSlotOperation.addDependency(operation)
            
            // add operations
            operationQueue.addOperation(operation)
        }
        
        operationQueue.addOperation(firstIntegerSlotOperation)
    }
    
    private func startGenerateNumbersForSecondSlot() {
        // for second slot operations
        let secondIntegerSlotOperation = createIntermediateOperation(integerSlotIndex: 1)
        
        for i in 3..<6 {
            let operation = createOperation(digitSlotIndex: i)
            
            // add dependency
            secondIntegerSlotOperation.addDependency(operation)
            
            operation.addDependency(firstIntegerSlotOperation)
            
            // add operations
            operationQueue.addOperation(operation)
        }
        
        operationQueue.addOperation(secondIntegerSlotOperation)
    }
    
    override func resetDigit(index: Int) {
        
        if (0..<3).contains(index) {
            
            // cancel all second slots
            cancelAllSecondSlots()
            
            // reset relevant first slot
            let operation = createOperation(digitSlotIndex:index)

            if firstIntegerSlotOperation.isFinished {
                let newFirstIntegerSlotOperation = createIntermediateOperation(integerSlotIndex: 0)
                newFirstIntegerSlotOperation.addDependency(operation)
                operationQueue.addOperation(newFirstIntegerSlotOperation)
            } else {
                firstIntegerSlotOperation.addDependency(operation)
            }
            operationQueue.addOperation(operation)
            
            // regenerate all second slots
            startGenerateNumbersForSecondSlot()
            return
        }
        
        if (3..<6).contains(index) {
            
            // reset relevant second slot
            
            let operation = createOperation(digitSlotIndex:index)

            if secondIntegerSlotOperation.isFinished {
                let newSecondIntegerSlotOperation = createIntermediateOperation(integerSlotIndex: 1)
                newSecondIntegerSlotOperation.addDependency(operation)
                operationQueue.addOperation(newSecondIntegerSlotOperation)
            } else {
                secondIntegerSlotOperation.addDependency(operation)
            }
            operationQueue.addOperation(operation)
            return
        }
    }
    
    private func createIntermediateOperation(integerSlotIndex: Int) -> BlockOperation {
        
        var operationContent: (() -> (Void))!
        
        switch integerSlotIndex {
        case 0:
            operationContent = { [weak self] in
                if let firstDigit = self?.firstSlotDigitA,
                   let secondDigit = self?.firstSlotDigitB,
                   let thirdDigit = self?.firstSlotDigitC {
                    self?.firstIntegerSlotData = IntegerSlotData.init(firstDigit: firstDigit, secondDigit: secondDigit, thirdDigit: thirdDigit)
                }
            }
        case 1:
            operationContent = { [weak self] in
                if let firstDigit = self?.secondSlotDigitA,
                   let secondDigit = self?.secondSlotDigitB,
                   let thirdDigit = self?.secondSlotDigitC {
                    self?.secondIntegerSlotData = IntegerSlotData.init(firstDigit: firstDigit, secondDigit: secondDigit, thirdDigit: thirdDigit)
                }
            }
            
        default:
            break
        }
        
        let operation = BlockOperation.init(block: operationContent)
        cancelIntermediate(integerSlotIndex: integerSlotIndex)
        
        switch integerSlotIndex {
        case 0: firstIntegerSlotOperation = operation
        case 1: secondIntegerSlotOperation = operation
        default:
            break
        }
        
        return operation
    }
    
    private func createOperation(digitSlotIndex: Int) -> DigitGenerationOperation {
        
        
        var iterator: ((CGFloat) -> Void)?
        var completion: ((Int) -> Void)?
        
        switch digitSlotIndex {
        case 0:
            iterator = { [weak self] progress in
                self?.firstSlotDigitAProcess = progress
            }
            completion = { [weak self] result in
                self?.firstSlotDigitA = result
            }
        case 1:
            iterator = { [weak self] progress in
                self?.firstSlotDigitBProcess = progress
            }
            completion = { [weak self] result in
                self?.firstSlotDigitB = result
            }
        case 2:
            iterator = { [weak self] progress in
                self?.firstSlotDigitCProcess = progress
            }
            completion = { [weak self] result in
                self?.firstSlotDigitC = result
            }
        case 3:
            iterator = { [weak self] progress in
                self?.secondSlotDigitAProcess = progress
            }
            completion = { [weak self] result in
                self?.secondSlotDigitA = result
            }
        case 4:
            iterator = { [weak self] progress in
                self?.secondSlotDigitBProcess = progress
            }
            completion = { [weak self] result in
                self?.secondSlotDigitB = result
            }
        case 5:
            iterator = { [weak self] progress in
                self?.secondSlotDigitCProcess = progress
            }
            completion = { [weak self] result in
                self?.secondSlotDigitC = result
            }
        default:
            break
        }
        
        let operation = DigitGenerationOperation.init(iterationForProgress: iterator, completion: completion)
        
        cancel(digitSlotIndex: digitSlotIndex)
        
        switch digitSlotIndex {
        case 0: operationA = operation
        case 1: operationB = operation
        case 2: operationC = operation
        case 3: operationD = operation
        case 4: operationE = operation
        case 5: operationF = operation
        default:
            break
        }
        
        return operation
    }
    
    private func cancel(digitSlotIndex: Int) {
        
        // cancel ongoing process if it is
        switch digitSlotIndex {
        case 0:
            firstSlotDigitAProcess = 0
            firstSlotDigitA = 0
            operationA?.cancel()
        case 1:
            firstSlotDigitBProcess = 0
            firstSlotDigitB = 0
            operationB?.cancel()
        case 2:
            firstSlotDigitCProcess = 0
            firstSlotDigitC = 0
            operationC?.cancel()
        case 3:
            secondSlotDigitAProcess = 0
            secondSlotDigitA = 0
            operationD?.cancel()
        case 4:
            secondSlotDigitBProcess = 0
            secondSlotDigitB = 0
            operationE?.cancel()
        case 5:
            secondSlotDigitCProcess = 0
            secondSlotDigitC = 0
            operationF?.cancel()
            
        default:
            break
        }
    }
    
    private func cancelIntermediate(integerSlotIndex: Int) {
        switch integerSlotIndex {
        case 0:
            firstIntegerSlotOperation?.cancel()
            firstIntegerSlotData = nil
        case 1:
            secondIntegerSlotOperation?.cancel()
            secondIntegerSlotData = nil
        default:
            break
        }
    }
    
    private func cancelAllSecondSlots() {
        for i in 3..<6 {
            cancel(digitSlotIndex: i)
        }
        
        cancelIntermediate(integerSlotIndex: 1)
    }
}

