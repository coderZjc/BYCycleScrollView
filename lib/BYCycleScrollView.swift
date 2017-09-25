//
//  BYSlideView2.swift
//  Demo
//
//  Created by Sina on 2017/9/21.
//  Copyright © 2017年 Sina. All rights reserved.
//
/*
 *使用说明
 *1、可供外部调用的属性：imagesArray、timeInterval、delegate（代理视情况使用）、pageTintColor、currentPageTintColor
 *2、可供外部调用的方法：public func setUpPageControl(normalImage:UIImage,currentImage:UIImage,itemSpace:CGFloat)
 *3、如果需要知道点击了那张图片用于后期处理，可实现相关的代理： func didTapped(index:NSInteger)
 */

import UIKit

//MARK: 自定义代理
@objc protocol BYCycleScrollViewDelegate:NSObjectProtocol
{
    @objc optional func didTapped(index:NSInteger)
}


class BYCycleScrollView: UIView,BYScrollViewDelegate
{
    //MARK:---------------------------
    //MARK: 供外部赋值的属性
    weak var delegate: BYCycleScrollViewDelegate?          //代理
    
    public var imageURLStrArray: [String]?                           //图片URL数组
    {
        didSet
        {
            scrollView?.imageURLArray=imageURLStrArray
            pageControl?.numberOfPages=(imageURLStrArray?.count)!
        }
    }
    
    public var imagesArray: [UIImage]?                               //图片数组
    {
        didSet
        {
            scrollView?.imagesArray=imagesArray
            pageControl?.numberOfPages=(imagesArray?.count)!
        }
    }

    public var timeInterval: TimeInterval?                           //轮播时间间隔
    {
        didSet
        {
            scrollView?.timeInterval=timeInterval!
        }
    }
    public var pageTintColor: UIColor?
    {
        didSet
        {
            pageControl?.pageIndicatorTintColor=pageTintColor
        }
    }
    public var currentPageTintColor: UIColor?
    {
        didSet
        {
            pageControl?.currentPageIndicatorTintColor=currentPageTintColor
        }
    }
    
    
    
    //MARK: 内部私有对象
    private var scrollView: BYScrollView?
    private var pageControl: BYPageControl?
    private var indexNum: Int?
    
    //MARK:  复写初始化方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        self.addScrollViewaAndPageControl()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 添加ScrollView和PageControl
    private func addScrollViewaAndPageControl()
    {
        //添加ScrollView
        let view = BYScrollView.init(frame: self.bounds)
        self.addSubview(view)
        view.customDelegate=self
        scrollView=view
        
        //添加PageControl
        let width: CGFloat = 100
        let height: CGFloat = 20
        let page = BYPageControl.init(frame: CGRect.init(x: (self.frame.size.width-width)/2, y: (self.frame.size.height-height), width: width, height: height))
        self.addSubview(page)
        pageControl=page
    }
    
    
    //MARK: BYScrollViewDelegate（代理）
    internal func didIndexChanged(index:NSInteger)
    {
        indexNum=index
        pageControl?.currentPage=index
        //print("下标改变了=\(index)")
    }
    
    
    //MARK: 自定义pageControl的图片和间距
    public func setUpPageControl(normalImage:UIImage,currentImage:UIImage,itemSpace:CGFloat)
    {
        if pageControl != nil
        {
            pageControl?.setUp(pageImage: normalImage, currentPageImage: currentImage, space: itemSpace)
        }
    }
    
    
    
    
    
    //MARK: 复写点击方法，实现自定义代理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        if let num=indexNum
        {
            self.delegate?.didTapped!(index: num)
        }
    }
    
    
    
    
    deinit
    {
        print("\(type(of: self))对象销毁了")
    }
    

}
