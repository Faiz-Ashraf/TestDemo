//
//  ViewController.swift
//  MindteckDemo
//
//  Created by Magenta on 27/10/22.
//

import UIKit


class ViewController: UIViewController {
  
    // MARK: - setup Outlet
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    // MARK: - setup Properties
    
    let arrVegitable:[String]     = ["Tomato","Patato","Peppers","Cucumber","Pumpkin"]
    let arrFruits   :[String]     = ["Apple","Banana","Carrot","Blueberry","Cherry"]
    let arrMeats    :[String]     = ["Poultry","Goat","Fish","Lamb and mutton","Sausage"]
    var arrFoods    :[String]     = []
    var slides      :[Slide]      = []
    var searchedFood = [String]()
    var searching = false
    
    // MARK: - App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName:TableViewCell.cell, bundle: nil),forCellReuseIdentifier: TableViewCell.cell)
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.darkGray
        view.bringSubviewToFront(pageControl)
        self.reloadData(self.arrVegitable)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - setup create Slides Method
    func createSlides() -> [Slide] {

        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "1")
        
        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "2")

        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "3")
        
        return [slide1, slide2, slide3]
    }
  
    // MARK: - setup Frame ScrollView
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }

}

// MARK: - setup UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView
        {
            let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
            pageControl.currentPage = Int(pageIndex)
            switch pageIndex {
            case 0:
                self.reloadData(self.arrVegitable)
            case 1:
                self.reloadData(self.arrFruits)
            default:
                self.reloadData(self.arrMeats)
            }
        }
        
    }
    
    func reloadData(_ array : [String]){
        self.arrFoods = array
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - setup UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:TableViewCell.cell) as? TableViewCell else {fatalError("cell error")}
      
        if self.searching {
            cell.lblTitle.text = self.searchedFood[indexPath.row]
        } else {
            cell.lblTitle.text = self.arrFoods[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searching {
            return searchedFood.count
        } else {
            return arrFoods.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
}

// MARK: - setup UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            searchedFood = arrFoods.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
            searching = true
            tableView.reloadData()
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        view.endEditing(true)
        tableView.reloadData()
    }
    
}
