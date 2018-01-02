//
//  ViewController.swift
//  MagicUsageOfContentSize
//
//  Created by 李云鹏 on 2017/12/27.
//  Copyright © 2017年 Island. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        showDetailButton.addTarget(self, action: #selector(showDetailButtonDidClick), for: .touchUpInside)
        view.addSubview(showDetailButton)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showDetailButton.frame = CGRect(x: 100, y: 300, width: 120, height: 35)
    }
    
    @objc func showDetailButtonDidClick() {
        let detailViewController = DetailViewController()
        detailViewController.show()
    }

    lazy var showDetailButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.purple
        button.setTitle("Show Detail", for: .normal)
        return button
    }()
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 隐藏详情页面
    }
}
