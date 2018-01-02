//
//  UITableView+Extension.swift
//  MagicUsageOfContentSize
//
//  Created by 李云鹏 on 2018/1/2.
//  Copyright © 2018年 Island. All rights reserved.
//

import UIKit

extension UITableView {
    /* 关联的 key */
    static let shouldScrollAssociatedKey = UnsafeRawPointer(bitPattern: "UIButton.AssociatedKey.shouldScroll".hashValue)!
    /* 新增的属性 */
    var shouldScroll: Bool {
        set {
            let oldValue = objc_getAssociatedObject(self, UITableView.shouldScrollAssociatedKey) as? Bool
            objc_setAssociatedObject(self, UITableView.shouldScrollAssociatedKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if let oldValue = oldValue, newValue != oldValue {
                reloadData()
            }
        }
        get {
            let shouldScroll = objc_getAssociatedObject(self, UITableView.shouldScrollAssociatedKey) as? Bool
            return shouldScroll ?? true
        }
    }
    /* 重写 contentSize */
    open override var contentSize: CGSize {
        didSet {
            if !shouldScroll && contentSize != bounds.size {
                contentSize = bounds.size
            }
        }
    }
}
