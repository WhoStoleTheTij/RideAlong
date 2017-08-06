//
//  RouteTableViewController.swift
//  RideAlong
//
//  Created by Richard H on 03/08/2017.
//  Copyright © 2017 Richard H. All rights reserved.
//

import UIKit
import CoreData

class RouteTableViewController: UITableViewController {

    var stack: CoreDataHandler! = nil
    
    var routes = [Route]()
    
    var indexPathToDelete: NSIndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.stack = appDelegate.stack
        
        //self.routes = self.fetchRoutes()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //Mark: reload the routes when the view is displayed
    override func viewDidAppear(_ animated: Bool) {
        self.routes = self.fetchRoutes()
        self.tableView.reloadData()
    }
    
    //Mark: fetch the routes
    func fetchRoutes() -> [Route]{
        
        var routes = [Route]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Route")
        
        routes = try! self.stack.context.fetch(fetchRequest) as! [Route]
        
        return routes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.routes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let route = self.routes[indexPath.row] 
        
        cell.imageView?.image = UIImage(named: "navigation")
        cell.textLabel?.text = route.name
        
        return cell
    }
    
    //Mark: enable swipe delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.indexPathToDelete = indexPath as NSIndexPath
            let routeToDelete = self.routes[indexPath.row]
            self.confirmDelete(route: routeToDelete)
        }
    }
    
    //Mark: confirmation of route delete
    func confirmDelete(route: Route){
        let alert = UIAlertController(title: "Delete Route", message: "Are you sure you want to delete \(route.name!)?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title:"Delete", style: .destructive, handler: {_ in self.handleRouteDelete()} )
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil )
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion:nil)
    }
    
    //Mark: delete the route
    func handleRouteDelete(){
        let tmpRoute = self.routes[(indexPathToDelete?.row)!]
        self.routes.remove(at: (indexPathToDelete?.row)!)
        self.stack.deleteRoute(routes: [tmpRoute])
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = self.routes[indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        let viewRouteViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewRouteViewController") as! ViewRouteViewController
        viewRouteViewController.route = route
        self.navigationController?.pushViewController(viewRouteViewController, animated: true)
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
