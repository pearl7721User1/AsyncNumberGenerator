//
//  MenuTableViewController.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/02/08.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = TestViewController.newInstance()
        
        if indexPath.row == 0 {
            vc.numGenerator = NumberGeneratorWithOperation()
        } else if indexPath.row == 1 {
            vc.numGenerator = NumberGeneratorWithCombine()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
