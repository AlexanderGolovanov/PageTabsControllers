//
//  PageTabsView.h
//  PageTabsControllers
//
//  Created by admin on 31.05.17.
//  Copyright © 2017 ag. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageTabsView;

@protocol PageTabsViewDataSource <NSObject>

- (NSInteger)numberOfItemsInPageTabsView:(PageTabsView *)pageTabsView;

- (NSString *)nameOfItemInPageTabsView:(PageTabsView *)pageTabsView AtIndex:(NSUInteger)index;

- (UIViewController *)contentViewControllerInPageTabsView:(PageTabsView *)pageTabsView AtIndex:(NSUInteger)index;

@end


@protocol PageTabsViewDelegate <NSObject>

@required

- (void)pageTabsView:(PageTabsView *)pageTabsView didSelectItemAtIndex:(NSInteger)index;

@end


@interface PageTabsView : UIView

@property (weak, nonatomic) id<PageTabsViewDelegate> delegate;

@property (weak, nonatomic) id<PageTabsViewDataSource> dataSource;

@property (assign, nonatomic, readonly) NSInteger numberOfItems;

@property (strong, nonatomic, readonly) NSArray *namesOfItems;

@property (strong, nonatomic) UIColor *colorOfSlider;

@property (strong, nonatomic) UIColor *colorOfSlideView;

@property (strong, nonatomic) UIFont *fontOfSlider;

@property (strong, nonatomic) UIColor *titleColor;

@property (strong, nonatomic) UIColor *selectedTitleColor;

@property (nonatomic) BOOL useFullWidth;

@property (nonatomic) NSInteger selectedIndex;

@end
