//
//  PHLoadingViewController.m
//  Hue QuickStart Mac
//
//  Created by Paul Verhoeven on 10/16/13.
//  Copyright (c) 2013 Philips. All rights reserved.
//

#import "PHLoadingViewController.h"

@interface PHLoadingViewController ()

@property (nonatomic,weak) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic,weak) IBOutlet NSTextField *progressMessage;

@end

@implementation PHLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)setLoadingWithMessage:(NSString*)message{
    self.progressMessage.stringValue = message;
    [self.progressIndicator startAnimation:self];
}

@end
