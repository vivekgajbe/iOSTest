//
//  HomeViewController.swift
//  TestDemo
//
//  Created by vivek gajbe on 06/10/17.
//  Copyright © 2017 Vivek Gajbe. All rights reserved.
//

import UIKit

class HomeViewController: BaseClass ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout
{
    //MARK:Variable declaration
    var dataTask: URLSessionDataTask?
    
    var arrmProductDetails = NSMutableArray()
    @IBOutlet var colViwProduct: UICollectionView!
    @IBOutlet var actViwLoader: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //call for fetch product details
        self.getAllProductDetails()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- collection view delegate method
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return arrmProductDetails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kColIdenProduct, for: indexPath as IndexPath) as! clsProductCollectionViewCell)
        let entCategoryDetails  = self.arrmProductDetails.object(at: indexPath.row) as! clsProductEntity
        
        cell.lblProductName.text = entCategoryDetails.strProductName
        cell.lblProductPrice.text = entCategoryDetails.strPrice
        cell.lblVenderName.text = entCategoryDetails.strVendorName
        cell.lblVenderAdd.text = entCategoryDetails.strVendorAddress
        
        var strImageUrl = entCategoryDetails.strProductImg
        
        strImageUrl = strImageUrl?.replacingOccurrences(of: " ", with: "%20")
        
        cell.imgProfile.imageFromServerURL(urlString: strImageUrl!)
        
        cell.imgProfile.contentMode = .scaleAspectFit
        
        cell.btnAddToCart.addTarget(self, action: #selector(btnAddToCardClicked(sender:)), for: .touchUpInside)
        cell.btnAddToCart.tag = indexPath.row
        cell.btnAddToCart.layer.borderWidth = 1.0
        cell.btnAddToCart.layer.borderColor = UIColor.gray.cgColor
        
        cell.viwBG.layer.borderWidth = 1.0
        cell.btnAddToCart.layer.borderColor = UIColor.gray.cgColor
        
        
        cell.isExclusiveTouch = true
        cell.clipsToBounds = true
        cell.viwBG.layer.shadowColor = UIColor.darkGray.cgColor
        cell.viwBG.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.viwBG.layer.shadowOpacity = 3;
        cell.viwBG.layer.shadowRadius = 3.0;
        cell.viwBG.layer.cornerRadius = 2.0;
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let iCellWidth = (self.view.frame.size.width / 2) - 15;
        let iCellHeight = iCellWidth * 1.2
        
        return CGSize(width: iCellWidth, height: iCellHeight)
    }
    
    //MARK:- user define method
    func btnAddToCardClicked(sender:UIButton)
    {
        //For add to card
        let entCategoryDetails  = arrmProductDetails.object(at: sender.tag) as! clsProductEntity
        
        let bIsInsert : Bool = UsersOperations().saveProductToCard(entProductDetails: entCategoryDetails)
            if bIsInsert == true
            {
                Constants.showAlert(titleString: "Alert", messageString: "Item Added in card", delegate: self)
            }
            else
            {
                Constants.showAlert(titleString: "Alert", messageString: "Item Already Available in a Card", delegate: self)
            }
            
        
    }

    //MARK:- user define method
    //fetch Product detail
    func getAllProductDetails()
    {
        let url = Constants.strWebserviceURL

        actViwLoader.startAnimating()
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {

                self.arrmProductDetails = self.parseJsonForProductDetails(response: responseJSON)
                
                DispatchQueue.main.async
                    {
                    if self.arrmProductDetails.count > 0
                    {
                        self.colViwProduct.reloadData()
                        self.actViwLoader.stopAnimating()
                        self.actViwLoader.isHidden = true
                    }
                }
                
            }
        }
        
        task.resume()
    }
    func parseJsonForProductDetails(response : [String: Any])-> NSMutableArray
    {
        let arrProduct = NSMutableArray()
        let dictData : [String: Any] = response 
        
        let prod : Array<Any>?
        prod = dictData["products"] as? Array
        for obj in prod!
        {
        let dict  = obj as! [String : Any]
            let entProduct = clsProductEntity()
            
            if let name = dict["productname"]
            {
                entProduct.strProductName = name as? String
            }
            
            if let price = dict["price"]
            {
                entProduct.strPrice = price as? String
            }
            
            if let vendorname = dict["vendorname"]
            {
                entProduct.strVendorName = vendorname as? String
            }
            
            if let add = dict["vendoraddress"]
            {
                entProduct.strVendorAddress = add as? String
            }
            
            if let img = dict["productImg"]
            {
                entProduct.strProductImg = img as? String
            }
            if let number = dict["phoneNumber"]
            {
                entProduct.strPhoneNumber = String(describing: number)
            }
            
            //Code is hidden as is no screen to display detail image in a requirment
//            let prodImage : Array<Any>?
//            prodImage = dict["productGallery"] as? Array<Any> as! Array<String>
//            for objImages in prodImage!
//            {
//              entProduct.arrProductGallery?.append(objImages as! String)
//            }

            arrProduct.add(entProduct)
        }

     return arrProduct
    }
}

//Asyncronously loading of image and store it in a catche
let imageChache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
       
        image = nil
        
        if let imagefromCatch = imageChache.object(forKey: urlString as AnyObject ) as? UIImage
        {
        self.image = imagefromCatch
            return
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                
                let imageToCatche = UIImage(data: data!)
                imageChache.setObject(imageToCatche!, forKey: urlString as AnyObject)
                
                self.image = imageToCatche
            })
            
        }).resume()
    }}
