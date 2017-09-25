//
//  ViewController.swift
//  BYCycleScrollViewDemo
//
//  Created by Sina on 2017/9/25.
//  Copyright © 2017年 Sina. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BYCycleScrollViewDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        
        self.loadFromNetwork()
        
        self.loadFromLocalFile()
    }
    
    
    
    
    //MARK: 从网络加载轮播图
    private func loadFromNetwork()
    {
        let view = BYCycleScrollView.init(frame: CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 200))
        self.view.addSubview(view)
        view.delegate=self
        view.timeInterval=2
        view.setUpPageControl(normalImage: #imageLiteral(resourceName: "未选中的点"), currentImage: #imageLiteral(resourceName: "选中的点"), itemSpace: 0)
        let str0 = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=284152039,3597926587&fm=27&gp=0.jpg"
        let str1="https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506334806831&di=969b5039a4155ca17ef102b1da8a9427&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201407%2F17%2F20140717203644_KzdWV.thumb.700_0.jpeg"
        let str2 = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1506334827851&di=f647f0a758e113253225693c3fe89619&imgtype=0&src=http%3A%2F%2Fwenwen.soso.com%2Fp%2F20100820%2F20100820081702-653885667.jpg"
        view.imageURLStrArray=[str0,str1,str2]
    }
    
    
    
    
    
    //MARK: 从本地加载轮播图
    private func loadFromLocalFile()
    {
        let view = BYCycleScrollView.init(frame: CGRect.init(x: 0, y: 350, width: UIScreen.main.bounds.size.width, height: 200))
        self.view.addSubview(view)
        view.delegate=self
        view.timeInterval=2
        view.imagesArray=[#imageLiteral(resourceName: "image0"),#imageLiteral(resourceName: "image1"),#imageLiteral(resourceName: "image2"),#imageLiteral(resourceName: "image3")]
        view.pageTintColor=UIColor.lightGray
        view.currentPageTintColor=UIColor.orange
    }
    
    
    
    
    
    
    //MARK: 轮播图代理
    func didTapped(index:NSInteger)
    {
        print("实现代理，下标=\(index)")
    }

    
    
}

