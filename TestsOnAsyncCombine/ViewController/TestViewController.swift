//
//  ViewController.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/01/26.
//

import UIKit
import Combine

class TestViewController: UIViewController {
    
    var numGenerator: NumberGenerator!
    
    @IBOutlet weak var taskProgressViewA: TaskProgressView!
    @IBOutlet weak var taskProgressViewB: TaskProgressView!
    @IBOutlet weak var taskProgressViewC: TaskProgressView!
    @IBOutlet weak var firstSlotView: IntegerSlotView!
    
    @IBOutlet weak var taskProgressViewD: TaskProgressView!
    @IBOutlet weak var taskProgressViewE: TaskProgressView!
    @IBOutlet weak var taskProgressViewF: TaskProgressView!
    @IBOutlet weak var secondSlotView: IntegerSlotView!
    
    @IBOutlet weak var sumLabel: UILabel!
    
    @IBOutlet weak var resetButtonA: UIButton!
    @IBOutlet weak var resetButtonB: UIButton!
    @IBOutlet weak var resetButtonC: UIButton!
    @IBOutlet weak var resetButtonD: UIButton!
    @IBOutlet weak var resetButtonE: UIButton!
    @IBOutlet weak var resetButtonF: UIButton!
    
    @IBOutlet weak var theNavigationItem: UINavigationItem!
    
    private var subscriptions = Set<AnyCancellable>()
    
    
    private var allResetButtons: [UIButton] {
        return [resetButtonA, resetButtonB, resetButtonC, resetButtonD, resetButtonE, resetButtonF]
    }
    private var allProgressViews: [TaskProgressView] {
        return [taskProgressViewA, taskProgressViewB, taskProgressViewC, taskProgressViewD, taskProgressViewE, taskProgressViewF]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if numGenerator is NumberGeneratorWithOperation {
            theNavigationItem.title = "Operation"
        } else {
            theNavigationItem.title = "Publisher"
        }
        
        numGenerator.$firstSlotDigitAProcess.receive(on: DispatchQueue.main).sink { [weak self] progress in
            self?.allProgressViews[0].updateProgress(to: progress)
            self?.allResetButtons[0].isHidden = progress >= 1.0 ? false : true
        }.store(in: &subscriptions)
        
        numGenerator.$firstSlotDigitBProcess.receive(on: DispatchQueue.main).sink { [weak self] progress in
            self?.allProgressViews[1].updateProgress(to: progress)
            self?.allResetButtons[1].isHidden = progress >= 1.0 ? false : true
        }.store(in: &subscriptions)
        
        numGenerator.$firstSlotDigitCProcess.receive(on: DispatchQueue.main).sink { [weak self] progress in
            self?.allProgressViews[2].updateProgress(to: progress)
            self?.allResetButtons[2].isHidden = progress >= 1.0 ? false : true
        }.store(in: &subscriptions)
        
        numGenerator.$secondSlotDigitAProcess.receive(on: DispatchQueue.main).sink { [weak self] progress in
            self?.allProgressViews[3].updateProgress(to: progress)
            self?.allResetButtons[3].isHidden = progress >= 1.0 ? false : true
        }.store(in: &subscriptions)
        
        numGenerator.$secondSlotDigitBProcess.receive(on: DispatchQueue.main).sink { [weak self] progress in
            self?.allProgressViews[4].updateProgress(to: progress)
            self?.allResetButtons[4].isHidden = progress >= 1.0 ? false : true
        }.store(in: &subscriptions)
        
        numGenerator.$secondSlotDigitCProcess.receive(on: DispatchQueue.main).sink { [weak self] progress in
            self?.allProgressViews[5].updateProgress(to: progress)
            self?.allResetButtons[5].isHidden = progress >= 1.0 ? false : true
        }.store(in: &subscriptions)
        
        let firstSlotPub = numGenerator.$firstIntegerSlotData.share()
        firstSlotPub.receive(on: DispatchQueue.main).sink { [weak self] slotData in
            guard let self = self else { return }
            
            // update first slot view
            if let slotData = slotData {
                self.firstSlotView.input(array: slotData.array)
            } else {
                self.firstSlotView.reset()
            }
            
        }.store(in: &subscriptions)
        
        firstSlotPub.combineLatest(numGenerator.$secondIntegerSlotData).receive(on: DispatchQueue.main).sink { [weak self] slotDataTuple in
            guard let self = self else { return }
            
            // update second slot view
            if let slotData = slotDataTuple.1 {
                self.secondSlotView.input(array: slotData.array)
            } else {
                self.secondSlotView.reset()
            }
            
            // update sum slot view
            if let firstSlotData = slotDataTuple.0,
               let secondSlotData = slotDataTuple.1 {
                
                let sum = firstSlotData.integer + secondSlotData.integer
                
                self.sumLabel.text = "\(sum)"
                
            } else {
                self.sumLabel.text = ""
            }
            
        }.store(in: &subscriptions)
        
        
        
        /*
        numGenerator.$secondIntegerSlotData.receive(on: DispatchQueue.main).sink { [weak self] slotData in
            guard let self = self else { return }
            
            self.secondSlotView.firstDigit = slotData?.firstDigit
            self.secondSlotView.secondDigit = slotData?.secondDigit
            self.secondSlotView.thirdDigit = slotData?.thirdDigit
            
            
        }.store(in: &subscriptions)
        
        
        numGenerator.$firstIntegerSlotData.zip(numGenerator.$secondIntegerSlotData).receive(on: DispatchQueue.main).sink { [weak self] slotDataTuple in
            guard let self = self,
                  let firstSlotData = slotDataTuple.0,
                  let secondSlotData = slotDataTuple.1 else { return }
            
            let sum = firstSlotData.integer + secondSlotData.integer
            let newSlotData = IntegerSlotData.init(sum: sum)
            
            self.sumSlotView.firstDigit = newSlotData.firstDigit
            self.sumSlotView.secondDigit = newSlotData.secondDigit
            self.sumSlotView.thirdDigit = newSlotData.thirdDigit
            
        }.store(in: &subscriptions)
         */
    }

    override func viewDidAppear(_ animated: Bool) {
        numGenerator.startGeneratingNumbers()
    }

    deinit {
        print("deinit")
        numGenerator.cancelTasks()
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        numGenerator.resetDigit(index: sender.tag)
    }
}


extension TestViewController {
    static func newInstance() -> TestViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String.init(describing: self)) as! TestViewController
        
        return vc
    }
}
