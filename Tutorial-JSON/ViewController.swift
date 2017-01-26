//
//  ViewController.swift
//  Tutorial-JSON
//
//  Created by Dillon Fernando on 1/25/17.
//  Copyright © 2017 Dillon Fernando. All rights reserved.
//

// A SIMPLE JSON TUTORIAL

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    var articles: [Article]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles()
    }
    
    
    func fetchArticles(){
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=techcrunch&sortBy=top&apiKey=452199aa477946fbaf9f468db42354f8")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print (error!)
                return
            }
            
            self.articles = [Article]()
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String: AnyObject]]{
                    
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        
                        if let title = articleFromJson["title"] as? String, let urlToImage = articleFromJson["urlToImage"] as? String{
                            article.headline = title
                            article.imageUrl = urlToImage
                        }
                        self.articles?.append(article)
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                }
                
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.title.text = self.articles?[indexPath.item].headline
        cell.imgView.downloadImage(from: (self.articles?[indexPath.item].imageUrl!)!)
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
}




extension UIImageView {
    
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
         
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
