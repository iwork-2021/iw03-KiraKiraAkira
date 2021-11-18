//
//  XwdtTableViewController.swift
//  ITSC
//
//  Created by KiraKiraAkira on 2021/11/18.
//

import UIKit
import SwiftSoup
var max:Int=0
class XwdtTableViewController: UITableViewController {
    var xwdt:[TableCell]=[]
    let base_url:String="https://itsc.nju.edu.cn/xwdt/list"
    var html_page:String=""
    var cur_page:Int=1
    var max_page:Int = 18

    func get_max_page(){
        let url_str=base_url+"1.htm"
        let url = URL(string: url_str)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                do {
                    let document = try SwiftSoup.parse(string)
                    let pages_el: Element = try document.select("em.all_pages").first()!
                    self.max_page = Int(try pages_el.text()) ?? 0
                    max=Int(try pages_el.text()) ?? 0
                    print("in", max)
                    //print("before",self.max_page)
//                    return self.max_page
                    
                } catch Exception.Error(_, let message) {
                    print(message)
                } catch {
                    print("error")
                }
                }
        })
        task.resume()
        //return self.max_page
    }
    func downhtml(pageNum:Int){
        let url_str=base_url+String(pageNum+1)+".htm"
        let url = URL(string: url_str)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                    //DispatchQueue.main.sync {
                        //self.html_page = string
                        //print(string)
                        self.set_xwdt(soucecode:string)
                        self.update_page()
                        self.tableView.reloadData()
                    //}
                }
        })
        task.resume()
    }
    func set_xwdt(soucecode:String){
        do {
            //let document = try SwiftSoup.parse(self.html_page)
            let document = try SwiftSoup.parse(soucecode)
            let content:Elements = try document.select("li.news")
            //var count0=content.count
            var count1=1
            for i in content{
                if(count1<=content.count-12){
                    let linkwebsite = try SwiftSoup.parse(try i.html()).select("a").first()!
                    var linkhref = try linkwebsite.attr("href")
                    linkhref="https://itsc.nju.edu.cn"+linkhref
                    //print(try i.text())
                    //print(linkhref)
                    let one_news=try i.text()
                    let t:String = String(one_news.split(separator: " ")[0])
                    let d:String = String(one_news.split(separator: " ")[1])
                    //print(t,d,linkhref)
                    let temp:TableCell=TableCell(t: t,d: d,w: linkhref)
                    self.xwdt.append(temp)
                }
                count1+=1
            }
            //print(content)
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    func update_page(){
        
    }
    override func viewDidLoad() {
        //self.get_max_page()
        super.viewDidLoad()
        //print("out",max)
        //downhtml(pageNum: 1)
        let operationqueue=OperationQueue()
        operationqueue.maxConcurrentOperationCount=1
        let blockop1=BlockOperation{
            self.get_max_page()
            print("i am here",max)
            
        }
        let blockop2=BlockOperation{
            print("block",max)
            for j in 0..<18 {
                print(j)
                self.downhtml(pageNum:j)
            }
        }
        blockop2.addDependency(blockop1)
        operationqueue.addOperation(blockop1)
        operationqueue.addOperation(blockop2)
//        let queue = DispatchQueue(label: "com.table",attributes: [.concurrent])
//            queue.async {
//                self.get_max_page()
//            }
//            queue.async {
//                print("queue",max)
//                for j in 0..<max {
//                    print(j)
//                    self.downhtml(pageNum:j)
//                    usleep(400000)
//                }
//            }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.xwdt.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XwdtCell", for: indexPath) as! XwdtTableViewCell
        if(indexPath.row >= self.xwdt.count){
            cell.title.text! = ""
            cell.date.text! = ""
            return cell
        }
        let news = self.xwdt[indexPath.row]
        // Configure the cell...
        cell.title.text! = news.title
        cell.date.text! = news.date
        // Configure the cell...
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let NewsViewController = segue.destination as! ContentViewController
        let cell = sender as! XwdtTableViewCell
        NewsViewController.myurl = xwdt[tableView.indexPath(for: cell)!.row].website
        print(NewsViewController.myurl)
        //NewsViewController.style = "News"
    }
    

}
