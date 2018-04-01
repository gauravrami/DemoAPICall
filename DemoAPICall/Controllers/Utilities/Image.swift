//
//  Image.swift


import Foundation
import UIKit

extension UIImage {
    // Loads image asynchronously
    class func loadFromPath(_ path: String, callback:@escaping (UIImage) -> Void ) {
        
        
        DispatchQueue.global().async {
            let escapedUrl = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            guard let pathUrl = URL(string: escapedUrl!) else {
                DispatchQueue.main.async(execute: {
                    callback(UIImage())
                })
                return
            }
            
            if let imageData = try? Data(contentsOf: pathUrl) {
                let image = UIImage(data: imageData)
                if image != nil {
                    DispatchQueue.main.async(execute: {
                        callback(image!)
                    })
                }
            }
        }
    }
    
    class func loadFromPath(_ path: String, indexPath:IndexPath, callback: @escaping (UIImage,IndexPath)->()) {
        
        DispatchQueue.global().async {
            if let escapedUrl = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                if let pathUrl = URL(string: escapedUrl) {
                    let imageData = try? Data(contentsOf: pathUrl)
                    //            let imageData = NSData(contentsOfFile: path)
                    let image = UIImage(data: imageData!)
                    if image != nil {
                        DispatchQueue.main.async(execute: {
                            callback(image!,indexPath)
                        })
                    }
                }
                else {
                    callback(UIImage(),indexPath)
                }
            } else {
                callback(UIImage(),indexPath)
            }
        }
    }
}

extension UIImage {
    convenience init(view: UIView) {
//        UIGraphicsBeginImageContext(view.frame.size)
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage!)!)
    }
}

func resizeImageWithUIKit(_ image: UIImage, newWidth: CGFloat) -> UIImage {
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func resizeImageWithCoreGraphics(_ image: UIImage, newWidth: CGFloat) -> UIImage {
    let cgImage = image.cgImage
    let width = (cgImage?.width)! / 2
    let height = (cgImage?.height)! / 2
    let bitsPerComponent = cgImage?.bitsPerComponent
    let bytesPerRow = cgImage?.bytesPerRow
    let colorSpace = cgImage?.colorSpace
    let bitmapInfo = cgImage?.bitmapInfo
    let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent!, bytesPerRow: bytesPerRow!, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
    context!.interpolationQuality = CGInterpolationQuality.low
    context?.draw(cgImage!, in: CGRect(origin: CGPoint.zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))
    
    let scaledImage = context?.makeImage().flatMap { UIImage(cgImage: $0) }
    return scaledImage!
}

