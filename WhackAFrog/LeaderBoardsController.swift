//
//  LeaderBoardsController.swift
//  WhackAFrog
//
//  Created by Shay Manzaly on 6/25/17.
//  Copyright © 2017 Shay Manzaly. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LeaderBoardsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let recordsManger = RecordsManager()
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var table: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordsManger.getRecords().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "table_cell", for: indexPath) as! RecordCell
        
        cell.recordPlace.text = String(indexPath.row+1)
        cell.recordName.text = recordsManger.getRecords()[indexPath.row].name
        cell.recordScore.text = String(recordsManger.getRecords()[indexPath.row].score)
        cell.recordLevel.text = String(recordsManger.getRecords()[indexPath.row].level)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let span : MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let recordLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(recordsManger.getRecords()[indexPath.row].lat, recordsManger.getRecords()[indexPath.row].long)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(recordLocation, span)
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
    }

}
