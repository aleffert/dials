//
//  ViewController.m
//  DialsExample
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "ViewController.h"

#import <Dials/Dials.h>

static BOOL foo = true;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView* box;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DLSAddButtonAction(@"Action", ^{
        NSLog(@"action");
    });
    
    DLSAddToggleControl(@"Foo", foo);
    
    [[DLSLiveDialsPlugin sharedPlugin] beginGroupWithName:@"test1"];
    DLSAddSliderForKeyPath(box.alpha, 0, 1, YES);
    DLSAddToggleForKeyPath(box.hidden);
    DLSAddColorForKeyPath(box.backgroundColor);
    [[DLSLiveDialsPlugin sharedPlugin] endGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
