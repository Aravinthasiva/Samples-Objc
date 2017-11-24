//
//  ViewController.h
//  WebConsumeSample
//
//  Created by MacMini3 on 24/11/17.
//  Copyright © 2017 MacMini3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "WebServices.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

