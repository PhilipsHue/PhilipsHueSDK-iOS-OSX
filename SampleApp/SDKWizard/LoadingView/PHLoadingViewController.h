/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import <UIKit/UIKit.h>

@interface PHLoadingViewController : UIViewController

/**
 The label shown below the loading spinner
 */
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *loadingLabel;

@end
