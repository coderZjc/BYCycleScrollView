//
//  BYPageControl.swift
//  Demo
//
//  Created by Sina on 2017/9/21.
//  Copyright © 2017年 Sina. All rights reserved.
//

import UIKit

class BYPageControl: UIPageControl
{
    //MARK: 私有属性
    private var itemSpace: CGFloat?
    private var isCustom: Bool = false
    
    //MARK: 复写初始化方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        self.hidesForSinglePage=true
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: 设置信息
    public func setUp(pageImage:UIImage,currentPageImage:UIImage,space:CGFloat)
    {
        self.setValue(pageImage, forKey: "pageImage")
        self.setValue(currentPageImage, forKey: "currentPageImage")
        itemSpace=space
        isCustom=true
    }
    
    
    
    //MARK: 设置Frame
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if isCustom
        {
            if let space = itemSpace
            {
                //获取item个数
                let self_width = self.frame.size.width
                let self_height = self.frame.size.height
                
                let count=self.numberOfPages
                let item_width:CGFloat = 20
                let space_x:CGFloat = (self_width-(CGFloat(count-1)*space+item_width*CGFloat(count)))/2   //x头间距
                
                for (index,item) in self.subviews.enumerated()
                {
                    item.frame=CGRect.init(x: (space_x+(item_width+space)*CGFloat(index)), y: (self_height-item_width)/2, width: item_width, height: item_width)
                }
            }

        }
    }
    
    
    
    deinit
    {
        print("\(type(of: self))对象销毁了")
    }


}
