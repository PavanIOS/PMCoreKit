//
//  AutoCompleteView.swift
//  GpHealthPlus
//
//  Created by sn99 on 22/05/20.
//

import UIKit

public class AutoCompleteView: UIViewController {
    
    @IBOutlet weak var confirmButtom: CustomButton!
    @IBOutlet weak var autoCompleteTable: CustomTableView!
    @IBOutlet weak var confirmButtonHeight: NSLayoutConstraint!
    
    var searchBar = UISearchBar()
    
    
    open var autoCompletionBlock: ((String,[OrderedDictionaryModel]) -> Void)?
    open var dismiss: (() -> Void)?
    
    
    var autoCompleteData = [OrderedDictionaryModel]()
    var isMultiSelection = true
    var maximumLimit = 0
    var filteredList = [OrderedDictionaryModel]()
    var selectedData = ""
    var selectedList = [OrderedDictionaryModel]()
    var searchText = ""
    
    
    var topPadding : CGFloat = 0
    var bottomPadding : CGFloat = 0
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
    }
    
    func updateSafeAreaPadding(){
        topPadding = view.safeAreaInsets.top
        bottomPadding = view.safeAreaInsets.bottom
        
        if bottomPadding > 0 {
            bottomPadding = bottomPadding/2
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // if isMultiSelection {
        updateSafeAreaPadding()
        confirmButtonHeight.constant = 50 + bottomPadding
        // }
    }
    
    func setupUI(){
        setupSearchBar()
        setupLayouts()
        setupTableView()
        bindData()
    }
    
    func setupSearchBar(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }else{
            autoCompleteTable.tableHeaderView = searchController.searchBar
        }
        self.searchBar = searchController.searchBar
        
        //Change cancel button title & color
        // searchController.searchBar.tintColor = UIColor.white
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Dismiss"
    }
    
    func setupLayouts(){
        //        if isMultiSelection {
        //            self.confirmButtom.isHidden = false
        //        }else{
        //             self.confirmButtom.isHidden = true
        //        }
        
        confirmButtom.buttonTitle = "Confirm"
        confirmButtom.backgroundColor = Colors.themeColor
        confirmButtom.titleColor = Colors.white
        confirmButtom.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        confirmButtom.animateEnabled = false
        
        setupBarButtons()
    }
    
    func setupTableView(){
        autoCompleteTable.estimatedRowHeight = 100
        autoCompleteTable.rowHeight = UITableView.automaticDimension
    }
    
    func setupBarButtons(){
        var closeButton = UIBarButtonItem()
        if #available(iOS 13.0, *) {
            closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.dismissView))
        } else {
            closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.dismissView))
            closeButton.tintColor = UIColor.systemBlue
        }
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func dismissView(sender:UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonClicked(_ sender: CustomButton) {
        var formattedArray = ""
        if self.isMultiSelection {
            formattedArray = (selectedList.map{$0.value}).joined(separator: ",")
        }else{
            formattedArray = (selectedList.map{$0.value}).joined(separator: "")
        }
        
        self.autoCompletionBlock?(formattedArray,self.selectedList)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func bindData(){
        self.filteredList = self.autoCompleteData
        self.autoCompleteTable.reloadData()
    }
    
}

extension AutoCompleteView : UITableViewDelegate,UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
        
        let item = self.filteredList[indexPath.row]
        let searchData = self.searchBar.text! //.components(separatedBy: ",").last ?? ""
        let formattedString = self.attributedText(withString: item.value, boldString: searchData, font: UIFont.systemFont(ofSize: 17))
        
        cell.textLabel?.attributedText = formattedString
        if selectedList.contains(where: {$0.value == item.value}) {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        cell.selectionStyle = .none
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = self.filteredList[indexPath.row]
        if self.isMultiSelection {
            if !selectedList.contains(where: {$0.value == item.value}) {
                if maximumLimit > 0 && selectedList.count >= maximumLimit {
                    CommonAlertView.shared.showAlert("Please select maximum \(maximumLimit) values")
                }else{
                selectedList.append(item)
                }
            }else{
                selectedList.removeAll(where: {$0.value == item.value})
            }
        }else{
            selectedList.removeAll()
            selectedList.append(item)
        }
        
        var formattedArray = (selectedList.map{$0.value}).joined(separator: ",")
        if self.isMultiSelection {
            if selectedList.count > 0 {
                formattedArray.append(",")
            }
        }
        // self.searchBar.text = formattedArray // self.searchBarTF.text! + item
        self.autoCompleteTable.reloadData()
        
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: font.pointSize + 2, weight: .medium)]
        let range = (string as NSString).range(of: boldString, options: .caseInsensitive)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}


extension AutoCompleteView : UISearchBarDelegate {
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.filteredList = self.autoCompleteData
        self.autoCompleteTable.reloadData()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchBar.text! //.components(separatedBy: ",").last ?? ""
        
        if searchText != "" {
            self.filterMapData(searchText: searchText)
        }else{
            selectedList.removeAll()
            self.filteredList = self.autoCompleteData
            self.autoCompleteTable.reloadData()
        }
    }
    
    public func filterMapData(searchText:String) {
        
        let filterData = self.autoCompleteData.filter({$0.value.lowercased().contains(searchText.lowercased())})
        
        self.filteredList = filterData
        self.autoCompleteTable.reloadData()
    }
    
    
//    func groupItems(filterData:[OrderedDictionaryModel]){
//        let groupedContacts = filterData.reduce([[OrderedDictionaryModel]]()) {
//            guard var last = $0.last else { return [[$1]] }
//            var collection = $0
//            if last.first!.value.first == $1.value.first {
//                last += [$1]
//                collection[collection.count - 1] = last
//            } else {
//                collection += [[$1]]
//            }
//            return collection
//        }
//    }
}
