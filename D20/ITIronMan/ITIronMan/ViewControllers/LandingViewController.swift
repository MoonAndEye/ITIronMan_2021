//
//  LandingViewController.swift
//  ITIronMan
//
//  Created by Marvin on 2021/9/3.
//

import UIKit

class LandingViewController: UIViewController {
    
    private lazy var alamofireAdapter: AlamofireAdapter = {
        return AlamofireAdapter()
    }()
    
    private lazy var stockInfoManager: StockInfoManager = {
        return StockInfoManager()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction
    @IBAction func getTwStockCodeAndNameButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func getOTCStockCodeAndNameButtonDidTap(_ sender: Any) {
        
    }
    
    @IBAction func pushRequestBasicInfoVC(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "RequestBasicInfo", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "RequestBasicInfoViewController") as? RequestBasicInfoViewController {
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func pushStockSubscriptionButtonDidTap(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "StockSubscription", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "StockSubscriptionViewController") as? StockSubscriptionViewController {
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func pushTwStockMarketKLineDidTap(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "TwStockMarketKLine", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "TwStockMarketKLineViewController") as? TwStockMarketKLineViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
