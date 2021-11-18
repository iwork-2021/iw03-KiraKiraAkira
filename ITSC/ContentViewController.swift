//
//  ContentViewController.swift
//  ITSC
//
//  Created by KiraKiraAkira on 2021/11/18.
//

import UIKit
import SwiftSoup
class ContentViewController: UIViewController {
    var myurl:String=""
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var realcontent: UITextView!
    
    func downhtml(){
        let url_str=myurl
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
                    //}
                }
        })
        task.resume()
    }
    func set_xwdt(soucecode:String){
        do {
            //let document = try SwiftSoup.parse(self.html_page)
            let document = try SwiftSoup.parse(soucecode)
            let content0:Elements = try document.select("div.read")
            let t:Elements=try document.select("h1.arti_title")
            //var count0=content.count
            var article:String=""
            for i in content0{
                article+=try i.text()
                print(try i.text())
            }
            var tt:String=""
            for k in t{
                tt+=try k.text()
            }
            DispatchQueue.main.async {
                self.realcontent.text=article
                self.content?.text = tt
            }
            
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("content",myurl)
        downhtml()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
