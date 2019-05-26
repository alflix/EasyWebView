//
//  UIImage+.swift
//  GGUI
//
//  Created by John on 2019/3/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

public extension UIImage {
    typealias KB = Int

    /// 对图片染色
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - blendMode: 渲染默认
    /// - Returns: 新的图片
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }

    /// 裁剪并压缩到一定的体积
    ///
    /// - Parameter size: 单位 KB
    /// - Returns: 图片 data
    func imageCropAndResize(to size: KB) -> Data {
        var image = self
        var imageData = image.jpegData(compressionQuality: 0.9)!
        while imageData.count/1024 > size {
            image = image.scaled(toWidth: image.size.width/2) ?? image
            imageData = image.jpegData(compressionQuality: 0.9)!
        }
        return imageData
    }

    /// 通过图片创建 NSTextAttachment
    ///
    /// - Parameters:
    ///   - xOffset: x 偏移量
    ///   - yOffset: y 偏移量
    ///   - width: 图片宽度，不设置的话为 image 自身宽度
    /// - Returns: NSTextAttachment
    func attachmentString(xOffset: CGFloat = 0, yOffset: CGFloat = 0, width: CGFloat = 0) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = self
        if width > 0 {
            imageAttachment.bounds = CGRect(x: xOffset, y: yOffset, width: width, height: width)
        } else {
            imageAttachment.bounds = CGRect(x: xOffset, y: yOffset,
                                            width: imageAttachment.image!.size.width,
                                            height: imageAttachment.image!.size.height)
        }
        let imageString = NSAttributedString(attachment: imageAttachment)
        return imageString
    }
}
