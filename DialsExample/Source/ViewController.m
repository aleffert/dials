//
//  ViewController.m
//  DialsExample
//
//  Created by Akiva Leffert on 12/6/14.
//  Copyright (c) 2014 Akiva Leffert. All rights reserved.
//

#import "ViewController.h"

#import <Dials/Dials.h>

#import "DialsExample-Swift.h"

static BOOL foo = true;
static CGFloat bar = 0.45;

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
    DLSAddSliderControl(@"Bar", bar, 0, 5);
    
    [[DLSLiveDialsPlugin sharedPlugin] beginGroupWithName:@"test1"];
    DLSAddSliderForKeyPath(box.alpha, 0, 1);
    DLSAddToggleForKeyPath(box.hidden);
    DLSAddColorForKeyPath(box.backgroundColor);
    [[DLSLiveDialsPlugin sharedPlugin] endGroup];
}

- (IBAction)push:(id)sender {
    TestViewController* controller = [[TestViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
