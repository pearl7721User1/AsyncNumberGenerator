//
//  File.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/02/08.
//

import Foundation

class DigitGenerationOperation: Operation {
    
    private var iterationForProgress:((_ progress: CGFloat) -> Void)?
    private var completion:((_ digit: Int) -> Void)?
    
    private let queue = DispatchQueue(label: "queue")

    
    init(iterationForProgress: ((_: CGFloat) -> Void)? = nil, completion: ((_: Int) -> Void)? = nil) {
        self.iterationForProgress = iterationForProgress
        self.completion = completion
    }
    
    // MARK: - KVO properties
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    override func start() {
        
        if isCancelled {
            executing(false)
            finish(true)
            return
        }
        
        executing(true)
        
        randomNum(iterator: iterationForProgress, completion: { [weak self] value in
            guard let self = self else { return }
            self.completion?(value)
            
            // upon completion,
            self.executing(false)
            self.finish(true)
        })
        
    }
    
    private func randomNum(iterator: ((_ progress: CGFloat) -> (Void))?, completion:((_ value: Int) -> (Void))?) {
        
        let delay: Double = Double(Int.random(in: 1...7)) / 100.0
        var progress: CGFloat = 0
        
        print(delay)
        
        queue.async {
            for _ in 0..<100 {
                
                if self.isCancelled {
                    iterator?(0)
                    self.executing(false)
                    self.finish(true)
                    return
                }
                
                Thread.sleep(forTimeInterval: TimeInterval(delay))
                
                progress += 0.01
                iterator?(progress)
                print("\(progress)")

            }
            
            // generate one digit randomly
            completion?(Int.random(in: 1...9))
        }
        
    }
}
