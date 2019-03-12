//
//  ViewController.h
//  PageTabsControllers
//
//  Created by admin on 31.05.17.
//  Copyright © 2017 ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageTabsView.h"

@interface ViewController : UIViewController <PageTabsViewDelegate, PageTabsViewDataSource>

@property (weak, nonatomic) IBOutlet PageTabsView *pageTabsView;

@end

