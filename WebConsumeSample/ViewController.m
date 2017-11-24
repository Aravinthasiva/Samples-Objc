//
//  ViewController.m
//  WebConsumeSample
//
//  Created by MacMini3 on 24/11/17.
//  Copyright © 2017 MacMini3. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSArray *webDataUserId;
    NSArray *webDataId;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WebServices *webService = [[WebServices alloc] init];
    webService.delegate = self;
    webService.tag = 1;
    [webService getData:@"https://jsonplaceholder.typicode.com/posts"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return webDataUserId.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UIImage *image = [UIImage imageNamed:@"energy"];
    [cell.imageView setImage:image];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[webDataUserId objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[webDataId objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:@"You've selected a row" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];
}


//For Web service consumption below,

#pragma webservices

-(void)receivedError:(NSString *)error fromWebservice:(WebServices *)webservice {
    
    UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Something went wrong,\nPlease try again."  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)receivedResponse:(NSDictionary *)dictResponse fromWebservice:(WebServices *)webservice {
    
    if (webservice.tag ==1) {
        NSLog(@"%@",dictResponse);
        //[self makeArray];
        webDataUserId = [dictResponse valueForKey:@"title"];
        webDataId = [dictResponse valueForKey:@"id"];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
    }

}
    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
