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
static CGFloat bar = 2.12;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView* box;
@property (strong, nonatomic) IBOutlet UIImageView* image;

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
    
    [[DLSLiveDialsPlugin activePlugin] beginGroupWithName:@"test1"];
    DLSAddSliderForKeyPath(box.alpha, 0, 1);
    DLSAddToggleForKeyPath(box.hidden);
    DLSAddColorForKeyPath(box.backgroundColor);
    [[DLSLiveDialsPlugin activePlugin] endGroup];
}

- (IBAction)push:(id)sender {
    TestViewController* controller = [[TestViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)makeRequest:(id)sender {
    NSURL* url = [NSURL URLWithString:@"http://placekitten.com/g/300/310"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image.image = [UIImage imageWithData:data];
        });
    }] resume];
}

@end
