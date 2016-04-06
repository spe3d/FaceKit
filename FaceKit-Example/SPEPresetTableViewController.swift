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

    var presetType: FKPreset.Type?
    var gender = FKGender.Male
    var selectPresetClosure: ((FKPreset) -> Void)?
    
    var presets: [FKPreset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadPresetData()
        
        self.clearsSelectionOnViewWillAppear = true
    }

    func loadPresetData() {
        if presetType is FKHair.Type {
            self.presets = FKHair.getNumberList(self.gender)
        }
        else if presetType is FKSuit.Type {
            self.presets = FKSuit.getNumberList(self.gender)
        }
        else if presetType is FKMotion.Type {
            self.presets = FKMotion.getNumberList(self.gender)
        }
        else if presetType is FKGlasses.Type {
            self.presets = FKGlasses.getNumberList(self.gender)
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - action
    
    @IBAction func closeAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("presetCell", forIndexPath: indexPath)

        cell.textLabel?.text = self.presets[indexPath.row].name
        cell.imageView?.image = self.presets[indexPath.row].previewImage

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectPresetClosure?(self.presets[indexPath.row])
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
