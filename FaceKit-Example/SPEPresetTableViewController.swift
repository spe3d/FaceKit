//
//  SPEPresetTableViewController.swift
//  FaceKit
//
//  Created by Daniel on 2016/3/31.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

import UIKit
import FaceKit

class SPEPresetTableViewController: UITableViewController {

    var presetType: FACPresetType?
    var gender = FACGender.male
    var selectPresetClosure: ((FACPreset) -> Void)?
    
    var presets: [FACPreset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadPresetData()
        
        self.clearsSelectionOnViewWillAppear = true
    }

    func loadPresetData() {
        guard let presetType = self.presetType else {
            return
        }
        
        self.presets = FACPreset.getPresetsFor(presetType, gender: self.gender)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - action
    
    @IBAction func closeAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetCell", for: indexPath)

        cell.textLabel?.text = self.presets[(indexPath as NSIndexPath).row].name
        
        self.presets[(indexPath as NSIndexPath).row].observePreviewImage({ (preset, image) in
            if cell.imageView?.image != image {
                cell.imageView?.image = image
                
                if self.tableView == tableView {
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        })

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectPresetClosure?(self.presets[(indexPath as NSIndexPath).row])
        
        self.dismiss(animated: true, completion: nil)
    }
}
