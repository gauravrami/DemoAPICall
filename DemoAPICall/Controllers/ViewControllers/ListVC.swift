//
//  ListVC.swift
//  DemoAPICall

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    
    fileprivate let aQueue = DispatchQueue(label: "TheImgQueue")
    let CELL_HEIGHT : CGFloat = 180.0
    
    var arrListBeans : [ListBean] = [ListBean]() {
        didSet {
            tblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.intialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - Get Data From Server.
extension ListVC {
    func intialSetup() {
        self.tblView.dataSource = self
        self.tblView.delegate = self
        
        self.getListAPICall()
    }

}

//MARK: - Get Data From Server.
extension ListVC {
    func getListAPICall() {
        if isInternetAvailabel() == false {
            self.showAlertForNoInternet()
        } else {
            //Do API Call
            self.showHud()
            ServerCall.sharedInstance.requestWithURL(.GET, urlString: URL_POSTS, delegate: self, name: .ListOfPosts)
        }
    }
}

//MARK: - ServerCall Delegate
extension ListVC : ServerCallDelegate {
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName) {
        self.hideHud()
        print("\n\n\n\n\n RESPONSE FROM VIEW-CONTROLLER ---> \n\n")
        print(resposeObject)
        
        guard let arrResponse = resposeObject as? [[String : AnyObject]] else { return }
        
        self.arrListBeans.removeAll()
        for aDict in arrResponse {
            let bean = ListBean()
            bean.id = TO_INT(aDict["id"])
            bean.userId = TO_INT(aDict["userId"])
            bean.title = TO_STRING(aDict["title"])
            bean.body = TO_STRING(aDict["body"])
            
            self.arrListBeans.append(bean)
        }
        
    }
    
    func ServerCallFailed(_ errorObject: String, name: ServerCallName) {
        self.hideHud()
        print("\n\n\n\n\n Error FROM VIEW-CONTROLLER ---> \n\n")
        print(errorObject)
    }
}

//MARK: -  UITableViewDataSource, UITableViewDelegate
extension ListVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListBeans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tblView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
     
        let bean = arrListBeans[indexPath.row]
        cell.lblTitle.text = bean.title
        
        let imgWidth = cell.bounds.size.width + CGFloat(indexPath.row)  /// 10)
        
        let URL_IMAGE = "https://picsum.photos/\(imgWidth)/\(CELL_HEIGHT)/?random"
        if let theURL = URL(string: URL_IMAGE) {
            cell.imgView.sd_setImage(with: theURL, placeholderImage: nil, options: .highPriority)
        }
        
        return cell
    }
}
