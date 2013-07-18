/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHFindLightsStartViewController.h"

@interface PHFindLightsStartViewController ()

@property (nonatomic, strong) id<PHFindLightsDelegate> delegate;

@end

@implementation PHFindLightsStartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHFindLightsDelegate>)delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Make it a form on iPad
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        self.delegate = delegate;
        self.title = NSLocalizedString(@"Find new lights", @"Find new lights screen title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 Invoked by start button, starts a search
 */
- (IBAction)startSearch:(id)sender {
    // Create result interface
    PHFindLightsResultViewController *resultsViewController = [[PHFindLightsResultViewController alloc] initWithNibName:@"PHFindLightsResultViewController" bundle:[NSBundle mainBundle] delegate:self.delegate lightSerials:nil previousResults:nil];
    [self.navigationController pushViewController:resultsViewController animated:YES];
    
    // Start the search
    [resultsViewController startSearch];
}

@end
