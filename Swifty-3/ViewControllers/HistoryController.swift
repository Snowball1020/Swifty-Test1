//
//  HistoryController.swift
//  Swifty-3
//
//  Created by Yuki Miyazawa on 2020-07-11.
//  Copyright © 2020 Yuki Miyazawa. All rights reserved.
//

import UIKit

//HistoryController class is to show user search history
class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //This array is for storing user search history (data will be passed from mapView)
    var finalHistory:[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //display as many row as the data exists
        return finalHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = finalHistory[indexPath.row]
//        print(cell.textLabel?.text)
        return(cell)
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
