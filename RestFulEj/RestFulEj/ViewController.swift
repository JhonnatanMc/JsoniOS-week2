//
//  ViewController.swift
//  RestFulEj
//
//  Created by JhonnatanMacias on 7/31/16.
//  Copyright © 2016 JhonnatanMacias. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    private var textView: UITextView!
    private var coverImg: UIImageView!
    private var titulo: UILabel!
    private var autor: UILabel!
    
    func sincrono() {
        let urls = "http://dia.ccm.itesm.mx/"
        let url = NSURL(string: urls)
        let datos: NSData? = NSData(contentsOfURL: url!)
        let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
        print(texto!)
    }
    
    func asincrono() {
        let urls = "http://dia.ccm.itesm.mx/"
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        let bloque = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void  in
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            print(texto!)
        }
       
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
        print("antes o despues")
    }
    
    func asincrono2() {
         // https://openlibrary.org/ self.navigationController pushViewController:activityController animated:YES];
    }
    
    
    func presentClima() {
        let contentView = self.storyboard!.instantiateViewControllerWithIdentifier("climaId") as! Clima
//        self.navigationController?.pushViewController(contentView, animated: true)
        self.presentViewController(contentView, animated: true) {
            
        }
        
        
        
    }
    
    func climeaButton() {
        let climaBtn = UIButton()
        climaBtn.frame = CGRectMake(30, 90, 120, 35)
        climaBtn.setTitle("Clima", forState: UIControlState.Normal)
        climaBtn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        climaBtn.addTarget(self, action: "presentClima", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(climaBtn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        week1()
    }
    
    
    func week1(){
        let textField = UITextField(frame: CGRectMake(30, 60, self.view.frame.width - 60, 35))
        
        textField.becomeFirstResponder()
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 1
        textField.returnKeyType = UIReturnKeyType.Search
        textField.clearButtonMode = UITextFieldViewMode.Always
        textField.delegate = self
        self.view.addSubview(textField)
        
        self.coverImg = UIImageView(frame:CGRectMake(30, textField.frame.maxY + 40, 60, 80))
        self.coverImg.image = UIImage(named: "ic_book")
        self.coverImg.layer.borderColor = UIColor.grayColor().CGColor
        self.coverImg.layer.borderWidth = 1
        self.view.addSubview(self.coverImg)
        
        self.titulo = UILabel()
        self.titulo.frame = CGRectMake(coverImg.frame.maxX + 5, textField.frame.maxY + 40, 250, 20)
        self.titulo.text = " "
        self.titulo.lineBreakMode = .ByWordWrapping
        self.titulo.numberOfLines = 2
        self.titulo.textColor = UIColor.blueColor()
//        self.titulo.sizeToFit()
        self.view.addSubview(self.titulo)
        
        self.autor = UILabel()
        self.autor.frame = CGRectMake(coverImg.frame.maxX + 5, titulo.frame.maxY + 5, 250, 20)
        self.autor.text = ""
        self.autor.lineBreakMode = .ByWordWrapping
        self.autor.numberOfLines = 2
//        self.autor.sizeToFit()
        self.view.addSubview(self.autor)
        
        
//        textView = UITextView(frame: CGRectMake(30, textField.frame.maxY + 20, self.view.frame.width - 60, 220))
//        textView.delegate = self
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.grayColor().CGColor
//        textView.layoutManager.allowsNonContiguousLayout = false
//        self.view.addSubview(textView)
        //        asincrono()

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField.text?.characters.count > 0 {
            defer {
                dispatch_async( dispatch_get_main_queue(),{
                     self.datoslibro(textField.text!)
                }) 
            }
           
        }
        
        return false
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange  range: NSRange, replacementText text: String) -> Bool {
  
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func datoslibro(str: String) {
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + str
        let url = NSURL(string: urls)
        let datos = NSData(contentsOfURL:  url!)
        let ini = "ISBN:" + str
        
        do {
            let jsonStr = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
            let dico1 = jsonStr as! NSDictionary
            
            if dico1[ini] != nil {
                let dico2 = dico1[ini] as! NSDictionary
                
                let dico3 = dico2["authors"] as! NSArray
                var autorStr = ""
                
                for autors in dico3 {
                    let dico4 = autors["name"] as! NSString
                    autorStr = (dico4 as String) + "\n"
                }
                
                self.autor.text = "by: " + autorStr
                self.autor.sizeToFit()
                
                let tit = dico2["title"] as! NSString as String
                self.titulo.text = tit
                
                if dico2["cover"] != nil {
                    let cover = dico2["cover"] as! NSDictionary
                    let img = cover["medium"] as! NSString as String
                    let imgcover = UIImage(named: img)
                    
                    if let url = NSURL(string: img) {
                        if let data = NSData(contentsOfURL: url) {
                            coverImg.image = UIImage(data: data)
//                            self.coverImg.sizeToFit()
                        }
                    }
                    
                }
                
                
                
            }
            
            
//            let dico3 = dico2["results"] as! NSDictionary
//            let dico4 = dico3["channel"] as! NSDictionary
//            let dico5 = dico4["units"] as! NSDictionary
          //  self.ciudad.text = dico5["distance"] as! NSString as String
            
        } catch {
            
        }
        
    }
    
    
    func performAction(str: String) {
        
        // 978-84-376-0494-7  0451526538
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + str
        let url = NSURL(string: urls)
        let sesion = NSURLSession.sharedSession()
        print(url)
        let bloque = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void  in
            if datos != nil {
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                
                
                //            print(texto!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.textView.text = texto! as String
                }
            } else {
                self.alertMessage("Debe estar conectado a Internet")
            }
        }
        
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
    }
    
    func alertMessage(description: String){
        let alertController = UIAlertController(title: "INTERNET", message:
            description, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

