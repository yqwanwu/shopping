//
//  ViewController.h
//  UPPayDemo
//
//  Created by zhangyi on 15/11/19.
//  Copyright © 2015年 UnionPay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPPayViewController : UIViewController< UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic, retain)UITableView *contentTableView;

@property(nonatomic, weak)UIViewController *topVc;

//id: Int, isOrderList: Bool
+ (void)startPayWithTopVc:(UIViewController *)topVc id:(int)oid isOrderList:(BOOL)isOrderList;

@end

