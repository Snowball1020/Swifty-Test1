//
//  HistoryController.swift
//  Swifty-3
//
//  Created by Yuki Miyazawa on 2020-07-11.
//  Copyright © 2020 Yuki Miyazawa. All rights reserved.
//

import UIKit

//Remote Git Push Testing

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var finalHistory:[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return finalHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = finalHistory[indexPath.row]

        print(cell.textLabel?.text)
        return(cell)
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
