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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("avatarPresetCell", forIndexPath: indexPath)

        

        return cell
    }
    
}
