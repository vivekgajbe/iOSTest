//
//  CartViewController.swift
//  MarketDemo
//
//  Created by vivek gajbe on 08/10/17.
//  Copyright © 2017 Vivek Gajbe. All rights reserved.
//

import UIKit

class CartViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{

    //MARK:- variable declaration
    var arrmCartProducts = NSMutableArray()
    @IBOutlet var tblCardView: UITableView!
    @IBOutlet var lblTotalPrice: UILabel!
    
    
    //MARK:- initial method declaration
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        self.getCartDataFromLocalDB()

    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK:- user define method
    func getCartDataFromLocalDB()
    {
        arrmCartProducts = UsersOperations().getCartDetails()//getch card data
        tblCardView.reloadData()
        if arrmCartProducts.count > 0
        {
            var iTotal = NSInteger()
            
            
            for entProduct : clsProductEntity in (arrmCartProducts as NSArray as! [clsProductEntity])
            {
                iTotal = iTotal + NSInteger(entProduct.strPrice!)!
            }
            
            lblTotalPrice.text! = "Total Price : \u{20B9} \(iTotal)"
        }
    }
    
    //call vender
    func callVendor(sender:UIButton)
    {
         let entCartDetails  = self.arrmCartProducts.object(at: sender.tag) as! clsProductEntity
        
        if let url = URL(string: "tel://\(String(describing: entCartDetails.strPhoneNumber!))"), UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    //Delete record from cart
    func deleteFromCart(sender:UIButton)
    {
        let entCartDetails  = self.arrmCartProducts.object(at: sender.tag) as! clsProductEntity
        let bIsInsert = UsersOperations().delateProductDetailsFromCart(entProductDetails: entCartDetails)
        if bIsInsert == true
        {
            Constants.showAlert(titleString: "Alert", messageString: "Item Delated From cart", delegate: self)
             self.getCartDataFromLocalDB()
        }
        else
        {
            Constants.showAlert(titleString: "Alert", messageString: "Some thing went worng", delegate: self)
        }
        tblCardView.reloadData()
    }
    
  // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrmCartProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tblCardView.dequeueReusableCell(withIdentifier: Constants.kTblIdenCellCart) as! clsCardTableViewCell
        
        let ent = arrmCartProducts[indexPath.row] as! clsProductEntity
        
        
        cell.lblProductName.text = ent.strProductName
        cell.lblPrice.text = "\u{20B9}" + ent.strPrice!
        cell.lblVendorAdd.text = ent.strVendorAddress
        cell.lblVendorName.text = ent.strVendorName
        
        var strImageUrl = ent.strProductImg
        
        strImageUrl = strImageUrl?.replacingOccurrences(of: " ", with: "%20")
        
        cell.imgItem.imageFromServerURL(urlString: strImageUrl!)
        
        
        cell.btnDeleteFromCard.addTarget(self, action:#selector(deleteFromCart), for: UIControlEvents.touchUpInside)
        cell.btnDeleteFromCard.tag = indexPath.row
        cell.btnDeleteFromCard.layer.borderWidth = 1.0
        cell.btnDeleteFromCard.layer.borderColor = UIColor.gray.cgColor
        cell.btnCallVender.layer.borderWidth = 1.0
        cell.btnCallVender.layer.borderColor = UIColor.gray.cgColor
        
        
        cell.btnCallVender.addTarget(self, action:#selector(callVendor), for: UIControlEvents.touchUpInside)
        cell.btnCallVender.tag = indexPath.row
        
        
        //set cell shadow effect
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.isExclusiveTouch = true
        cell.clipsToBounds = true
        
        cell.viwBG.layer.shadowColor = UIColor.darkGray.cgColor
        cell.viwBG.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        cell.viwBG.layer.shadowOpacity = 3;
        cell.viwBG.layer.shadowRadius = 3.0;
        cell.viwBG.layer.cornerRadius = 5.0
        return cell
    }

}
