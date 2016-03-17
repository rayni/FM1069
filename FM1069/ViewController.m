//
//  ViewController.m
//  FM1069
//
//  Created by RayNi on 16/3/16.
//  Copyright © 2016年 RayNi. All rights reserved.
//

#import "ViewController.h"
#import "InfoListRequest.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    InfoListRequest *request = [InfoListRequest request];
    [request startPostRequestWithFinishedBlock:^(AFHTTPRequestOperation *operation, QCResponseEntity *responseObject) {
        NSLog(@"--------");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
