//
//  ViewController.m
//  DKScrollBannerView
//
//  Created by duke on 16/7/18.
//  Copyright © 2016年 duke. All rights reserved.
//

#import "ViewController.h"
#import "DKBannerView.h"

@interface ViewController ()<DKBannerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *imageMutableArr = @[@"http://tuempetslb.kss.ksyun.com/pics/dog/qianqian_banner_1.png",
                                 @"http://tuempetslb.kss.ksyun.com/pics/dog/qianqian_banner_2.png",
                                 @"http://tuempetslb.kss.ksyun.com/pics/dog/qianqian_banner_3.png",
                                 @"http://tuempetslb.kss.ksyun.com/pics/dog/qianqian_banner_4.png",
                                 @"http://tuempetslb.kss.ksyun.com/pics/dog/qianqian_banner_5.png"];
    NSMutableArray *urlArr = [NSMutableArray array];
    for (NSString *str in imageMutableArr) {
        NSURL *imgUrl = [NSURL URLWithString:str];
        [urlArr addObject:imgUrl];
    }
    DKBannerView *banner = [[DKBannerView alloc] initWithCurrentVC:self WithRect:CGRectMake(0, 100, self.view.frame.size.width, 300) imageArrays:urlArr];
    banner.delegate = self;
    
//    NSArray *array = @[@"fbb01",@"fbb02",@"fbb03",@"fbb02",@"fbb01"];
//    DKBannerView *banner = [[DKBannerView alloc] initWithCurrentVC:self WithRect:CGRectMake(0, 100, self.view.frame.size.width, 300) imageArrays:array];
//    banner.delegate = self;
    
}

- (void)clickImage:(DKBannerView *)bannerView WithIndex:(NSInteger)index{
    
    NSLog(@"点击了%ld图片",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
