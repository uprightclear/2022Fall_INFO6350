//
//  ViewController.swift
//  GetStockPrices
//
//  Created by uprightclear on 12/10/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var temps: [Stock] = [Stock]()
    var indexSelected = 0
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getAllStocks()
        
    }
    
    func getAllStocks() {
        let url = "https://us-central1-whatsapp-analytics-2de0e.cloudfunctions.net/app/allstocks"
        AF.request(url).responseJSON { responseData in

            if responseData.error != nil {
                print(responseData.error!)
                return
            }

            let stockData = JSON(responseData.data as Any)
            self.temps = [Stock]()
            for stock in stockData {
                let ele = Stock()
                let stockJSON = JSON(stock.1)
                print(stockJSON)
                ele.companyName = stockJSON["CompanyName"].stringValue
                ele.symbol = stockJSON["Symbol"].stringValue
                ele.price = stockJSON["Price"].floatValue
                self.temps.append(ele)
            }
            self.tblView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDetails"){
            let destVC = segue.destination as! DetailsViewController
            let selectedStock = temps[indexSelected]
            destVC.symbol = selectedStock.symbol
        }
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(temps[indexPath.row].companyName)(\(temps[indexPath.row].symbol)): \(temps[indexPath.row].price)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexSelected = indexPath.row
        performSegue(withIdentifier: "segueDetails", sender: self)
    }

}
