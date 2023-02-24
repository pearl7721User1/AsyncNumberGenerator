//
//  NumberGeneratorWithPublisher.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/02/07.
//

import UIKit
import Combine

class NumberGeneratorWithPublisher: NumberGenerator {

    // intermediate values
    @Published private var firstSlotDigitA: Int? = nil
    @Published private var firstSlotDigitB: Int? = nil
    @Published private var firstSlotDigitC: Int? = nil
    
    @Published private var secondSlotDigitA: Int? = nil
    @Published private var secondSlotDigitB: Int? = nil
    @Published private var secondSlotDigitC: Int? = nil
    
    private var firstSlotDigitACancellable: AnyCancellable?
    private var firstSlotDigitBCancellable: AnyCancellable?
    private var firstSlotDigitCCancellable: AnyCancellable?
    
    private var secondSlotDigitACancellable: AnyCancellable?
    private var secondSlotDigitBCancellable: AnyCancellable?
    private var secondSlotDigitCCancellable: AnyCancellable?
    
    private var otherTasks = Set<AnyCancellable>()
    
    private let queue = DispatchQueue.init(label: "myQueue")
    
    override init() {
        
        super.init()
        
        $firstSlotDigitA.combineLatest($firstSlotDigitB, $firstSlotDigitC)
            .receive(on: queue)
            .map { digitsMaybe in
                if let firstDigit = digitsMaybe.0,
                        let secondDigit = digitsMaybe.1,
                        let thirdDigit = digitsMaybe.2 {
                    let newInstance: IntegerSlotData? = IntegerSlotData.init(firstDigit: firstDigit, secondDigit: secondDigit, thirdDigit: thirdDigit)
                    
                    print("newInstances")
                    return newInstance
                } else {
                    return nil
                }
            }
            .assign(to: \.firstIntegerSlotData, on: self)
            .store(in: &otherTasks)

        $firstIntegerSlotData.receive(on: queue).sink { slotData in
            
            if slotData != nil {
                print("startGenerateNumbersForSecondSlot")
                self.startGenerateNumbersForSecondSlot()
                
            } else {
                // cancel all second slots
                self.cancelAllSecondSlots()
            }
            
        }.store(in: &otherTasks)
        
        $secondSlotDigitA.combineLatest($secondSlotDigitB, $secondSlotDigitC)
            .receive(on: queue)
            .map{ digitsMaybe in
                if let firstDigit = digitsMaybe.0,
                        let secondDigit = digitsMaybe.1,
                        let thirdDigit = digitsMaybe.2 {
                    let newInstance: IntegerSlotData? = IntegerSlotData.init(firstDigit: firstDigit, secondDigit: secondDigit, thirdDigit: thirdDigit)
                    return newInstance
                } else {
                    return nil
                }
            }
            .assign(to: \.secondIntegerSlotData, on: self)
            .store(in: &otherTasks)
        
    }
    
    override func cancelTasks() {
        otherTasks.removeAll()
    }
    
    override func startGeneratingNumbers() {
        startGenerateNumbersForFirstSlot()
    }
    
    override func resetDigit(index: Int) {
        generateNumber(slotIndex: index)
    }
    
    private func startGenerateNumbersForFirstSlot() {
        for i in 0..<3 {
            generateNumber(slotIndex: i)
        }
    }
    
    private func startGenerateNumbersForSecondSlot() {
        
        for i in 3..<6 {
            generateNumber(slotIndex: i)
        }
    }
    
    private func cancelAllSecondSlots() {
        for i in 3..<6 {
            cancel(slotIndex: i)
        }
    }
    
    private func cancel(slotIndex: Int) {
        // cancel ongoing process if it is
        switch slotIndex {
        case 0:
            firstSlotDigitACancellable?.cancel()
            firstSlotDigitA = nil
            firstSlotDigitAProcess = 0
        case 1:
            firstSlotDigitBCancellable?.cancel()
            firstSlotDigitB = nil
            firstSlotDigitBProcess = 0
        case 2:
            firstSlotDigitCCancellable?.cancel()
            firstSlotDigitC = nil
            firstSlotDigitCProcess = 0
        case 3:
            secondSlotDigitACancellable?.cancel()
            secondSlotDigitA = nil
            secondSlotDigitAProcess = 0
        case 4:
            secondSlotDigitBCancellable?.cancel()
            secondSlotDigitB = nil
            secondSlotDigitBProcess = 0
        case 5:
            secondSlotDigitCCancellable?.cancel()
            secondSlotDigitC = nil
            secondSlotDigitCProcess = 0
        default:
            break
        }
        
    }
    
    private func generateNumber(slotIndex: Int) {
        
        // cancel
        cancel(slotIndex: slotIndex)
        
        let cancellable = Publishers.DigitGenerationPublisher().receive(on: queue).sink { completion in
            
        } receiveValue: { [weak self] (value: (CGFloat, Int?)) in
            
            switch slotIndex {
            case 0:
                self?.firstSlotDigitAProcess = value.0
            case 1:
                self?.firstSlotDigitBProcess = value.0
            case 2:
                self?.firstSlotDigitCProcess = value.0
            case 3:
                self?.secondSlotDigitAProcess = value.0
            case 4:
                self?.secondSlotDigitBProcess = value.0
            case 5:
                self?.secondSlotDigitCProcess = value.0
            default:
                break
            }
            
            if let resultedInt = value.1 {
                
//                print("finished:\(slotIndex)")
                
                switch slotIndex {
                case 0:
                    self?.firstSlotDigitA = resultedInt
                case 1:
                    self?.firstSlotDigitB = resultedInt
                case 2:
                    self?.firstSlotDigitC = resultedInt
                case 3:
                    self?.secondSlotDigitA = resultedInt
                case 4:
                    self?.secondSlotDigitB = resultedInt
                case 5:
                    self?.secondSlotDigitC = resultedInt
                default:
                    break
                }
            }
        }
        
        // assign each cancellable
        switch slotIndex {
        case 0:
            firstSlotDigitACancellable = cancellable
            
        case 1:
            firstSlotDigitBCancellable = cancellable
        
        case 2:
            firstSlotDigitCCancellable = cancellable
            
        case 3:
            secondSlotDigitACancellable = cancellable
            
        case 4:
            secondSlotDigitBCancellable = cancellable
            
        case 5:
            secondSlotDigitCCancellable = cancellable
            
        default:
            break
        }
    }
}
