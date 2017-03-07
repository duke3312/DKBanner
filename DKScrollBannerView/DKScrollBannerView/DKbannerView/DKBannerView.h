//
//  DKBannerView.h
//  DKScrollBannerView
//
//  Created by duke on 16/7/18.
//  Copyright © 2016年 duke. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DKBannerView;

@protocol DKBannerDelegate <NSObject>

@optional //点击到的图片及其位置
- (void)clickImage:(DKBannerView *)bannerView WithIndex:(NSInteger)index;

@end

@interface DKBannerView : UIViewController

//* 代理 */
@property (nonatomic, weak)id<DKBannerDelegate> delegate;
//* 设置pageControl */
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

//* 初始化方法 */
- (instancetype)initWithCurrentVC:(UIViewController *)viewController WithRect:(CGRect)rect imageArrays:(NSArray *)images;

@end
