// Copyright 2018, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// License   https://creativecommons.org/publicdomain/zero/1.0/
// Source    https://www.ralfebert.de/ios-examples/uikit/choicepopover/

import UIKit

class PopOverViewController : UITableViewController {
    
    
    
    var onSelect: (([OrderedDictionaryModel]) -> Void)?
    var autoCompleteData = [OrderedDictionaryModel]()
    var selectedList = [OrderedDictionaryModel]()
    var isSelection = true
    var isMultiSelection = false
    
    init() {
        super.init(style: .plain)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        adjustPopOverSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presentingViewController?.view.alpha = 0.8
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.presentingViewController?.view.alpha = 1.0
    }
    
    
    func adjustPopOverSize(){
        var contentSize = self.tableView.contentSize
        if contentSize.height > self.view.bounds.height/2 {
            contentSize.height = self.view.bounds.height/2
            self.preferredContentSize = contentSize
        }else{
            self.preferredContentSize.height = contentSize.height
        }
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        let item = self.autoCompleteData[indexPath.row]
        
        cell.textLabel?.text = item.value
        cell.textLabel?.numberOfLines = 0
        
        if isSelection {
            cell.selectionStyle = .default
        }else{
            cell.selectionStyle = .none
        }
        
        if selectedList.contains(where: {$0.key == item.key}) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.autoCompleteData[indexPath.row]
        
        if selectedList.contains(where: {$0.key == item.key}) {
            selectedList.removeAll(where: {$0.key == item.key})
        }else{
            selectedList.append(item)
        }
        
        onSelect?(selectedList)
        
        if !isMultiSelection {
            self.dismiss(animated: true)
        }else{
            self.tableView.reloadData()
        }
    }
    
}
