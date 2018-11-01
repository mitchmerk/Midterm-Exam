//
//  ViewController.swift
//  NotesApp
//
//  Created by Jacob Levy on 10/17/18.
//  Copyright © 2018 Jacob Levy. All rights reserved.
//
/**
# The Notes List App

	This project is based on the Note-Taking App built in the video Series "Building a Note-Taking App for
iOS 11" by Todd Perkins, located at https://www.lynda.com/iOS-tutorials/Building-Note-Taking-App-iOS-11-Swift/642477-2.html
	You may refer back to that video series if you get confused by the iOS framework calls used in this project.
*However* be advised that this project is not about you learning to build iOS projects but is instead
intended for you apply the Swift concepts we have covered in our classes and labs so far. To that end, this
project differs significantly from the final project of that video series.  The Swift logic you will need
to generate for our version of the app is more complex than that of the video series but in so far
as the use of the iOS framework is concerned, this project is much more simplistic. As a result, this App makes the
following assumptions:

	-The User will not need to save list data or user preference data (to persist between sessions)
	-The User will not have a need to make any long, detailed, or complicated notes
	-The User will only need short simple "single task" notes
	-The User will never need to have a more detailed View of individual notes
	-The User will never need to edit a note after it has been created (though they can be deleted)
	-Notes that are entered with commas indicate there are multiple Notes in the field and the app will split the text and
	add/insert each one into the list depending on the button choice
	-This app will never go into production

The sections from the video series most relevant for our purposes are Chapter 4 (the entire chapter) and
the first video of Chapter 5.   You may also want to view Chapter 3 (about 15 mins long) which breaks down
various aspects of working in a real XCode project (as opposed to the playground files).


You only need to modify the ViewController.swift file (the brains).  However for testing and debugging, you are
being provided the following list of files:

- ViewController.swift
*********DO NOT MODIFY THESE FILES*************
- AppDelegate.swift
- Main.storyboard
- NoteCell.swift


Directions:
1) Either at the very top of this file, or in a separate file within this project directory you must create a Type definition
for a Note type. You must make a potentially important design decision.  Should Note be a Struct or a Class?
Does it matter? If you aren't sure, try both and see which works better if either. You and your partner should discuss the '
final decision and include your reasoning for the decision as a comment infront of the Type definition.  Your reasoning should
be relatively sophisticated aka more than just "Thats what worked".  Why did your choice work better?

It must also have the following properties and methods (with the exact names, spelling, and capitalization as shown):

Type Name - Note

Constant Properties
	- priority: Int
	- message: String

Accessor Methods
	- getPriority : returns an Int representing the priority value for a Note instance
	- getMessage : returns a String representing the message for a Note instance


2) Read the comments and look for the "hooks" that have been left for you to fill in code.  They will be block
formatted comments that describe the logic you need to fill in.  Again, you will only be writing pure Swift to
fix this program and will not need to write any iOS calls.

Hook Example:
	/*************************************
	HOOK:
	The Hooks will look like this.
	A block comment with several lines
	describing what you need to do.
	**************************************/


*/

import UIKit




//	If you are familiar with MVC architecture, then this design should look somewhat familiar.
//The viewController orchestrates what is happening in the app "behind the scenes".   It "controls" both the
//Model (in this case our Data Model is the basic array of Notes) and the View and how they communicate.  In
//iOS the View is the file called Main.StoryBoard
//
//The list of items after "ViewController:" is a list of classes that the VC either inherits from or Protocols
//(delegates) that the VC implements.  For now, that is all you need to know about them.

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    class Note{
        let priority: Int = 0
        let message: String = ""
        
        init(self.priority,message){
            self.priority = priority
            self.message = message
        }
        
        func getPriority() -> Int{
            return priority
        }
        
        func getMessage() -> String{
            return message
        }
        
        
    }

	
	//Outlet connected to the pickerView (comboBox), aka the priority Numbers
	@IBOutlet weak var priorityDropDown: UIPickerView!
	
	//Interface outlet connected to the viewable Table on the phone Screen
	@IBOutlet weak var myTable: UITableView!  //implicitly unwrapped optional
	
	@IBOutlet weak var noteTextField: UITextField!
	
	/***************************THE MODEL*****************/
	//Note that our model in this case is very "stupid". Its just an array.
	//this array will hold the items in our notes App
    
	var myTableData: [Note] = []// Create an empty array of Note Values
	
	let prioritiesList = ["1", "2", "3", "4", "5"]

	

	
	
//This is where the main logic and setup code of an iOS app goes.  For this project, you should not modify this method.
	override func viewDidLoad() {
		super.viewDidLoad()
		noteTextField.layer.borderColor = UIColor.black.cgColor
		noteTextField.layer.borderWidth = CGFloat(4.0)
		
		// Do any additional setup after loading the view, typically from a nib.
		myTable.dataSource = self
		myTable.delegate = self
		priorityDropDown.dataSource = self
		priorityDropDown.delegate = self
	
	
		
		//Set up the Title Bar and Buttons
		self.title = "Notes App"
		let clearButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearList))
		let insertButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(insertNote))
		let addButton  = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
		let buttons = [insertButton, addButton, clearButton]
		self.navigationItem.rightBarButtonItems = buttons
		let sortAlphaButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(sortNotesAlpha))
		let sortPrioritiesButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sortNotePriority))
		self.navigationItem.leftBarButtonItems = [editButtonItem, sortAlphaButton, sortPrioritiesButton]
		
		
	
		myTable.reloadData()
	}
	/**
	# didTapDown
	This function is run anytime a User taps one of the down buttons on a TableView cell.
	- PreCondition: The note is at position n in the myTableData array
	- PostCondition: The note is at postion n+1 in the myTableData array
	*/
	@IBAction func didTapDown(_ sender: UIButton) {
		
		
		
		//guard against the current cell being nil
		//try to assign the button source's containing TableView Cell to thisCell constant
		guard let thisCell = sender.superview?.superview as? NoteCell else{
			print("Something weird happened: Down Button")
			return
		}
		/*  Explanation of statement above:
		the guard let statement acts an "optional binding" statement
		it ensures that the assignment of thisCell (current Cell) to the button's container View is not nil, then
		performs a "conditional Type Cast" to treat it as a NoteCell.  If the assignment fails for whatever reason
		the message above is printed to our console and this function returns early.  The effect will be that nothing
		happens.
		*/
		
		//After this line of code you can access the constant thisCell which
		//represents the current Cell we are trying to move down the list
		
		//get this Cell's location  in the View Table
		let indexPath = myTable.indexPath(for: thisCell)
		
		
		//get the value for the current Row in the View Table (corresponds to location in myTableData array
		let currentRow = (indexPath?.row)!
		//we know this cell exists so we can force unwrap the current row because it also must exist
		//(the viewTable rows correspond to the indices in our array)
		
		/*********************
		HOOK: count - 1 let temp mytalbe
		You must write logic here to `guard` that this currentRow value is not already at the BOTTOM of the list (myTableData array).
		If it is at the bottom of the list, print a message indicating this to the console and return early.
		After you have ensured that it is not already at the bottom of the list, switch the currently chosen
		item with the one that immediately follows it in the myTableData array.*/
        
        guard currentRow != (myTableData.count) else{
            print("The currentRow is at the bottom of the list.")
            return
        }
        
        swap(&myTableData[currentRow] , &myTableData[currentRow+1])
        
        /*
         let temp = myTableData[currentRow]
         myTableData[currentRow] = myTableData[currentRow + 1]
         myTableData[currentRow + 1] = temp
         */
         
         
		//+/- 7 lines of code
		//*********************/
	
		///////////////////////////////////////////////
		
		//Reloads the view so that you can see your changes.  DO NOT REMOVE THIS LINE OF CODE
		myTable.reloadData()
	}
	
	
	
	@IBAction func didTapUp(_ sender: UIButton) {
		
		//guarantee that this cell exists
		guard let thisCell = sender.superview?.superview as? NoteCell else {
			print("Something weird happened: Up Button")
			return
		}
		
		let indexPath = myTable.indexPath(for: thisCell)
		let currentRow = (indexPath?.row)!
		
		
		/*********************
		HOOK:
		You must write logic here to `guard` that this currentRow value is not already at the TOP of the list.
		If it is at the top of the list, print a message indicating this to the console and return early.
		After you have ensured that it is not already at the top of the list, switch the currently chosen
		item with the one that immediately precedes it in the myTableData array.
		*/
         
        guard currentRow != 0 else{
            print("The currentRow is at the top of the list.")
            return
        }
        
        swap(&myTableData[currentRow] , &myTableData[currentRow - 1])
        
         
         /*
		+/- 7 lines of code
		*********************/
		
		
		/////////////////////////////////
		
		//Reloads the view so that you can see your changes.  DO NOT REMOVE THIS LINE OF CODE
		
		myTable.reloadData()
	}
	
	/**
	insertNote
	
		This method is called when the user clicks the insert button (the one with a pencil and paper). In turn, this method
	will determine whether or not to call insertMultipleNotes or insertSingleNote. If the text of the note contains commas,
	this method assumes that there are multiple notes in the text field and will insert each one individually (insertMutipleNotes).
	
	
	This method must be exposed to the objective C runtime or it will not run when the user clicks the corresponding button.
	Check the slides and notes from lecture to determine the appropriate tag to use.

	This method should make good use of String method added to this project, to trim the front and back whitespace from
	Strings before handling them.
	+/- 5 Lines of Code
	
	
	- Parameters : none
	- Returns : none
	
	*/
	
	@objc func insertNote(){
	
	
		//After this line of code you can access the constant note as a String
		//We will cover guard let statements later in the semester
		//if the note is empty, the view table is in editing mode, or a priority is not selected, this function will return
		//without adding the note
		
		guard let note = noteTextField.text, goodToGo() else{
			print("Theres nothing to insert in this Note!!!")
			return
		}
	
		
		//YOU FILL IN THIS Part of the METHOD
		//This should insert Notes at the top of the list
		/*************
		HOOK: Trim the note variable, removing front and back whitespace using the provided String method, and assign it to
		a new constant.
		IF the trimmed Note contains commas, call insertMultipleNotes and pass it the trimmed note, otherwise call
		insertSingleNote and pass the trimmed note into that one.
		+/- 6 Lines of code
		******************/
		
		
		//clear the textField
		noteTextField.text! = ""

		return
	}

/**
insertSingleNote

	This method inserts a single note at the TOP of the list of Notes.
	
	
	- Parameters : trimmedNote - A string value that represents the note to be inserted with leading and trailing whitespace removed
	- Returns : none
	
	*/
	
	func insertSingleNote(trimmedNote: String){
		//this line grabs the value of the UIPickerView to use as the Note's priority level
	let priorityLevel = priorityDropDown.selectedRow(inComponent: 0) + 1

	/*************
	HOOK:
	You must guard that the trimmed note is not empty.  AKA we already checked to see if it was nil but we didn't check to see
		if it something silly like all white space before we trimmed it. If the note is empty, return early.
		After the guard, `insert` the note at at Top of the list, aka the beginning of the myTableData array. Use the given
		priorityLevel (above) to create the Note to be inserted
		
		+/- 3 Lines of code
	*************/
		
		

			//DO NOT CHANGE THE FOLLOWING LINEs OF CODE
			myTable.insertRows(at: [setIndexPath(methodName: "insertNote")], with: .automatic)
		
		return
	}
	/**
	insertMultipleNotes
	
	This method inserts multiple notes at the TOP of the list of Notes.
	
	
	- Parameters : trimmedNote - A string value that represents the note to be inserted with leading and trailing whitespace removed
	- Returns : none
	
	*/
	func insertMultipleNotes(trimmedNote: String){
		let priorityLevel = priorityDropDown.selectedRow(inComponent: 0) + 1

		/*************
		HOOK:
		Guard that the trimmed note actually contains one or more commas else return early.
		
		After the guard, split the string into individual items using commas as the basis of the split
	
		Iterate over each item in the returned array.  Make sure that each is not empty after trimming its front and back white
		space. Then a create and insert a new Note into the myTableData array, using the provided priorityLevel and the
		trimmedNote as parameters.
		
		THe *LAST* line of the loop should be the line myTable.insertRows(at:...) method call that is provided below

	

		+/- 10 Lines of code
		*************/
	
				//this should be the last line of the loop
				myTable.insertRows(at: [setIndexPath(methodName: "insertNote")], with: .automatic)

		

	}
	
	/**
	addNote
	
	This method is called when the user clicks the add button (the one with a + ). In turn, this method
	will determine whether or not to call addMultipleNotes or addSingleNote. If the text of the note contains commas,
	this method assumes that there are multiple notes in the text field and will insert each one individually
	(addMutipleNotes).
	
	
	This method must be exposed to the objective C runtime or it will not run when the user clicks the corresponding button.
	Check the slides and notes from lecture to determine the appropriate tag to use.
	
	This method should make good use of String method added to this project, to trim the front and back whitespace from
	Strings before handling them.

	- Parameters : none
	- Returns : none
	
	
	- Pre-Condition:  List is Size n, there is text in the textField, and there are n filled rows on Screen
	- Post-Condition:  If the method call is valid, a new note is added to the data array and shown on screen, size is n+1
	- Purpose: Adds a single Note to the list
	- Notes: Needs exposure to Obj-C runtime to partake in the message dispatch required by Users interacting with the buttons
	
	
	+/- 5 Lines of Code
	
	*/
	@objc func addNote(){

		
		guard let note = noteTextField.text, goodToGo() else{
			print("Theres nothing to insert in this Note!!!")
			return
		}
		//You can now access note from here on as a constant String
		
		
		/****************
		HOOK: Similar to insertNote. Trim the note variable, removing front and back whitespace using the provided String
		method, and assign it to a new constant.
		IF the trimmed Note contains commas, call  addMultipleNotes and pass it the trimmed note, otherwise call
		addSingleNote and pass the trimmed note into that one.
		+/- 6 Lines of code
		
		**********************/
		
		
	
		
		noteTextField.text! = ""

		return
	}
	/**
	addSingleNote
	
	This method inserts a single note at the BOTTOM of the list of Notes.
	
	
	- Parameters : trimmedNote - A string value that represents the note to be inserted with leading and trailing whitespace removed
	- Returns : none
	
	*/
	func addSingleNote(trimmedNote: String){
		
		let priorityLevel = priorityDropDown.selectedRow(inComponent: 0) + 1

		/*************
		HOOK:
		You must guard that the trimmed note is not empty.  AKA we already checked to see if it was nil but we didn't check to see if it was something silly like all white space before we trimmed it. If the note is empty, return early.
		
		After the guard, `append` the note to the bottom of the list, aka the end of the myTableData array. Use the given
		priorityLevel (above) to create the Note to be added
		
		+/- 3 Lines of code
		*************/
		

		
		
		
			//DO NOT CHANGE THE FOLLOWING LINE OF CODE
			myTable.insertRows(at: [setIndexPath(methodName: "addNote")], with: .automatic)
		
		
		//if the note is empty, the view table is in editing mode, or a priority is not selected, this function will return without
		// adding the note
		return
	}
	/**
	addMultipleNotes
	
	This method inserts multiple notes at the TOP of the list of Notes.
	
	
	- Parameters : trimmedNote - A string value that represents the note to be inserted with leading and trailing whitespace removed
	- Returns : none
	
	*/
	
	func addMultipleNotes(trimmedNote: String){
		let priorityLevel = priorityDropDown.selectedRow(inComponent: 0) + 1

		/*************
		HOOK:
		Guard that the trimmed note actually contains one or more commas else return early.
		
		After the guard, split the string into individual items using commas as the basis of the split
		
		Iterate over each item in the returned array.  Make sure that each is not empty after trimming its front and back white
		space. Then a create and insert a new Note into the myTableData array, using the provided priorityLevel and the
		trimmedNote as parameters.
		
		THe *LAST* line of the loop should be the line myTable.insertRows(at:...) method call that is provided below
		
		
		
		+/- 10 Lines of code
		*************/
		
		// this should be the last line of the loop
				myTable.insertRows(at: [setIndexPath(methodName: "addNote")], with: .automatic)
		
		return
		
	}
	
	
	
	@objc func clearList(){
		
		/***************
		HOOK:  Clear the array here
		****************/


		/*DO NOT REMOVE THE LINE BELOW*/
		myTable.reloadData()
		
	}
	//	Functions that you must write

	/** guardNoteisNotEmpty
	Function Name   - guardNoteIsNotEmpty
	Parameters  -  note : String
	Return Type -  Bool
	Pre-condition:  The note passed in is non-nil
	Post-Condition:  If the note passed in is empty, this function returns false, otherwise returns true
	+/- 6 Lines
	*/
	
	/** func sortNotesAlpha
	Pre-Condition:  None
	Post-Condition: the list is sorted Alphabetically by Message
	This function also needs to be tagged for obj-C runtime
	guard that the myTableData array is not empty before processing
	
	?? Lines (depends on your sorting algorithm)
	
*/
	@objc func sortNotesAlpha(){
		//Write an algorithm to sort the notes by their message, alphabetically
		
		
		myTable.reloadData()
	}
	/** func sortNotePriority
	Pre-Condition:  None
	Post-Condition: the list is sorted by their priority level. Higher priority numbers are at the top, lower numbers at
	the bottom
	This function also needs to be tagged for obj-C runtime
	guard that the myTableData array is not empty before processing
	
	?? Lines (depends on your sorting algorithm)
	
	*/
	@objc func sortNotePriority(){
		//Write an algorithm to sort the notes by their priority

		
		
		myTable.reloadData()
	}
	
	
	
	
	
	
	
	
	
	/***************YOU DO NOT NEED TO MODIFY ANY OF THE METHODS THAT FOLLOW THIS LINE ********/
	
	//returns the appropriate IndexPath based on method being called
	//The IndexPath describes the location of the row in the *View* into which we are inserting
	//Do not modify this method
	func setIndexPath(methodName: String) -> IndexPath {
		if methodName.lowercased() == "insertnote"{
			return IndexPath(row: 0, section: 0)
		} else {
			return IndexPath(row: myTableData.count - 1, section: 0)
		}
	}
	
	//IGNORE THIS METHOD YOU DON'T NEED IT FOR OUR PURPOSES
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	/******REQUIRED METHODS OF THE UITABLEDATASOURCE PROTOCOL******/
	//Tells the view how many rows are inside the view
	//this should return the number of items in the data Source Array
	//Fill in the appropriate method/property call that will get this data
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		//This function must be corrected.  It shoudl return the current size of the list
		return myTableData.count
	}
	
	//The table view provided to this method is the table view on the screen
	//the index path indicates the column (there's only one)
	//We have to provide the correct row
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//guard let checks to see if a value is nil before proceeding.  If its nil, we return, otherwise we process the cell as normal
		//We will be going over the guard let and if let syntax when we deep dive into Optional Values later in the semester
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? NoteCell else{
					let cell = UITableViewCell()
				cell.textLabel?.text = "WHO MADE THIS ERROR"
			return cell
		}
		
		cell.UpButton.isHidden = true
		cell.downButton.isHidden = true
		cell.UpButton.isEnabled = false
		cell.downButton.isEnabled = false
		
		//grab the data in the corresponding row of the data Source Array
		cell.textLabel?.text = myTableData[indexPath.row].getMessage() + "  Priority: \(myTableData[indexPath.row].getPriority())"
		//let tapGesture = UITapGestureRecognizer(target: self, action: <#T##Selector?#>)
		
		print(String(describing: cell.textLabel?.text))
		//Return the cell
		return cell
	}
	
	 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NoteCell else{
			print("Some Error")
			return
		}
		
		cell.UpButton.isEnabled = true
		cell.downButton.isEnabled = true
		cell.UpButton.isHidden = false
		cell.downButton.isHidden = false
		
		myTable.reloadData()
		
	}
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		myTable.setEditing(editing, animated: animated)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete{
			myTableData.remove(at: indexPath.row)
			myTable.deleteRows(at: [indexPath], with: .automatic)
		}
	}
	//Pre-condition:  Checks to see if the table view is in "edit mode"
	//Post-Condition: Returns false if the table is  currently being edited or true otherwise
	func goodToGo() -> Bool {
		guard !myTable.isEditing else {
			return false
		}
		return true
	}
	
	/************PICKERVIEW DELEGATE METHODS, DO NOT MODIFY FOR FINAL SUBMISSION**************************/
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return prioritiesList.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return prioritiesList[row]
	}
	func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
		
		var title = UILabel()
		if let titleView = view {
			title = titleView as! UILabel
		}
		title.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
		title.textColor = UIColor.red
		title.text =  prioritiesList[row]
		title.textAlignment = .center
		
		return title
		
	}
	/********************************************************************************************************/
	

}
//Extension to String Class to help sanitize inputs from users
//uses a regex to determine if there is leading or trailing whitespace
//and trims any it finds
extension String{
	func stringTrimFrontandBackWhiteSpace()-> String{
		let frontBackWspace = "(?:^\\s+)|(?:\\s+$)"
		let testRegEx =  try? NSRegularExpression(pattern: frontBackWspace, options: .caseInsensitive)
		if (testRegEx == nil){
			print("error!")
			return self
		}
		
		let range = NSMakeRange(0, self.count)
		let trimmedString = testRegEx?.stringByReplacingMatches(in: self, options: .reportProgress, range: range, withTemplate: "")
		return trimmedString!
		
	}
}


