//
//  SPEAvatarPresetTableViewController.swift
//  FaceKit
//
//  Created by Daniel on 2016/3/31.
//  Copyright © 2016年 Speed 3D Inc. All rights reserved.
//

import UIKit
import FaceKit

class SPEAvatarPresetTableViewController: UITableViewController {

    var avatarPresetType: FKAvatarPreset.Type?
    var gender = FKGender.Male
    var selectPresetClosure: ((FKAvatarPreset) -> Void)?
    
    var avatarPresets: [FKAvatarPreset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadAvatarPresetData()
        
        self.clearsSelectionOnViewWillAppear = true
    }

    func loadAvatarPresetData() {
        if avatarPresetType is FKHair.Type {
            self.avatarPresets = FKHair.getNumberList(self.gender)
        }
        else if avatarPresetType is FKSuit.Type {
            self.avatarPresets = FKSuit.getNumberList(self.gender)
        }
        else if avatarPresetType is FKAvatarMotion.Type {
            self.avatarPresets = FKAvatarMotion.getNumberList(self.gender)
        }
        else if avatarPresetType is FKGlasses.Type {
            self.avatarPresets = FKGlasses.getNumberList(self.gender)
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
        return self.avatarPresets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("avatarPresetCell", forIndexPath: indexPath)

        cell.textLabel?.text = self.avatarPresets[indexPath.row].name
        cell.imageView?.image = self.avatarPresets[indexPath.row].previewImage

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectPresetClosure?(self.avatarPresets[indexPath.row])
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
