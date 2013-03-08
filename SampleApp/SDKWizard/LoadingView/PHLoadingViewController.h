//
//  PHLoadingViewController.h
//  SDK3rdApp
//
//  Created by Michael de Vries on 31-10-12.
//  Copyright (c) 2012 Philips. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHLoadingViewController : UIViewController

/**
 The label shown below the loading spinner
 */
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *loadingLabel;

@end
