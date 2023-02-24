//
//  NumberGeneratorWorker.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/01/26.
//

import UIKit
import Combine

extension Publishers {
    
    struct DigitGenerationPublisher: Publisher {
        
        typealias Output = (CGFloat, Int?)
        typealias Failure = Never
        
        func receive<S: Subscriber>(subscriber: S) where
        DigitGenerationPublisher.Failure == S.Failure, DigitGenerationPublisher.Output == S.Input {
                
            let subscription = NumberGeneratorSubscription.init(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
            subscription.startGenerating()
            
        }
    }
    
    class NumberGeneratorSubscription<S: Subscriber>: Subscription where S.Input == (CGFloat, Int?), S.Failure == Never {
        
        private var subscriber: S?
        private var source: DispatchSourceTimer?
        private let queue = DispatchQueue(label: "queue")
        
        init(subscriber: S) {
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            
        }
        
        func cancel() {
            self.source = nil
            subscriber = nil
        }
        
        func startGenerating() {
            
            self.source = DispatchSource.makeTimerSource(queue: queue)
            
            let delay: Double = Double(Int.random(in: 1...7)) / 100.0
            var progress: CGFloat = 0
            
            self.source?.schedule(deadline: .now() + delay,
                            repeating: delay,
                            leeway: .nanoseconds(0))
            
            self.source?.setEventHandler { [weak self] in
            
                guard let self = self else {
                    return
                }

                if self.subscriber == nil {
                    self.source?.cancel()
                    return
                }
                
                print(progress)
                
                progress += 0.01
                self.subscriber?.receive((progress, nil))
                

                if progress >= 1.0 {
                    // generate one digit randomly
                    print("ended")
                    self.subscriber?.receive((1.0, Int.random(in: 1...9)))
                    self.subscriber?.receive(completion: .finished)
                }
            }

            self.source?.activate()
        }
        
    }
}

