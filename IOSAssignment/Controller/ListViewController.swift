//  ListViewController.swift
//  IOSAssignment
//  Created by Arun kumar Chauhan on 26/11/23.


import UIKit

class ListViewController: UIViewController ,UISearchBarDelegate
{
    
    // MARK :Outltes
    @IBOutlet weak var strechyTableView     : UITableView!
    @IBOutlet weak var scrollImageView      : UIImageView!
    @IBOutlet weak var scrollView           : UIScrollView!
    @IBOutlet weak var pageControl          : UIPageControl!
    @IBOutlet weak var searchBar            : UISearchBar!
    
    var kTableHeaderHeight                  :CGFloat = 300
    var searchData                          : [String]!
    var headerView                          : UIView!
    
    
    // MARK : -DataList:-
    let flowerNameData = ["Rose", "Mogra", "Purple Giant Hyssop", "Gladiolus/Sword Lily", "Feather Flower ","Orchid","AnthuriumLaceleaf", "Jasmine", "Elderberry", "Purple Giant Hyssop", "Mogra/Arabian Jasmine ", "Anthurium/ Laceleaf"]
    
    // MARK :-ImageList:-
    let sliderImagelist = [ "Image03.jpg","Image01.jpeg", "Image02.jpeg", "Image04.jpg","Image05.jpeg"]
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        pageControl.numberOfPages = sliderImagelist.count
        searchData = flowerNameData
        strechyTableView.delegate = self
        strechyTableView.dataSource = self
        searchBar.delegate = self
        scrollView.delegate = self
        headerView = strechyTableView.tableHeaderView
        strechyTableView.tableHeaderView = nil
        strechyTableView.addSubview(headerView)
        strechyTableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        strechyTableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        
        for  i in stride(from: 0, to: sliderImagelist.count, by: 1) {
            var frame = CGRect.zero
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = self.scrollView.frame.size
            self.scrollView.isPagingEnabled = true
            let sliderImg:UIImage = UIImage(named: sliderImagelist[i])!
            let sliderImgView:UIImageView = UIImageView()
            sliderImgView.image = sliderImg
            sliderImgView.contentMode = UIView.ContentMode.scaleAspectFill
            sliderImgView.frame = frame
            scrollView.addSubview(sliderImgView)
        }
        
        updateHeaderView()
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 4,height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
    }
    
    // MARK : TO Change click to page Control.
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    // MARK : update Scrollheader:
    func updateHeaderView() {
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: strechyTableView.bounds.width, height: kTableHeaderHeight)
        if strechyTableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = strechyTableView.contentOffset.y
            headerRect.size.height = -strechyTableView.contentOffset.y
        }
        headerView.frame = headerRect
    }
    
    // MARK : Search Filter:
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = []
        if searchText == ""
        {
            searchData = flowerNameData
        }
        for word in flowerNameData
        {
            if word.uppercased().contains(searchText.uppercased())
            {
                searchData.append(word)
            }
        }
        self.strechyTableView.reloadData()
    }
    
}


// MARK : TableView Delegate & Datasource:-
extension ListViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        cell.titleLabel?.text = searchData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}


