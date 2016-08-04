//
//  Clima.swift
//  RestFulEj
//
//  Created by JhonnatanMacias on 8/3/16.
//  Copyright © 2016 JhonnatanMacias. All rights reserved.
//

import UIKit

class Clima: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet weak var ciudad: UILabel!
    @IBOutlet weak var temperatura: UILabel!
    
    var ciudades : Array<Array<String>> = Array<Array<String>>()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.ciudades.append(["Caracas", "VEXX008"])
        self.ciudades.append(["Paris", "FRXX0076"])
        self.ciudades.append(["Grenoble", "FRXX0153"])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.ciudades.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.ciudades[row][0]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let urls = "https://query.yahooapis.com/v1/public/yql?format=json&q=SELECT%20*%20FROM%20weather.forecast%20WHERE%20u%20=%20%27c%27%20and%20location%20=%20%27"
        let url = NSURL(string: urls + self.ciudades[row][1] + "%27")
        print(url)
        let datos = NSData(contentsOfURL:  url!)
        
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
            let dico1 = jsonStr as! NSDictionary
            let dico2 = dico1["query"] as! NSDictionary
            let dico3 = dico2["results"] as! NSDictionary
            let dico4 = dico3["channel"] as! NSDictionary
            let dico5 = dico4["units"] as! NSDictionary
            self.ciudad.text = dico5["distance"] as! NSString as String
            
        } catch {
            
        }
        print(datos)
    }

}
