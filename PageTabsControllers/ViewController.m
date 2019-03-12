//
//  ViewController.m
//  PageTabsControllers
//
//  Created by admin on 31.05.17.
//  Copyright © 2017 ag. All rights reserved.
//

#import "ViewController.h"
#import "SubViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray *viewControllers;

@property (nonatomic,strong) NSArray *namesOfItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTabsView.delegate=self;
    self.pageTabsView.dataSource=self;
    self.pageTabsView.useFullWidth=YES;
    
    SubViewController *controller1=[self.storyboard instantiateViewControllerWithIdentifier:@"subViewController"];
    controller1.view.backgroundColor=[UIColor redColor];
    controller1.pageTitle=@"ITEM 1";
    
    SubViewController *controller2=[self.storyboard instantiateViewControllerWithIdentifier:@"subViewController"];
    controller2.view.backgroundColor=[UIColor greenColor];
    controller2.pageTitle=@"ITEM 2";
    
    SubViewController *controller3=[self.storyboard instantiateViewControllerWithIdentifier:@"subViewController"];
    controller3.view.backgroundColor=[UIColor grayColor];
    controller3.pageTitle=@"ITEM 3";
    
    SubViewController *controller4=[self.storyboard instantiateViewControllerWithIdentifier:@"subViewController"];
    controller4.view.backgroundColor=[UIColor yellowColor];
    controller4.pageTitle=@"ITEM 4";
    
    SubViewController *controller5=[self.storyboard instantiateViewControllerWithIdentifier:@"subViewController"];
    controller4.view.backgroundColor=[UIColor yellowColor];
    controller4.pageTitle=@"ITEM 5";
    
    self.viewControllers = @[controller1,controller2,controller3,controller4, controller5];

    self.namesOfItems=@[@"FIRST", @"SECOND", @"THIRD", @"FOURTH", @"FIFTH"];
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - PageTabsViewDataSource

- (NSInteger)numberOfItemsInPageTabsView:(PageTabsView *)pageTabsView{
    return 5;
}

-(NSString *)nameOfItemInPageTabsView:(PageTabsView *)pageTabsView AtIndex:(NSUInteger)index{
    return [self.namesOfItems objectAtIndex:index];
}

-(UIViewController *)contentViewControllerInPageTabsView:(PageTabsView *)pageTabsView AtIndex:(NSUInteger)index{
    return [self.viewControllers objectAtIndex:index];
}

#pragma mark - PageTabsViewDelegate

-(void)pageTabsView:(PageTabsView *)pageTabsView didSelectItemAtIndex:(NSInteger)index{
      NSLog(@"SelectAtIndex: %ld", (long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
