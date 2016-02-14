//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Azizur Rahman on 2/8/16.
//  Copyright © 2016 Azizur Rahman. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD




class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        
        
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect to a wifi/data connection to view contents", preferredStyle: .Alert)

        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Show Hud
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
         
        // Hide Hud
        MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            
                            self.movies = (responseDictionary["results"] as! [NSDictionary])
                            self.tableView.reloadData()
                    }
                }
                else {
                    let refreshAction = UIAlertAction(title: "Try again", style: .Cancel) { (action) in
                       refreshControl.endRefreshing()
                       self.viewDidLoad()                   }
                    // add the OK action to the alert controller
                    alertController.addAction(refreshAction)
                    
                    self.presentViewController(alertController, animated: true) {
                        refreshControl.endRefreshing()
                        
                    }
                    
                    
                    
                    
                }
            }
        
        )
        task.resume()
        
        

        // Do any additional setup after   loading the view.
    }
    
    
    
    // additional stuffs
    
    
    
    
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        }
        else {
             return 0
        }
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        if let posterPath = movie["poster_path"] as? String {
            
        
        let baseUrl = "http://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        
        cell.posterView.setImageWithURL(imageUrl!)
        }
        else {
            cell.posterView.image = nil
        }
        
        
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        print("row \(indexPath.row)")
        
        return cell
    }
    
    
    
    // refresh function
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        
        //for alert controller
        
        
        let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect to a wifi/data connection to view contents", preferredStyle: .Alert)
        

        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
      
                
                let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
                    completionHandler: { (dataOrNil, response, error) in
                        
            
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        print("response: \(responseDictionary)")
                        self.movies = (responseDictionary["results"] as![NSDictionary])
                        self.tableView.reloadData()
                                    
                                    
                                    
                        // Tell the refreshControl to stop spinning
                        refreshControl.endRefreshing()
                            }
                        }
                        
                else {
                    let refreshAction = UIAlertAction(title: "Try again", style: .Cancel) { (action) in
                        refreshControl.endRefreshing()
                        self.viewDidLoad()                   }
                    
                    // add the refresh action to the alert controller
                    alertController.addAction(refreshAction)
                    
                    self.presentViewController(alertController, animated: true) {
                    
                       refreshControl.endRefreshing()
                        
                    }
                    
                    
                    
                    
                        }
                    
                    }
                    
                )
                task.resume()
        
        }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
