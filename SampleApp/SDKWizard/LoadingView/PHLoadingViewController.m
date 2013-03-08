//
//  PHLoadingViewController.m
//  SDK3rdApp
//
//  Created by Michael de Vries on 31-10-12.
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import "PHLoadingViewController.h"

@interface PHLoadingViewController ()

@end

@implementation PHLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Make sure it stays fullscreen
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLoadingLabel:nil];
    [super viewDidUnload];
}
@end
