//
//  InfoViewController.swift
//  ITSC
//
//  Created by KiraKiraAkira on 2021/11/17.
//

import UIKit
import SwiftSoup
class InfoViewController: UIViewController {

    @IBOutlet weak var text: UITextView!
    var info_html:String = ""
    var text1:String = ""
    func set_info(){
        do {
            let document = try SwiftSoup.parse(self.info_html)
            let content:Elements = try document.select("div.news_box")
            var i = 0
            for link in content{
                print(try link.text())
                i += 1
                if (try link.text().contains(" ")){
                    text1 += try link.text() + "\n"
                    text1 += "\n"
                }
            }
            text.text = text1
            //print(text1)
        } catch Exception.Error(_, let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    func downloadhtml(){
        let url_str="https://itsc.nju.edu.cn/main.htm"
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
                    DispatchQueue.main.sync {
                        self.info_html = string
                        //print(string)
                        self.set_info()
                    }
                }
        })
        task.resume()
         
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.downloadhtml()
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
