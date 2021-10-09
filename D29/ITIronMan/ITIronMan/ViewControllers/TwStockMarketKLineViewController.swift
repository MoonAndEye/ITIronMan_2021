//
//  TwStockMarketKLineViewController.swift
//  ITIronMan
//
//  Created by cm0679 on 2021/9/7.
//

import UIKit

class TwStockMarketKLineViewController: UIViewController {
    
    @IBOutlet weak var debugTextView: UITextView!
    
    private lazy var model: TwStockMarketKLineModel = {
        let model = TwStockMarketKLineModel()
        model.delegate = self
        return model
    }()

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    @IBAction func fetchTwStockKLineButtonDidTap(_ sender: Any) {
        model.requestTwExKLineAndVolumeInfo()
    }
    
    @IBAction func dubugButtonDidTap(_ sender: Any) {
        
        var string = ""
        
        for kLine in model.twExStockDataSet {
            
            string += "\(kLine)\n"
        }
        
        debugTextView.text = string
    }
    
    @IBAction func pushKLineButtonDidTap(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "KLine", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "KLineViewController") as? KLineViewController {
            
            vc.kLineDataSet = model.twExStockDataSet
            vc.volumeDataSet = model.twExVolumeDataSet
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension TwStockMarketKLineViewController: TwStockMarketKLineModelDelegate {
    
    func didRecieveVolume(volumeDataSet: [TwMarketTradingInfo], error: Error?) {
        print(model.twExVolumeDataSet)
    }
    
    func didRecieveTaiEx(kLineDataSet: [StockKLine], error: Error?) {
        
        print(model.twExStockDataSet)
    }
}
