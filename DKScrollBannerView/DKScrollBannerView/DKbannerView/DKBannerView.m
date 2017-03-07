//
//  DKBannerView.m
//  DKScrollBannerView
//
//  Created by duke on 16/7/18.
//  Copyright © 2016年 duke. All rights reserved.
//

#import "DKBannerView.h"
#import "UIImageView+WebCache.h"

@interface DKBannerView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    /**下载图片*/
    NSMutableArray *_downImageArray;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) CGRect ScrollRect;

@end

@implementation DKBannerView

static NSString *identifier = @"cell";
static NSInteger pageCount = 1000;

#pragma mark --- 初始化方法
- (instancetype)initWithCurrentVC:(UIViewController *)viewController WithRect:(CGRect)rect imageArrays:(NSArray *)images{
    
    if (self == [super init]) {
        [viewController.view addSubview:self.view];
        [viewController addChildViewController:self];
        
        self.imagesArray = images;
        self.ScrollRect = rect;
        self.view.frame = rect;
        
        if ([self.imagesArray[0] isKindOfClass:[NSURL class]]) {
            [self downloadImage];
        }
        [self.view addSubview:self.collectionView];
        [self.view addSubview:self.pageControl];
        self.collectionView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        self.pageControl.frame = CGRectMake(0, rect.size.height-20, rect.size.width, 20);
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(self.imagesArray.count*pageCount)/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    return self;
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        //初始化collectionView
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.ScrollRect.size.width, self.ScrollRect.size.height) collectionViewLayout:layout];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UIPageControl *)pageControl{
    
    if (!_pageControl) {
        //初始化PageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.ScrollRect.size.height-25, self.ScrollRect.size.width, 25)];
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:137/255.0 blue:19/255.0 alpha:1];
        self.pageControl.userInteractionEnabled = NO;
        //        self.pageControl.backgroundColor = [UIColor redColor];
        self.pageControl.numberOfPages = self.imagesArray.count;
        self.pageControl.currentPage = 0;
    }
    return _pageControl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark --- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imagesArray.count * pageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.ScrollRect.size.width, self.ScrollRect.size.height)];
    // 判断图片来源
    if ([self.imagesArray[0] isKindOfClass:[NSURL class]]) {
        imageView = _downImageArray[indexPath.row %self.imagesArray.count];
    }else{
        imageView.image = [UIImage imageNamed:self.imagesArray[indexPath.row % self.imagesArray.count]];
        //    imageView = self.imagesArray[indexPath.row % self.imagesArray.count];
    }
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [cell.contentView addSubview:imageView];
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(self.ScrollRect.size.width, self.ScrollRect.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self .delegate respondsToSelector:@selector(clickImage: WithIndex:)]) {
        [self.delegate clickImage:self WithIndex:indexPath.row];
    }
}

#pragma mark --- 图片滚动
//添加定时器
- (void)addTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}
//删除定时器
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}
//下一张图片
- (void)nextImage{
    NSIndexPath *curIndex = [[self.collectionView indexPathsForVisibleItems]lastObject];
    NSInteger nextImage = curIndex.item + 1;
    NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:nextImage inSection:curIndex.section];
    [self.collectionView scrollToItemAtIndexPath:nextIndex atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}
#pragma mark --- 用户拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{ //开始拖动
    NSLog(@"x --- %f",scrollView.contentOffset.x);
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{ //停止拖动
    NSLog(@"x === %f",scrollView.contentOffset.x);
    [self addTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{ // 设置页码
    
    int page = (int)(scrollView.contentOffset.x/scrollView.frame.size.width+0.5)%self.imagesArray.count;
    self.pageControl.currentPage = page;
}

//释放定时器
- (void)viewWillDisappear:(BOOL)animated{
    [self removeTimer];
}
- (void)viewDidAppear:(BOOL)animated{
    if (!_timer) {
        [self addTimer];
    }
}

// (是网络图片)下载图片
- (void)downloadImage{
    
    NSLog(@"imagesArray = %@",self.imagesArray);
    _downImageArray = [NSMutableArray array];
    CGSize size = CGSizeMake(self.ScrollRect.size.width, self.ScrollRect.size.height);
    for (NSURL *imgUrl in self.imagesArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.ScrollRect.size.width, self.ScrollRect.size.height)];
        UIImage *placehoder = [UIImage imageNamed:@"timeline_image_loading.png"];
        NSLog(@"url = %@",imgUrl);
        [imageView sd_setImageWithURL:imgUrl placeholderImage:placehoder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"iamgeURL = %@",imageURL);
        }];
        imageView.image = [self imageWithImageSimple:imageView.image scaledToSize:size];
        [_downImageArray addObject:imageView];
    }
    
}
// 压缩图片
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
