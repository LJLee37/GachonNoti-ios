//
//  Grade.swift
//  GachonNoti
//
//  Created by USER on 29/08/2019.
//  Copyright © 2019 Wiffy. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

class GradeCell: UITableViewCell {
    @IBOutlet var year: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var mark: UILabel!
    @IBOutlet var credit: UILabel!
    @IBOutlet var grade: UILabel!
}

class Grade: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    @IBOutlet var tableview1: UIView!
    private var data = [[String]]()
    @IBOutlet var totalInfo: UILabel!
    
    var jsonObject: [String: Any] = [:]
    var jsonObject2: [String: Any] = [:]
    
    @IBOutlet var card: UIView!
    @IBOutlet var mTableView: UITableView!
    
    private func setJsonObject() {
        jsonObject = [
            "fsp_cmd": "executeAjaxMap",
            "STUDENT_NO": getData("sid"),
            "YEAR": "",
            "TERM_CD": "",
            "GRADE": "",
            "SQL_ID": "mobile/affairs:EXAM_GRADE_STUDENT_SQL_S01",
            "fsp_action": "AffairsAction",
            "jsonParams": "{\"STUDENT_NO\":\"" + getData("sid") + "\",\"YEAR\":\"\",\"TERM_CD\":\"\",\"GRADE\":\"\",\"SQL_ID\":\"mobile/affairs:EXAM_GRADE_STUDENT_SQL_S01\",\"fsp_action\":\"AffairsAction\",\"fsp_cmd\":\"executeAjaxMap\"}"
        ]
        jsonObject2 = [
            "fsp_cmd": "executeAjaxMap",
            "STUDENT_NO": getData("sid"),
            "YEAR": "",
            "TERM_CD": "",
            "GRADE": "",
            "SQL_ID": "mobile/affairs:EXAM_GRADE_STUDENT_AVG_SQL_S01",
            "fsp_action": "AffairsAction",
            "jsonParams": "{\"STUDENT_NO\":\"" + getData("sid") + "\",\"YEAR\":\"\",\"TERM_CD\":\"\",\"GRADE\":\"\",\"SQL_ID\":\"mobile/affairs:EXAM_GRADE_STUDENT_AVG_SQL_S01\",\"fsp_action\":\"AffairsAction\",\"fsp_cmd\":\"executeAjaxMap\"}"
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setJsonObject()
        self.data = [[String]]()
        getGrade()
        getInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.data = [[String]]()
        self.mTableView.reloadData()
        self.totalInfo.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setData("sid","201635812")
        
        card.layer.cornerRadius = 10
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        card.layer.shadowRadius = 3
        card.layer.shadowOpacity = 0.5
        
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.layer.masksToBounds = true
        mTableView.layer.cornerRadius = 10
        
        if(dark_theme){
            totalInfo.textColor = UIColor.white
            card.backgroundColor = UIColor.gray
            mTableView.backgroundColor = UIColor.darkGray
            tableview1.backgroundColor = UIColor.darkGray
        }else{
            mTableView.layer.borderWidth = 1
            mTableView.layer.borderColor = UIColor(red:220/255, green:220/255, blue:220/255, alpha: 1).cgColor
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gradeCell", for: indexPath) as! GradeCell
        cell.year.text = data[indexPath.row][0] + " " + data[indexPath.row][1]
        cell.name.text = data[indexPath.row][2]
        cell.mark.text = data[indexPath.row][3]
        cell.credit.text = data[indexPath.row][4]
        cell.grade.text = data[indexPath.row][5]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mTableView.deselectRow(at: indexPath, animated: true)
        let popup = PopupDialog(title: data[indexPath.row][2], message:
            data[indexPath.row][0] + " " + data[indexPath.row][1] + "\n" +
                "학년: " + data[indexPath.row][3] + "\n" +
                "학점: " + data[indexPath.row][4] + "\n" +
                "성적: " + data[indexPath.row][5], image: nil)
        self.present(popup, animated: true, completion: nil)
    }
    
    func getGrade() {
        //let id = getData("sid")
        let url = "http://smart.gachon.ac.kr:8080/WebJSON"
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject)
        //print(jsonObject.description)
        requestHTTPJson(url: url, json: jsonData!, completion: { result in
            do {
                //print(result)
                
                let data = result.data(using: .utf8)
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                // Parse JSON data
                let jsonP = jsonResult?["ds_list"] as? [AnyObject]
                if (jsonP != nil) {
                    for each in jsonP! {
                        var tmp = [String]()
                        
                        let CREDIT = each["CREDIT"] as? String
                        let GRADE = each["GRADE"] as? String
                        let YEAR = each["YEAR"] as? String
                        let SUBJECT_NM = each["SUBJECT_NM"] as? String
                        let MARK = each["MARK"] as? String
                        let TERM_CD = each["TERM_CD"] as? String
                        
                        tmp.append(YEAR?.description ?? "")
                        tmp.append(TERM_CD?.description ?? "")
                        tmp.append(SUBJECT_NM?.description ?? "")
                        tmp.append(GRADE?.description ?? "")
                        tmp.append(CREDIT?.description ?? "")
                        tmp.append(MARK?.description ?? "")
                        
                        self.data.append(tmp)
                    }
                }
                DispatchQueue.main.async {
                    //print(self.data)
                    self.mTableView.reloadData()
                }
            } catch {
            }
        })
    }
    
    func getInfo() {
        //let id = getData("sid")
        let url = "http://smart.gachon.ac.kr:8080/WebJSON"
        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject2)
        //print(jsonObject.description)
        requestHTTPJson(url: url, json: jsonData!, completion: { result in
            do {
                //print(result)
                //self.data = [[String]]()
                
                let data = result.data(using: .utf8)
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                // Parse JSON data
                let jsonP = jsonResult?["ds_list"] as? [AnyObject]
                if (jsonP != nil) {
                    if (jsonP!.count > 0) {
                        let CREDIT = jsonP![0]["CREDIT"] as? String ?? "0"
                        let SCORE = jsonP![0]["SCORE"] as? String ?? "0"
                        let MARK = jsonP![0]["MARK"] as? String ?? "0"
                        
                        DispatchQueue.main.async {
                            self.totalInfo.text = "이수학점:" + CREDIT + " / 평점:" + MARK + " / 백분률:" + SCORE
                        }
                    }
                }
            } catch {
            }
        })
    }
}
