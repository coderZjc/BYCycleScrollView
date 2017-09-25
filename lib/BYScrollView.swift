//
//  BYCarouselView.swift
//  Demo
//
//  Created by Sina on 2017/9/21.
//  Copyright © 2017年 Sina. All rights reserved.
//

import UIKit
import SDWebImage

//MARK: 自定义代理
@objc protocol BYScrollViewDelegate:NSObjectProtocol
{
    @objc optional func didIndexChanged(index:NSInteger)
}

class BYScrollView: UIScrollView,UIScrollViewDelegate
{
    //MARK:---------------------------
    //MARK: 供外部赋值的属性
    weak var customDelegate: BYScrollViewDelegate?              //代理
    public var imageURLArray: [String]?                           //图片URL数组
    {
        didSet
        {
            self.downloadImages(imageURLArray!)
        }
    }
    public var imagesArray: [UIImage]?                         //图片数组，初始化对象后要对该属性赋值
    {
        didSet
        {
            self.setImagesToImageViews()
            guard imagesArray?.count==1 else
            {
                //当图片只有一张的时候就不需要设置计时器了
                self.createTimer()
                return
            }
        }
    }
    public var timeInterval: TimeInterval = 5                   //轮播时间间隔，默认是5秒
    
    
    //MARK: 内部私有对象
    private var currentIndex: Int = 0                         //当前下标值，默认是0
    {
        didSet
        {
            self.customDelegate?.didIndexChanged!(index: currentIndex)
        }
    }
    private var imageView1: UIImageView?
    private var imageView2: UIImageView?
    private var imageView3: UIImageView?
    private var timer: Timer?                                          //计时器，用于图片轮播计时
    
    
    //MARK:---------------------------
    //MARK: 复写初始化方法
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        self.isScrollEnabled=true
        self.isPagingEnabled=true
        self.bounces=false
        self.showsVerticalScrollIndicator=false
        self.showsHorizontalScrollIndicator=false
        self.delegate=self
        self.createLoopImageView()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    

     //MARK: 复写removeFromSuperview方法，在这里销毁计时器，不然无法释放该对象
    override func removeFromSuperview()
    {
        super.removeFromSuperview()
        self.destroyObject()
    }
    
    
    //MARK: 复写点击方法，将手势传递给父类View层
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        self.next?.touchesBegan(touches, with: event)
    }
    
    
    //MARK:---------------------------
    //MARK: 创建三个UIImageView用于循环轮播
    private func createLoopImageView()
    {
        let count:Int = 3  //设置默认张数
        if count>=1
        {
            for num in 1...count
            {
                let imageView = UIImageView()
                self.addSubview(imageView)
                let width:CGFloat = self.frame.size.width
                let height:CGFloat = self.frame.size.height
                imageView.frame=CGRect.init(x: width*CGFloat(num-1), y: 0, width: width, height: height)
                self.contentSize=CGSize.init(width: width*CGFloat(count), height: height)
                if num == 1
                {
                    imageView1=imageView
                }
                if num == 2
                {
                    imageView2=imageView
                }
                if num == 3
                {
                    imageView3=imageView
                }
            }
        }
        
    }
    
    
    //MARK: 根据URL下载图片
    private func downloadImages(_ urlsArray:[String])
    {
        if let num = imageURLArray?.count
        {
            let pureColorImage = self.createPureColorImage()
            self.imagesArray=[UIImage](repeatElement(pureColorImage, count: num))
            for (index,urlStr) in urlsArray.enumerated()
            {
                let imageURL = URL.init(string: urlStr)
                let manager = SDWebImageManager.shared()
                weak var weakSelf = self
                
                manager.cachedImageExists(for: imageURL, completion: { (isExist) in
                    if isExist
                    {
                        print("从缓存中取图片:\(index)")
                        weakSelf?.imagesArray![index]=(manager.imageCache?.imageFromCache(forKey: imageURL?.absoluteString))!
                    }
                    else
                    {
                        print("缓存中没有找到，下载图片:\(index)")
                        
                        manager.imageDownloader?.downloadImage(with: imageURL, options: SDWebImageDownloaderOptions.lowPriority, progress: nil, completed: { (image, data, error, finished) in
                            if let newImage = image
                            {
                                manager.imageCache?.store(newImage, forKey: imageURL?.absoluteString, completion: {
                                    print("缓存图片\(index)")
                                })
                                if (index<(weakSelf?.imagesArray?.count)!)
                                {
                                    weakSelf?.imagesArray![index]=newImage
                                }
                            }
                            
                        })
                    }
                })
                
                
            }
        }
        
        
    }
    
    
     //MARK: 创建纯色图片
    private func createPureColorImage() -> UIImage
    {
        let imageSize:CGSize = CGSize.init(width: self.frame.size.width, height: self.frame.size.height)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        UIColor.white.set()
        UIRectFill(CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let pureColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return pureColorImage!
    }
    
    //MARK: 图片赋值
    private func setImagesToImageViews()
    {
        if let count = imagesArray?.count
        {
            if count > 0
            {
                if (count == 1)
                {
                    self.imageView2?.image=self.imagesArray?[0]
                    self.isScrollEnabled=false  //当只有一张轮播图的时候禁止滚动
                }
                else
                {
                    self.isScrollEnabled=true
                    
                    if (currentIndex<count)
                    {
                        self.imageView2?.image=self.imagesArray?[currentIndex]
                    }
                    
                    if (currentIndex+1<count)
                    {
                        self.imageView3?.image=self.imagesArray?[currentIndex+1]
                    }
                    else
                    {
                        self.imageView3?.image=self.imagesArray?[0]
                    }
                    
                    if (currentIndex-1>=0)
                    {
                        self.imageView1?.image=self.imagesArray?[currentIndex-1]
                    }
                    else
                    {
                        self.imageView1?.image=self.imagesArray?[count-1]
                    }
                }
                //设置完图片后回到第二张UIImageView
                self.setContentOffset(CGPoint.init(x: self.frame.size.width, y: 0) , animated: false)
            }
            else
            {
                print("Error: 请先设置图片数组")
            }
        }
        
    }
    
    
    
    //MARK:---------------------------
    //MARK: 创建计时器
    private func createTimer()
    {
        if timer == nil
        {
            timer=Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(startSlide), userInfo: nil, repeats: true)
        }
        self.startTimer()
    }
    
    //MARK: 开启定时器
    @objc private func startTimer()
    {
        //注意：这里不能使用 Date.distantPast 来开启定时器，不然会马上触发startSlide的方法，必须从现在的时间延后一个计时间隔
        let now = Date()
        timer?.fireDate=Date.init(timeInterval: timeInterval, since: now)
        //print("开启定时器")
    }
    
    //MARK: 暂停定时器
    private func pauseTimer()
    {
        timer?.fireDate=Date.distantFuture
        //print("暂停定时器")
    }
    
    //MARK: 开始轮播
    @objc private func startSlide()
    {
        let width = self.frame.size.width
        self.setContentOffset(CGPoint.init(x: width*2, y: 0), animated: true)
    }
    
    
    //MARK:---------------------------
    //MARK: UIScrollViewDelegate（代理）
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        self.pauseTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.dealWithScrollView(scrollView)
        self.startTimer()
    }
    
    internal func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView)
    {
        self.dealWithScrollView(scrollView)
    }
    
    
     //MARK: 处理scrollView
    @objc private func dealWithScrollView(_ scrollView: UIScrollView)
    {
        let offset = scrollView.contentOffset
        let width = scrollView.frame.size.width
        let index: Int = Int(offset.x/width)
        if index==0
        {
            if currentIndex>0
            {
                currentIndex=currentIndex-1
            }
            else
            {
                currentIndex=(imagesArray?.count)!-1
            }
            
        }
        if index==2
        {
            if currentIndex<((imagesArray?.count)!-1)
            {
                currentIndex=currentIndex+1
            }
            else
            {
                currentIndex=0
            }
        }
        self.setImagesToImageViews()
        
        //print("滚动视图减速完成，滚动将停止。当前轮播图下标=\(currentIndex)")
    }
    
    
    //MARK:---------------------------
    //MARK: 销毁对象操作
    private func destroyObject()
    {
        //销毁计时器
        guard let myTimer=self.timer else
        {
            return
        }
        myTimer.invalidate()
    }
    
    
    deinit
    {
        print("\(type(of: self))对象销毁了")
    }
}
