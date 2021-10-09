//
//  MajorInvestorsViewController.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/16.
//

import UIKit

class MajorInvestorsViewController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    
    private lazy var model: MajorInvestorsModel = {
        let model = MajorInvestorsModel()
        model.delegate = self
        return model
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    @IBAction func requestMajorInvestorsButtonDidTap(_ sender: Any) {
        model.requestMajorInvestorsAndTwMarket()
    }
    
    @IBAction func pushToThreeMajorInvestorButtonDidTap(_ sender: Any) {
        guard let storyboard = self.storyboard,
              let vc = storyboard.instantiateViewController(withIdentifier: "MajorInvestorsDashboardViewController") as? MajorInvestorsDashboardViewController else {
            return
        }
        
        vc.dailyTradingInfo = model.dailyTradingInfo
        vc.majorInvestors = model.majorInvestors
        vc.date = model.getDate()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MajorInvestorsViewController: MajorInvestorsModelDelegate {
    
    func didRecieve(investors: [MajorInvestor], error: Error?) {
        
        if let error = error {
            print("you got error during fetch investor info: \(error.localizedDescription)")
            return
        }
        
        print("major investors: \(investors)")
        stateLabel.text = "\(investors)"
    }
    
    func didRecieve(dailyTradingInfo: [TwMarketTradingInfo], error: Error?) {
        
        if let error = error {
            print("you got error during fetch daily trading: \(error.localizedDescription)")
            return
        }
        
        print("daily trading info: \(dailyTradingInfo)")
    }
}
