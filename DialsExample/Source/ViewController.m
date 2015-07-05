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

static BOOL toggleValue = true;
static CGFloat sliderValue = 2.12;
static CGFloat stepper = 3;
static NSString* message = @"Something";

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIView* box;
@property (strong, nonatomic) IBOutlet UIImageView* image;
@property (strong, nonatomic) IBOutlet UILabel* label;

@end


@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:false animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DLSControlForKeyPath(view.backgroundColor).asColor();
    DLSControl(@"Toggle Kitten").actionOf(^{
        self.image.alpha = 1 - self.image.alpha;
    });
    
    DLSControl(@"Foo").toggleOf(&toggleValue);
    DLSControl(@"Bar").sliderOf(&sliderValue, 0, 5);
    DLSControl(@"Group").wrapperOf([[DLSPropertyWrapper alloc] initWithGetter:^id  {
        return @{@"x" : @(10), @"y" : @(20), @"width" : @(20), @"height" : @(30)};
    } setter:^(id value) {
        //
    }], [[DLSRectEditor alloc] init]);
    
    DLSControlGroupWithName(@"Example Group (ObjC)", ^{
        DLSControlForKeyPath(box.alpha).asSlider(0, 1);
        DLSControlForKeyPath(box.hidden).asToggle();
        DLSControlForKeyPath(box.backgroundColor).asColor();
        DLSControl(@"A stepper").stepperOf(&stepper);
        DLSControlForKeyPath(label.text).asTextField();
        DLSControl(@"A message").labelOf(&message);
    });
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
