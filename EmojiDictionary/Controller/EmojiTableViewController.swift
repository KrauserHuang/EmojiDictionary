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
//        Emoji(symbol: "😀",
//              name: "Grinning Face",
//              description: "A typical smiley face.",
//              usage: "happiness"),
//        Emoji(symbol: "😕",
//              name: "Confused Face",
//              description: "A confused, puzzled face.",
//              usage: "unsure what to think; displeasure"),
//        Emoji(symbol: "😍",
//              name: "Heart Eyes",
//              description: "A smiley face with hearts for eyes.",
//              usage: "love of something; attractive"),
//        Emoji(symbol: "🧑‍💻",
//              name: "Developer",
//              description: "A person working on a MacBook (probably using Xcode to write iOS apps in Swift).",
//              usage: "apps, software,programming"),
//        Emoji(symbol: "🐢",
//              name: "Turtle",
//              description: "A cute turtle.",
//              usage: "something slow"),
//        Emoji(symbol: "🐘",
//              name: "Elephant",
//              description: "A gray elephant.",
//              usage: "good memory"),
//        Emoji(symbol: "🍝",
//              name: "Spaghetti",
//              description: "A plate of spaghetti.",
//              usage: "spaghetti"),
//        Emoji(symbol: "🎲",
//              name: "Die",
//              description: "A single die.",
//              usage: "taking a risk, chance; game"),
//        Emoji(symbol: "⛺️",
//              name: "Tent",
//              description: "A small tent.",
//              usage: "camping"),
//        Emoji(symbol: "📚",
//              name: "Stack of Books",
//              description: "Three colored books stacked on each other.",
//              usage: "homework, studying"),
//        Emoji(symbol: "💔",
//              name: "Broken Heart",
//              description: "A red, broken heart.",
//              usage: "extreme sadness"),
//        Emoji(symbol: "💤",
//              name: "Snore",
//              description: "Three blue \'z\'s.",
//              usage: "tired, sleepiness"),
//        Emoji(symbol: "🏁",
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
        // 跟tableView說要計算cell的高度
        tableView.rowHeight = UITableView.automaticDimension
        // 給予tableView一個預估值，可以提升效率
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
        // 確認segue/source來接收發送端(unwind)要丟的東西(sourceVC.emoji)
        guard segue.identifier == "unwindToEmojiTableView",
              let sourceVC = segue.source as? AddEditEmojiTableViewController,
              let emoji = sourceVC.emoji else { return }
        // 判斷是新增還是編輯，從indexPathForSelectedRow來的是編輯，另外一個直接指定indexPath是array的最後一個(emojis.count)，append進emojis然後insert到最後一個indexPath
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
