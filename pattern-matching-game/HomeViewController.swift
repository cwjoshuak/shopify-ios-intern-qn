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
    

    // MARK:- IBOutlets
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- Variables
    var items: Items!
    var textures: [SKTexture]!
    var assets = [String:[UIImage]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "OptionTableViewCell", bundle: nil), forCellReuseIdentifier: "optionCell")
        tableView.allowsSelection = false
        NotificationCenter.default.addObserver(self, selector: #selector(rowChanged(notification:)), name: NSNotification.Name("rowChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(colChanged(notification:)), name: NSNotification.Name("colChanged"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(patternMatchesChanged(notification:)), name: NSNotification.Name("patternMatchesChanged"), object: nil)


    }
    
    // MARK:- UITableView Data Methods
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
            cell.counterLabel.text = "4"
            cell.stepper.value = 4
            cell.stepper.minimumValue = 4
            cell.stepper.maximumValue = 8
            cell.stepper.tag = 0
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
            cell.titleLabel.text = "Grid Columns"
            cell.counterLabel.text = "3"
            cell.stepper.value = 3
            cell.stepper.minimumValue = 3
            cell.stepper.maximumValue = 8
            cell.stepper.tag = 1
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
            cell.titleLabel.text = "Pattern Matches"
            cell.counterLabel.text = "2"
            cell.stepper.value = 2
            cell.stepper.minimumValue = 2
            cell.stepper.maximumValue = 4
            cell.stepper.tag = 2
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! OptionTableViewCell
            cell.titleLabel.text = "Image Variety"
            cell.counterLabel.text = "35"
            cell.stepper.value = 35
            cell.stepper.minimumValue = 10
            cell.stepper.maximumValue = 50
            cell.stepper.tag = 3
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "optionCell")!
        }
    }
    
    // MARK:- IBActions
    @IBAction func startGame(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        assets = [String:[UIImage]]()
        Utility.getItems(page: nil, progressView: progressView) { (success, items, error) in
            if success, let items = items {
                self.items = items
            }
            let progress = Progress(totalUnitCount: 100)
            self.progressView.observedProgress = progress
            
            DispatchQueue.main.async {
                let (_, _, _, totalImgs) = self.getSettings()
                let selectedItems = self.items.products.shuffled()[0..<totalImgs]
                let urls = selectedItems.map { (product) -> URL in
                    URL(string: product.image.src)!
                }
                urls.forEach { (url) in
                    print(url)
                    let task = Utility.getAssets(from: url) { (success, image, error) in
                        if success, let image = image {
                            print("appending image")
                            self.assets[url.absoluteString, default:[]].append(image)
                            let count = self.assets.reduce(into: 0) { (sum, args) in
                                sum += args.value.count
                            }
                            print("imgCount: \(count), totalImgs: \(totalImgs)")
                            if count == totalImgs {
                                DispatchQueue.main.sync {
                                    sender.isUserInteractionEnabled = true
                                    
                                    self.performSegue(withIdentifier: "startGameSegue", sender: self)
                                    self.progressView.setProgress(0.0, animated: false)
                                }
                            }
                        }
                    }
                    progress.addChild(task.progress, withPendingUnitCount: Int64(100/urls.count))
                    task.resume()
                }                
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
            let (rows, cols, patternMatches, _) = self.getSettings()
            let textures = self.assets.mapValues { (images) -> [SKTexture] in
                images.map { SKTexture(image: $0) }
            }
            dest.rows = rows
            dest.cols = cols
            dest.patternMatches = patternMatches
            dest.textures = textures
        }
    }
    
    // MARK:- Utility
    
    // If grid cannot fit row * col % patternMatches, resize row/col/matches accordingly
    @objc func rowChanged(notification: NSNotification) {
        if let cell = notification.object as? OptionTableViewCell {
            let (oldRow, col, patternMatches, _) = getSettings()
            let row = Int(cell.stepper.value)
            
            if (row * col) % patternMatches != 0 {
                let value = row - oldRow
                cell.stepper.value += Double(value)
            }
            cell.counterLabel.text = Int(cell.stepper.value).description
        }
    }
    
    @objc func colChanged(notification: NSNotification) {
        if let cell = notification.object as? OptionTableViewCell {
            let (row, oldCol, patternMatches, _) = getSettings()
            let col = Int(cell.stepper.value)
            
            if (row * col) % patternMatches != 0 {
                let value = col - oldCol
                cell.stepper.value += Double(value)
            }
            cell.counterLabel.text = Int(cell.stepper.value).description
        }
    }
    
    @objc func patternMatchesChanged(notification: NSNotification) {
        if let cell = notification.object as? OptionTableViewCell {
            let (row, col, oldPatternMatches, _) = getSettings()
            let patternMatches = Int(cell.stepper.value)
            
            if (row * col) % patternMatches != 0 {
                let value = patternMatches - oldPatternMatches
                cell.stepper.value += Double(value)
            }
            cell.counterLabel.text = Int(cell.stepper.value).description
        }
    }
    
    // Returns settings (row, col, patternMatches, imageVariety)
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
