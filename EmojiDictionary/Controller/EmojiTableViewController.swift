//
//  EmojiTableViewController.swift
//  EmojiDictionary
//
//  Created by Tai Chin Huang on 2022/3/10.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var emojis: [Emoji] = []
//    var emojis: [Emoji] = [
//        Emoji(symbol: "π",
//              name: "Grinning Face",
//              description: "A typical smiley face.",
//              usage: "happiness"),
//        Emoji(symbol: "π",
//              name: "Confused Face",
//              description: "A confused, puzzled face.",
//              usage: "unsure what to think; displeasure"),
//        Emoji(symbol: "π",
//              name: "Heart Eyes",
//              description: "A smiley face with hearts for eyes.",
//              usage: "love of something; attractive"),
//        Emoji(symbol: "π§βπ»",
//              name: "Developer",
//              description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).",
//              usage: "apps, software,programming"),
//        Emoji(symbol: "π’",
//              name: "Turtle",
//              description: "A cute turtle.",
//              usage: "something slow"),
//        Emoji(symbol: "π",
//              name: "Elephant",
//              description: "A gray elephant.",
//              usage: "good memory"),
//        Emoji(symbol: "π",
//              name: "Spaghetti",
//              description: "A plate of spaghetti.",
//              usage: "spaghetti"),
//        Emoji(symbol: "π²",
//              name: "Die",
//              description: "A single die.",
//              usage: "taking a risk, chance; game"),
//        Emoji(symbol: "βΊοΈ",
//              name: "Tent",
//              description: "A small tent.",
//              usage: "camping"),
//        Emoji(symbol: "π",
//              name: "Stack of Books",
//              description: "Three colored books stacked on each other.",
//              usage: "homework, studying"),
//        Emoji(symbol: "π",
//              name: "Broken Heart",
//              description: "A red, broken heart.",
//              usage: "extreme sadness"),
//        Emoji(symbol: "π€",
//              name: "Snore",
//              description: "Three blue \'z\'s.",
//              usage: "tired, sleepiness"),
//        Emoji(symbol: "π",
//              name: "Checkered Flag",
//              description: "A black-and-white checkered flag.",
//              usage: "completion")
//    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // load from file when viewDidLoad
        if let emojis = Emoji.loadFromFile() {
            self.emojis = emojis
        } else {
            let emojis = Emoji.sampleEmojis()
            self.emojis = emojis
        }
        
        // let large screen to be readable
        tableView.cellLayoutMarginsFollowReadableWidth = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped(_:)))
        navigationItem.leftBarButtonItem = editButtonItem
        // θ·tableViewθͺͺθ¦θ¨η?cellηι«εΊ¦
        tableView.rowHeight = UITableView.automaticDimension
        // η΅¦δΊtableViewδΈει δΌ°εΌοΌε―δ»₯ζεζη
        tableView.estimatedRowHeight = 44
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    @IBSegueAction func addEditEmoji(_ coder: NSCoder, sender: Any?) -> AddEditEmojiTableViewController? {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
            let emojiToEdit = emojis[indexPath.row]
            return AddEditEmojiTableViewController(coder: coder, emoji: emojiToEdit)
        }
        return AddEditEmojiTableViewController(coder: coder, emoji: nil)
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        // if tableView.isEditing is true, then set editing to false(like toggle it)
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    @IBAction func unwindToEmojiTableView(segue: UIStoryboardSegue) {
        // η’Ίθͺsegue/sourceδΎζ₯ζΆηΌιη«―(unwind)θ¦δΈηζ±θ₯Ώ(sourceVC.emoji)
        guard segue.identifier == "unwindToEmojiTableView",
              let sourceVC = segue.source as? AddEditEmojiTableViewController,
              let emoji = sourceVC.emoji else { return }
        // ε€ζ·ζ―ζ°ε’ιζ―η·¨θΌ―οΌεΎindexPathForSelectedRowδΎηζ―η·¨θΌ―οΌε¦ε€δΈεη΄ζ₯ζε?indexPathζ―arrayηζεΎδΈε(emojis.count)οΌappendι²emojisηΆεΎinsertε°ζεΎδΈεindexPath
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            emojis[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: emojis.count, section: 0)
            emojis.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        // whenever emojis property is change(add/edit), then save to file
        Emoji.saveToFile(emojis: emojis)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // default return 1
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // use data model
        return emojis.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmojiCell", for: indexPath) as? EmojiTableViewCell else { return UITableViewCell() }
        
        // fetch model object to display
        let emoji = emojis[indexPath.row]
        
        // iOS14, set defaultContentConfiguration
//        var content = cell.defaultContentConfiguration()
//        content.text = "\(emoji.symbol) - \(emoji.name)"
//        content.secondaryText = emoji.description
//        cell.contentConfiguration = content
        // custom, configure your cell
        cell.update(with: emoji)
        cell.showsReorderControl = true
        
        // return cell
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let emoji = emojis[indexPath.row]
//        print("\(emoji.symbol) - \(indexPath)")
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            emojis.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        // get the item you want to move use remove
        let movedEmoji = emojis.remove(at: fromIndexPath.row)
        // then insert it to the indexPath you want
        emojis.insert(movedEmoji, at: to.row)
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // to remove delete indicator
        return .delete
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
