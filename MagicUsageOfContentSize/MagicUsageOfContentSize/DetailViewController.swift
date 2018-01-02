//
//  DetailViewController.swift
//  MagicUsageOfContentSize
//
//  Created by 李云鹏 on 2017/12/27.
//  Copyright © 2017年 Island. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    enum State {
        case hide
        case small
        case middle
        case large
        
        /// 每种状态下 window 对应的 transformTy
        var transformTy: CGFloat {
            switch self {
            case .hide:
                return 0
            case .small:
                return -UIScreen.main.bounds.height / 4.0
            case .middle:
                return -UIScreen.main.bounds.height / 3.0 * 2.0
            case .large:
                return -UIScreen.main.bounds.height
            }
        }
    }
    
    enum ScrollType {
        case window
        case tableView
    }

    var lastWindowTransformTy: CGFloat = 0
    
    var scrollType = ScrollType.window
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let panGuestureRecognizer = tableView.panGestureRecognizer
        panGuestureRecognizer.addTarget(self, action: #selector(pan(_:)))
        
        view.addSubview(tableView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: view.bounds.height - 20)
    }
    
    func show() {
        /* 显示 window */
        window.rootViewController = self
        window.makeKeyAndVisible()
        /* 改变 window 的 transform */
        UIView.animate(withDuration: -Double(State.small.transformTy / UIScreen.main.bounds.height)) {
            self.window.transform = CGAffineTransform(translationX: 0, y: State.small.transformTy)
        }
    }
    
    lazy var window: UIWindow  = UIWindow(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.red
        tableView.dataSource = self
        tableView.delegate = self
        tableView.shouldScroll = false
        return tableView
    }()
}

extension DetailViewController {
    
    /// 控制 tableView 和 window 的滑动
    @objc func pan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            /* 记录 window 上次滚动结束时的 tansformTy */
            lastWindowTransformTy = window.transform.ty
        } else if gestureRecognizer.state == .changed {
            if scrollType == .window { /* 改变 window 的 transform */
                let panOffsetY = gestureRecognizer.translation(in: window).y + lastWindowTransformTy
                tableView.contentOffset = .zero
                if panOffsetY > -UIScreen.main.bounds.height {
                    window.transform = CGAffineTransform(translationX: 0, y: panOffsetY)
                } else { /* 切换到 滚动 tableView */
                    tableView.shouldScroll = true
                    scrollType = .tableView
                }
            } else { /* 滚动 tableView */
                let contentOffsetY = tableView.contentOffset.y
                if contentOffsetY < 0 { /* 切换到改变 window 的 transform */
                    tableView.shouldScroll = false
                    scrollType = .window
                }
            }
        } else if gestureRecognizer.state == .ended {
            /* 根据结束拖动时 window 的 transform 来确定当前的 state */
            let windowTransformTy = window.transform.ty
            if windowTransformTy > State.small.transformTy * 0.5 { /* hide */
                setWindowTransformTy(of: .hide, ty: windowTransformTy)
            } else if windowTransformTy <= State.small.transformTy / 2.0 && windowTransformTy > State.small.transformTy * (1 + 0.5) { /* small */
                setWindowTransformTy(of: .small, ty: windowTransformTy)
            } else if windowTransformTy <= State.small.transformTy * (1 + 0.5) && windowTransformTy > State.middle.transformTy + (State.large.transformTy - State.middle.transformTy) * 0.5 { /* middle */
                setWindowTransformTy(of: .middle, ty: windowTransformTy)
            } else { /* large */
                setWindowTransformTy(of: .large, ty: windowTransformTy)
            }
        }
    }
    /* 设置 window 的 transform */
    func setWindowTransformTy(of state: State, ty: CGFloat) {
        UIView.animate(withDuration: Double(abs(state.transformTy - ty) / UIScreen.main.bounds.height), animations: {
            self.window.transform = CGAffineTransform(translationX: 0, y: state.transformTy)
        })
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}
