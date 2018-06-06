//
//  CalendarViewController.swift
//  PlanIt
//
//  Created by Karla Pantelimon on 30/05/2018.
//  Copyright © 2018 Karla Pantelimon. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    let formatter = DateFormatter();

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarCell: JTAppleCalendarView!
    let userDefaults = UserDefaults.standard
    var projectDates : [String:Projects] = [:];
//    var porjects:[Projects] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = UIColor.black;
        
        navigationController?.navigationBar.addSubview(monthLabel);
        navigationController?.navigationBar.addSubview(yearLabel);
        
//        navigationController?.navigationBar.clipsToBounds = true;
        
        calendarCell.scrollToDate(Date(), animateScroll: false)
        setUpCalendar();
        
        getDatesFromProjects();
    
        // Do any additional setup after loading the view.
    }
    
    func getDatesFromProjects() -> Void {
        let decoded  = userDefaults.object(forKey: "projects") as! Data
        let projects = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Projects]
        for (project) in projects{
            var startTimestamp = Date(timeIntervalSince1970: TimeInterval(project.startDate)!);
            let finishTimestamp = Date(timeIntervalSince1970: TimeInterval(project.finishDate)!);
            while( startTimestamp < finishTimestamp){
                projectDates[ changeDateToString(date: startTimestamp)] = project;
                startTimestamp = startTimestamp + 100000;
            }
            
        }
    }
    
    func changeLabelColor(cell: CalendarCell, cellState: CellState) -> Void {
        let today = Date();

        if changeDateToString(date: today) == changeDateToString(date: cellState.date){
            cell.dateLabel.textColor = UIColor.blue;
            return;
        }
        if(cellState.dateBelongsTo == .thisMonth){
            cell.dateLabel.textColor = UIColor.black;
        }else {
            cell.dateLabel.textColor = UIColor.gray;
        }
    }
    
    func setUpCalendar(){
        //cell spacing
        calendarCell.minimumLineSpacing = 0;
        calendarCell.minimumInteritemSpacing = 0;
        
        //labels for month and year
        calendarCell.visibleDates{ (visibleDates) in
            let date = visibleDates.monthDates.first!.date;
            
            self.formatter.dateFormat = "yyyy";
            self.yearLabel.text = self.formatter.string(from: date);
            
            self.formatter.dateFormat = "MMMM";
            self.monthLabel.text = self.formatter.string(from: date);
            
        }
    }

    func setUpLabels(visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date;
        
        formatter.dateFormat = "yyyy";
        yearLabel.text = formatter.string(from: date);
        
        formatter.dateFormat = "MMMM";
        monthLabel.text = formatter.string(from: date);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func markEvent(cell: CalendarCell, cellState: CellState) -> Void {
        cell.selectView.isHidden = !projectDates.contains(where: {$0.key == changeDateToString(date: cellState.date)})
    }

    func changeDateToString(date: Date) -> String{
        formatter.dateFormat = "yyyy MM dd";
        formatter.timeZone = Calendar.current.timeZone;
        formatter.locale = Calendar.current.locale;
    
        let dateToString = formatter.string(from: date);
        return dateToString;
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
extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell;
        cell.dateLabel.text = cellState.text;
        changeLabelColor(cell: cell, cellState: cellState);
        markEvent(cell: cell,cellState: cellState);
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell{
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell;
        cell.dateLabel.text = cellState.text;
        changeLabelColor(cell: cell, cellState: cellState);
        markEvent(cell: cell,cellState: cellState);
        return cell;
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpLabels(visibleDates: visibleDates );
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        let calendarCell = cell as! CalendarCell;
        if(!calendarCell.selectView.isHidden){
            //make this go to project page
            let projectView = storyboard?.instantiateViewController(withIdentifier: "ProjectView") as! ProjectViewController;
            navigationController?.pushViewController(projectView, animated: false);
        }
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd";
        formatter.timeZone = Calendar.current.timeZone;
        formatter.locale = Calendar.current.locale;
        
        let start = formatter.date(from: "2018 01 01");
        let finish = formatter.date(from: "2030 01 01");
        
        let parameters = ConfigurationParameters(startDate: start!, endDate: finish!);
        return parameters;
        
    }
    
   
}
