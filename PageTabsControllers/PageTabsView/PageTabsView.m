//
//  PageTabsView.m
//  PageTabsControllers
//
//  Created by admin on 31.05.17.
//  Copyright © 2017 ag. All rights reserved.
//

#import "PageTabsView.h"


#define Slider_Height                   3
#define SlideBar_Height                 42
#define SlideView_Height                42

#define SCREEN_WIDTH                    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT                   ([UIScreen mainScreen].bounds.size.height)


@interface PageTabsView () <UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger numberOfItems;

@property (strong, nonatomic) NSArray *namesOfItems;

@property (strong, nonatomic) UIView *slideBar;

@property (strong, nonatomic) UIView *slider;

@property (strong, nonatomic) UIScrollView *contentScrollView;

@property (strong, nonatomic) NSMutableArray *buttonsArray;

@property (strong, nonatomic) NSMutableArray *childControllersArray;

@property (strong, nonatomic) UIScrollView *headerScrollView;


@end


@implementation PageTabsView{
    
    struct {
        unsigned numberOfItemsInPageTabsView:1;
        unsigned nameOfItemInPageTabsView:1;
        unsigned contentViewControllerInPageTabsView:1;
    }_dataSourceHas;
    
    struct{
        unsigned didSelectItemAtIndex;
    }_delegateHas;
}

@synthesize useFullWidth;
@synthesize fontOfSlider=_fontOfSlider;
@synthesize titleColor=_titleColor;
@synthesize colorOfSlider=_colorOfSlider;
@synthesize colorOfSlideView=_colorOfSlideView;
@synthesize selectedTitleColor=_selectedTitleColor;

#pragma mark - setter (Override)

-(void)setDelegate:(id<PageTabsViewDelegate>)delegate{
    _delegate=delegate;
    _delegateHas.didSelectItemAtIndex= [delegate respondsToSelector:@selector(pageTabsView:didSelectItemAtIndex:)];
}

-(void)setDataSource:(id<PageTabsViewDataSource>)dataSource{
    _dataSource=dataSource;
    _dataSourceHas.numberOfItemsInPageTabsView=[dataSource respondsToSelector:@selector(numberOfItemsInPageTabsView:)];
    _dataSourceHas.nameOfItemInPageTabsView=[dataSource respondsToSelector:@selector(nameOfItemInPageTabsView:AtIndex:)];
    _dataSourceHas.contentViewControllerInPageTabsView=[dataSource respondsToSelector:@selector(contentViewControllerInPageTabsView:AtIndex:)];
}

-(UIFont *)fontOfSlider{
    if (!_fontOfSlider){
        _fontOfSlider=[UIFont systemFontOfSize:15];
    }
    return _fontOfSlider;
}

-(UIColor *)titleColor{
    if (!_titleColor){
        _titleColor=[UIColor blackColor];
    }
    return _titleColor;
}

-(UIColor *)selectedTitleColor{
    
    if (!_selectedTitleColor){
        _selectedTitleColor = [UIColor lightGrayColor];
    }
    return _selectedTitleColor;
}

-(UIColor *)colorOfSlider{
    if (!_colorOfSlider){
        _colorOfSlider=[UIColor lightGrayColor];
    }
    return _colorOfSlider;
}

-(UIColor *)colorOfSlideView{
    if (!_colorOfSlideView){
        _colorOfSlideView=[UIColor whiteColor];
    }
    return _colorOfSlideView;
}

#pragma mark - life cycle

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self=[super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self customInit];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self configureData];
    [self addSubviews];
}

-(void) customInit {
    useFullWidth=NO;
    [self setBackgroundColor:[UIColor clearColor]];
    [self initData];
}

- (void)initData {
    
    _numberOfItems = 0;
    _namesOfItems = [NSMutableArray new];
    _buttonsArray = [NSMutableArray new];
}

- (void) configureData {

    if (_dataSourceHas.numberOfItemsInPageTabsView){
        self.numberOfItems = [self.dataSource numberOfItemsInPageTabsView:self];
    }

}

- (void)addSubviews {
    
    [self addSlideBar];
    [self addButtons];
    [self addSlider];
    [self addContentScrollView];
}

- (void)addSlideBar {
    
    if (!_slideBar) {
        
        _slideBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, SlideBar_Height)];
        
        
        _headerScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _slideBar.frame.size.width, _slideBar.frame.size.height)];
        _headerScrollView.directionalLockEnabled = YES;
        _headerScrollView.backgroundColor = [UIColor clearColor];
        _headerScrollView.showsVerticalScrollIndicator = NO;
        _headerScrollView.showsHorizontalScrollIndicator=NO;
        _headerScrollView.delegate=self;
        
        //        _headerScrollView.delegate = self;
        _headerScrollView.bounces = NO;
        [_slideBar addSubview:_headerScrollView];
        [_slideBar setBackgroundColor:[UIColor clearColor]];
        
        // Shadow and Radius
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, _slideBar.frame.size.width, _slideBar.frame.size.height)];
        _slideBar.layer.masksToBounds = NO;
        _slideBar.layer.shadowColor = [UIColor blackColor].CGColor;
        _slideBar.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
        _slideBar.layer.shadowOpacity = 0.15f;
        _slideBar.layer.shadowPath = shadowPath.CGPath;
        _slideBar.layer.shadowRadius=1;
        
        [self addSubview:_slideBar];
        
    }
}

- (void)addButtons {
    
    if (self.numberOfItems==0){
        return;
    }
    
    if ([self.buttonsArray count]!=0){
        for (UIButton *btn in self.buttonsArray){
            [btn removeFromSuperview];
        }
        [self.buttonsArray removeAllObjects];        
    }
    
    
    if (_dataSourceHas.nameOfItemInPageTabsView){
        CGFloat slideItemWidth = SCREEN_WIDTH / (CGFloat)self.numberOfItems;
        
        CGFloat totalWidth=0;
        
        for (NSInteger number=0; number < self.numberOfItems; number++) {
            
            if (!useFullWidth){
                slideItemWidth=[[[self.dataSource nameOfItemInPageTabsView:self AtIndex:number] uppercaseString] sizeWithAttributes:@{NSFontAttributeName:self.fontOfSlider}].width+10;
            }
            
            [self.headerScrollView addSubview:[self p_customButtonWithFrame:CGRectMake( totalWidth, 0, slideItemWidth, SlideBar_Height)
                                                                   forTitle:[self.dataSource nameOfItemInPageTabsView:self AtIndex:number]
                                                                    withTag:number]];
            
            if (number == 0) {
                
                UIButton *btn=[_buttonsArray objectAtIndex:number];
                [btn setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];
            }
            
            
            totalWidth+=slideItemWidth;
            
        }
        _headerScrollView.contentSize=CGSizeMake(totalWidth, _headerScrollView.frame.size.height);
    }
    
}

- (void)addSlider {
    if (self.buttonsArray.count!=0){
        CGRect sliderRect=[self getSelectedElementRect];
        [self.slideBar addSubview:[self p_sliderWithFrame:CGRectMake( sliderRect.origin.x, SlideBar_Height-Slider_Height, sliderRect.size.width, Slider_Height)]];
    }

}

- (void)addContentScrollView {
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SlideBar_Height, SCREEN_WIDTH, self.frame.size.height-SlideBar_Height)];
    _contentScrollView.directionalLockEnabled = YES;
    _contentScrollView.backgroundColor = [UIColor whiteColor];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.contentSize = CGSizeMake(_contentScrollView.frame.size.width * _numberOfItems, self.frame.size.height-SlideBar_Height);
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.bounces = NO;
    _contentScrollView.userInteractionEnabled=YES;
    [self addSubview:_contentScrollView];
    
    // add child view's to contentScrollView
    
    if (_dataSourceHas.contentViewControllerInPageTabsView){
        
        self.childControllersArray = [NSMutableArray new];
        for (NSUInteger i = 0; i < self.numberOfItems; i++) {
            UIViewController *vc=[self.dataSource contentViewControllerInPageTabsView:self AtIndex:i];
            [vc.view setFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, _contentScrollView.frame.size.height)];
            [_contentScrollView addSubview:vc.view];
            [self.childControllersArray addObject:vc];
        }
    }

    [self bringSubviewToFront:self.slideBar];
}

#pragma mark - private method

- (UIButton *)p_customButtonWithFrame:(CGRect)rect forTitle:(NSString *)title withTag:(NSInteger)tag {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:rect];
    [button setTag:tag];

    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
  
    [button setTitle:[title uppercaseString] forState:UIControlStateNormal];
        
    [button.titleLabel setFont:self.fontOfSlider];

    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [_buttonsArray addObject:button];
    
    return button;
}

- (UIView *)p_sliderWithFrame:(CGRect)rect {
    
    if (!_slider) {
        
        _slider = [[UIView alloc] initWithFrame:rect];
        
        
        [_slider setBackgroundColor:self.colorOfSlider];
        
        [_slideBar setBackgroundColor:self.colorOfSlideView];
   
    }
    
    return _slider;
}

- (void)p_animateSliderWithTag:(NSInteger)tag {
    
    [_contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * tag, 0) animated:YES];
    
}

- (void)p_animateSliderToPositionWithOffset:(UIScrollView*)scrollView {

    if (scrollView==self.contentScrollView){
        
        CGPoint offset=scrollView.contentOffset;
        
        for (UIButton *button in _buttonsArray) {
            
            [button setTitleColor:self.titleColor  forState:UIControlStateNormal];
        }
        
        int buttonTag;
        float ratio = offset.x/SCREEN_WIDTH;
        float decimal = ratio - (int)ratio;
        
        if (decimal >= 0.5) {
            
            buttonTag = (int)ratio + 1;
        }
        else {
            
            buttonTag = (int)ratio;
        }
        
        UIButton *bnt=[_buttonsArray objectAtIndex:buttonTag];
        [bnt setTitleColor:self.selectedTitleColor forState:UIControlStateNormal];

        
        
        self.selectedIndex=buttonTag;
        

    }

    CGRect frame = [self getSelectedElementRect];
    if (1) {
        
        frame.origin.x += (CGRectGetWidth(frame) / 2);
        frame.origin.x -= CGRectGetWidth(self.headerScrollView.frame) / 2;
        frame.size.width = CGRectGetWidth(self.headerScrollView.frame);
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        if ((frame.origin.x + CGRectGetWidth(frame)) > self.headerScrollView.contentSize.width) {
            frame.origin.x = (self.headerScrollView.contentSize.width - CGRectGetWidth(self.headerScrollView.frame));
        }
    }
    [_headerScrollView scrollRectToVisible:frame animated:NO];
    
    CGRect btnRect=[self getSelectedElementRect];
    
    CGRect prevFrame=[self.slideBar convertRect:btnRect fromView:_headerScrollView];
    
    CGRect newFrame = CGRectMake(prevFrame.origin.x, _slider.frame.origin.y, btnRect.size.width, _slider.frame.size.height);
    
    [UIView animateWithDuration:0.3 animations:^{
        [_slider setFrame:newFrame];
    }];    
    
}

#pragma mark - event response

- (void)buttonClicked:(UIButton *)button {
    
    self.selectedIndex=button.tag;
    [self selectSection:[_buttonsArray indexOfObject:button]];
    
    if (_delegateHas.didSelectItemAtIndex) {
        [self.delegate pageTabsView:self didSelectItemAtIndex:button.tag];
    }
    
    [self p_animateSliderWithTag:button.tag];
    [self.contentScrollView setContentOffset:CGPointMake(button.tag*SCREEN_WIDTH, 0) animated:YES];
}

-(void) selectSection:(NSInteger) index{
    
    //    for (UIButton *button in _buttonsArray) {
    //
    //        [button setTitleColor:[self.delegate titleColor:self]  forState:UIControlStateNormal];
    //    }
    //
    //    UIButton *bnt=[_buttonsArray objectAtIndex:index];
    //    [bnt setTitleColor:[_slider backgroundColor]  forState:UIControlStateNormal];
}

-(CGRect) getSelectedElementRect{
    return ((UIButton*)[self.buttonsArray objectAtIndex:self.selectedIndex]).frame;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self p_animateSliderToPositionWithOffset:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_delegateHas.didSelectItemAtIndex) {
        [self.delegate pageTabsView:self didSelectItemAtIndex:self.selectedIndex];
    }
}


@end
