//
//  UIImageView+.swift
//  GGUI
//
//  Created by John on 2018/9/26.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit
import AlamofireImage

public extension UIImageView {
    /// 设置圆角的网络资源头像
    ///
    /// - Parameters:
    ///   - urlString: 图像 url string
    ///   - size: 尺寸，默认为 UIImageView 的宽度
    ///   - placeholderImage: 占位图片，可以通过全局设置 GGUI.ImageDownloader.avatarPlaceholderImage 或
    ///     GGUI.ImageDownloader.avatarPlaceholderTintColor（只有颜色）
    ///   - completion: 设置完成
    func setAvatarImage(with urlString: String?,
                        size: CGFloat = 0,
                        placeholderImage: UIImage? = nil,
                        completion: VoidBlock? = nil) {
        let diameter = (size >= 0) ? size : width
        let profileImageSize = CGSize(width: diameter, height: diameter)
        var placeholder: UIImage?
        if let placeholderImage = placeholderImage {
            placeholder = placeholderImage
        } else if let placeholderImage = GGUI.ImageDownloader.avatarPlaceholderImage {
            placeholder = placeholderImage
        } else {
            placeholder = UIImage(color: GGUI.ImageDownloader.avatarPlaceholderTintColor, size: profileImageSize).withRoundedCorners(radius: diameter/2)
        }
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = placeholder
            completion?()
            return
        }
        var filter: ImageFilter
        if diameter > 0 {
            filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: profileImageSize, radius: diameter/2)
        } else {
            filter = CircleFilter()
        }
        _ = af_setImage(
            withURL: url,
            placeholderImage: placeholder,
            filter: filter,
            imageTransition: .crossDissolve(0.2)
        ) { (_) in
            completion?()
        }
    }

    /// 设置网络资源图片
    ///
    /// - Parameters:
    ///   - urlString: 图像 url string
    ///   - placeholderImage: 占位图片，可以通过全局设置 GGUI.ImageDownloader.placeholderImage 或
    ///     GGUI.ImageDownloader.placeholderTintColor（只有颜色）
    ///   - failureImage: 下载失败的图片，可以通过全局设置 GGUI.ImageDownloader.avatarPlaceholderImage，为空时用 placeholderImage
    ///   - completion: 设置完成
    func setImage(with urlString: String?,
                  placeholderImage: UIImage? = nil,
                  failureImage: UIImage? = nil,
                  completion: VoidBlock? = nil,
                  filter: ImageFilter? = nil) {
        var placeholder: UIImage?
        if let placeholderImage = placeholderImage {
            placeholder = placeholderImage
        } else if let placeholderImage = GGUI.ImageDownloader.placeholderImage {
            placeholder = placeholderImage
        } else {
            placeholder = UIImage(color: GGUI.ImageDownloader.placeholderTintColor, size: size)
        }
        let failure = failureImage ?? GGUI.ImageDownloader.failureImage
        guard let urlString = urlString, let url = URL(string: urlString) else {
            image = failure ?? placeholder
            completion?()
            return
        }
        _ = af_setImage(withURL: url, placeholderImage: placeholder, filter: filter, completion: { [weak self] (response) in
            if response.value == nil {
                self?.image = failure ?? placeholder
            }
            completion?()
        })
    }
}
