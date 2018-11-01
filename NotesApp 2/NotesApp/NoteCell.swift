//
//  NoteCell.swift
//  NotesApp
//
//  Created by Jacob Levy on 10/23/18.
//  Copyright © 2018 Jacob Levy. All rights reserved.
//
/**
NoteCell.Swift is a file that is being used by UITableView to correctly generate the UITableViewCells.
You do not need to play around in this file



****************DO NOT MODIFY THIS FILE FOR YOUR FINAL SUBMISSION**********


*/


import UIKit

class NoteCell: UITableViewCell {

	@IBOutlet weak var UpButton: UIButton!

	
	@IBOutlet weak var downButton: UIButton!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		UpButton.isEnabled = true
		downButton.isEnabled = true
		UpButton.isHidden = false
		downButton.isHidden = false
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
		UpButton.isEnabled = true
		downButton.isEnabled = true
		UpButton.isHidden = false
		downButton.isHidden = false
        // Configure the view for the selected state
    }
	

}
