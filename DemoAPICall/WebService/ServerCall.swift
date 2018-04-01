//
//  ServerCall.swift

import UIKit
import Alamofire

//
//MARK: - Network Reachability Manager - GLOBAL Variables
let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
var isInternetAvailable = true


//
//MARK: - URL Constants.....
let URL_POSTS = "https://jsonplaceholder.typicode.com/posts"
//let URL_IMAGE = "https://loremflickr.com/340/140"
//let URL_IMAGE = "https://picsum.photos/340/140/?random"
let URL_PHOTO_ALBUM = "https://jsonplaceholder.typicode.com/photos"

//
//MARK: - enum
enum ServerCallName : Int {
    case ListOfPosts = 101,
    ListOfAlbums
}

enum HTTP_METHOD {
    case GET,
    POST
}

//
//MARK: - PROTOCOL
protocol ServerCallDelegate {
    func ServerCallSuccess(_ resposeObject: AnyObject, name: ServerCallName)
    func ServerCallFailed(_ errorObject:String, name: ServerCallName)
}


//
//MARK: - ServerCall CLASS
class ServerCall: NSObject {
    var delegateObject : ServerCallDelegate!
    
    // Shared Object Creation
    static let sharedInstance = ServerCall()
    
    //MARK: - Request Methods.
    // Make API Request WITHOUT Header Parameters
    func requestWithURL(_ httpMethod: HTTP_METHOD, urlString: String, delegate: ServerCallDelegate, name: ServerCallName) {
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.webservicequeue.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: nil)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.ServerCallFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
        
    }
    
    // Make API Request WITH Parameters
    func requestWithUrlAndParameters(_ httpMethod: HTTP_METHOD, urlString: String, parameters: [String : AnyObject], delegate: ServerCallDelegate, name: ServerCallName) {
        
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.webservicequeue.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: parameters)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                print("\n\n\n")
                                print(response.request ?? "")
                                print("\n")
                                print(parameters)
                                print("\n\n\n")
                                print(response.data as! NSData)
                                print("\n\n\n")
                                print(response)
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.ServerCallFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
    }
    
    // Make API Request WITH Header
    func requestWithUrlAndHeader(_ httpMethod: HTTP_METHOD, urlString: String, header: [String : String], delegate: ServerCallDelegate, name: ServerCallName) {
        self.delegateObject = delegate
        let methodOfRequest : HTTPMethod = (httpMethod == HTTP_METHOD.GET) ? HTTPMethod.get : HTTPMethod.post
        let queue = DispatchQueue(label: "com.webservicequeue.manager-response-queue", attributes: DispatchQueue.Attributes.concurrent)
        let request = Alamofire.request(urlString, method: methodOfRequest, parameters: nil, headers: header)
        request.responseJSON(queue: queue,
                             options: JSONSerialization.ReadingOptions.allowFragments) {
                                (response : DataResponse<Any>) in
                                // You are now running on the concurrent `queue` you created earlier.
                                print("Parsing JSON on thread: \(Thread.current) is main thread: \(Thread.isMainThread)")
                                
                                // To update anything on the main thread, just jump back on like so.
                                DispatchQueue.main.async {
                                    print("Am I back on the main thread: \(Thread.isMainThread)")
                                    if (response.result.isSuccess) {
                                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                                    }
                                    else if (response.result.isFailure) {
                                        self.delegateObject.ServerCallFailed((response.result.error?.localizedDescription)!, name: name)
                                    }
                                }
        }
    }
    
    
    
    //MARK:- Multi part request with parameters.
    /*
    func requestMultiPartWithUrlAndParameters(_ urlString: String, parameters: [String : AnyObject], image: UIImage, imageParameterName: String, imageFileName:String, delegate: ServerCallDelegate, name: ServerCallName) {
        
        self.delegateObject = delegate
        var imageData : Data!
        imageData = UIImagePNGRepresentation(image)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // The for loop is to append all parameters to multipart form data.
                for element in parameters.keys{
                    let strElement = String(element)
                    let strValueElement = parameters[strElement!] as! String
                    multipartFormData.append(strValueElement.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: strElement!)
                }
                
                // Append Image to multipart form data.
                multipartFormData.append(imageData, withName: imageParameterName, fileName: imageFileName + ".png", mimeType: "image/png")
            },
            to: urlString,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
//                        print(response.result.value!)
//                        print(response.data as! NSData)
                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.delegateObject.ServerCallFailed(encodingError.localizedDescription, name: name)
                }
            }
        )
    }
     */
    
    func requestMultiPartWithUrlAndParameters(_ urlString: String, parameters: [String : AnyObject], fileData: Data, fileParameterName: String, fileName:String, mimeType:String, delegate: ServerCallDelegate, name: ServerCallName) {
        
        self.delegateObject = delegate
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                // The for loop is to append all parameters to multipart form data.
                for element in parameters.keys{
                    let strElement = String(element)
                    let strValueElement = parameters[strElement!] as! String
                    multipartFormData.append(strValueElement.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: strElement!)
                }
                
                // Append Image to multipart form data.
                multipartFormData.append(fileData, withName: fileParameterName, fileName: fileName, mimeType: mimeType)
        },
            to: urlString,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress : Progress) in
                        print("upload completed ------->>>>>>>> \(progress.fractionCompleted)")
                    })
                    upload.responseJSON { response in
                        debugPrint(response)
//                        print(response.result.value!)
//                        print(response.data as! NSData)
                        self.delegateObject.ServerCallSuccess(response.result.value! as AnyObject, name: name)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    self.delegateObject.ServerCallFailed(encodingError.localizedDescription, name: name)
                }
        }
        )
    }

    /*
    func isInternetAvailabel() -> Bool {
        
        Alamofire.request("https://httpbin.org/get")
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case .failure(let error):
                    print(error)
                }
        }
    }
     */
}

//MARK:- GLOBAL Method. Out of ServerCall Class.
func isInternetAvailabel() -> Bool {
    reachabilityManager?.startListening()
    reachabilityManager?.listener = { status in
        print("Network Status Changed: \(status)")
        isInternetAvailable = true
        switch status {
        case .notReachable:
            //Show error state
            isInternetAvailable = false
            break
        case .reachable(.ethernetOrWiFi):
            break
        case .reachable(.wwan):
            break
        case .unknown:
            //Hide error state
            break
        }
    }
    return isInternetAvailable
}
