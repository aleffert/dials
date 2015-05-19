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
static CGFloat stepper = 3;
static NSString* message = @"Something";

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView* box;
@property (strong, nonatomic) IBOutlet UIImageView* image;
@property (strong, nonatomic) IBOutlet UILabel* label;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DLSControlForKeyPath(view.backgroundColor).asColor();
    DLSControl(@"Action").actionOf(^{
        NSLog(@"action");
    });
    
    DLSControl(@"Foo").toggleOf(&foo);
    DLSControl(@"Bar").sliderOf(&bar, 0, 5);
    
    [[DLSLiveDialsPlugin activePlugin] beginGroupWithName:@"ObjC Test Group"];
    DLSControlForKeyPath(box.alpha).asSlider(0, 1);
    DLSControlForKeyPath(box.hidden).asToggle();
    DLSControlForKeyPath(box.backgroundColor).asColor();
    DLSControl(@"A stepper").stepperOf(&stepper);
    DLSControlForKeyPath(label.text).asTextField();
    DLSControl(@"A message").labelOf(&message);
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
