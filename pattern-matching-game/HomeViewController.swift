//
//  HomeViewController.swift
//  pattern-matching-game
//
//  Created by Joshua Kuan on 9/11/19.
//  Copyright © 2019 Joshua Kuan. All rights reserved.
//

import UIKit
import SpriteKit
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    var items: Items!
    var textures: [SKTexture]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "OptionTableViewCell", bundle: nil), forCellReuseIdentifier: "optionCell")
        tableView.allowsSelection = false
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Settings"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
            cell.titleLabel.text = "Grid Rows"
            cell.counterLabel.text = "7"
            cell.stepper.value = 7
            cell.stepper.minimumValue = 7
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
            cell.titleLabel.text = "Grid Columns"
            cell.counterLabel.text = "5"
            cell.stepper.value = 5
            cell.stepper.minimumValue = 5
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
            cell.titleLabel.text = "Pattern Matches"
            cell.counterLabel.text = "2"
            cell.stepper.value = 2
            cell.stepper.minimumValue = 2
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
            cell.titleLabel.text = "Total Images"
            cell.counterLabel.text = "10"
            cell.stepper.value = 10
            cell.stepper.minimumValue = 10
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "optionCell")!
        }
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        Utility.getAssets(page: nil, progressView: progressView) { (success, items, error) in
            if success, let items = items {
                self.items = items
            }
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = true
                self.performSegue(withIdentifier: "startGameSegue", sender: self)
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "startGameSegue", let dest = segue.destination as? GameViewController {
            dest.items = self.items
            let (rows, cols, patternMatches, totalImgs) = getSettings()
            let textures = items.products.shuffled()[0..<totalImgs].map { (product) -> SKTexture in
                Utility.getData(from: URL(string: product.image.src)!) { (<#Data?#>, <#URLResponse?#>, <#Error?#>) in
                    <#code#>
                }
                
                
            }
            dest.scene = GameScene(size: dest.gameView.frame.size, rows: rows, cols: cols, matchedPatterns: patternMatches, textures: self.textures)
        }
    }
    
    func getSettings() -> (Int, Int, Int, Int) {
        let rowCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! OptionTableViewCell
        let colCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! OptionTableViewCell
        let patternMatchCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as! OptionTableViewCell
        let totalImgCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0)) as! OptionTableViewCell
        
        let rows = Int(rowCell.counterLabel.text!)!
        let cols = Int(colCell.counterLabel.text!)!
        let patternMatches = Int(patternMatchCell.counterLabel.text!)!
        let totalImgs = Int(totalImgCell.counterLabel.text!)!
        
        return (rows, cols, patternMatches, totalImgs)
    }

}
