/*******************************************************************************
 Copyright (c) 2013 Koninklijke Philips N.V.
 All Rights Reserved.
 ********************************************************************************/

#import "PHFindLightsManualEntryViewController.h"

#define SERIAL_MAX_LENGTH 6

@interface PHFindLightsManualEntryViewController ()

/**
 An array to keep the list of entered light identifiers
 */
@property (nonatomic, strong) NSMutableArray *enteredLightSerials;

/**
 The header of the tableview, which shows the explanation of adding lights
 */
@property (nonatomic, strong) UIView *headerView;

/**
 The alertview for entering light serials
 */
@property (nonatomic, strong) UIAlertView *enterSerialAlertView;

/**
 The alertview which shows errors when an invalid serial is entered
 */
@property (nonatomic, strong) UIAlertView *invalidSerialAlertView;

/**
 A property to keep track of the last entered serial
 */
@property (nonatomic, strong) NSString *lastEnteredValue;

/**
 The delegate
 */
@property (nonatomic, strong) id<PHFindLightsDelegate> delegate;

/**
 The previous found lights which should still be shown in the results
 */
@property (nonatomic, strong) NSDictionary *previousResults;

@end

@implementation PHFindLightsManualEntryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<PHFindLightsDelegate>)delegate previousResults:(NSDictionary *)previousResults {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Make it a form on iPad
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        
        self.delegate = delegate;
        self.previousResults = previousResults;
        self.title = NSLocalizedString(@"Find new lights", @"Find new lights screen title");
        self.enteredLightSerials = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    // Modify navigation stack, so the back button goes to the root view controller
    [self.navigationItem setHidesBackButton:YES animated:NO];
    NSArray *newViewControllers = [[NSArray alloc] initWithObjects:[self.navigationController.viewControllers objectAtIndex:0], self, nil];
    [self.navigationController setViewControllers:newViewControllers];
    [self.navigationItem setHidesBackButton:NO animated:YES];
    
    [super viewDidLoad];
    
    // Setup tableview editing mode
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:NO];
    [self.tableView setBackgroundView:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create header view with explanation of adding lights
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 220)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    headerView.backgroundColor = [UIColor clearColor];
    
    UIImageView *explanationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, headerView.bounds.size.width, 150)];
    explanationImageView.contentMode = UIViewContentModeScaleAspectFit;
    explanationImageView.image = [UIImage imageNamed:@"addlightmanual.png"];
    explanationImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [headerView addSubview:explanationImageView];
    
    UIFont *textFont = [UIFont systemFontOfSize:16];
    UILabel *explanation1Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, headerView.bounds.size.width - 40, 20)];
    explanation1Label.font = textFont;
    explanation1Label.text = NSLocalizedString(@"1. Enter the serial no. of the light(s)", @"Remote reset explanation part 1");
    explanation1Label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:explanation1Label];
    UILabel *explanation2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, headerView.bounds.size.width - 40, 20)];
    explanation2Label.font = textFont;
    explanation2Label.text = NSLocalizedString(@"2. Screw in the bulbs", @"Remote reset explanation part 2");
    explanation2Label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:explanation2Label];
    UILabel *explanation3Label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, headerView.bounds.size.width - 40, 20)];
    explanation3Label.font = textFont;
    explanation3Label.text = NSLocalizedString(@"3. Turn on the light", @"Remote reset explanation part 3");
    explanation3Label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:explanation3Label];
    
    self.headerView = headerView;
    
    // Reload the table to show the header
    [self.tableView reloadData];
}

- (void)showEnterSerialAlertViewWithSerial:(NSString *)serial {
    self.enterSerialAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Enter the six characters", @"Enter light serial title")
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button light rename popup")
                                                 otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button of light rename popup"), nil];
    
    self.enterSerialAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.enterSerialAlertView textFieldAtIndex:0].text = serial == nil ? @"" : serial;
    [self.enterSerialAlertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [[self.enterSerialAlertView textFieldAtIndex:0] setDelegate:self];
    [[self.enterSerialAlertView textFieldAtIndex:0] setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.enterSerialAlertView show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        int numberOfRows = self.enteredLightSerials.count;
        if (numberOfRows < 10) {
            numberOfRows++; // Add 1 for the add row
        }
        return numberOfRows;
    }
    else {
        return  1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView;
    }
    
    return nil;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.headerView.bounds.size.height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == self.enteredLightSerials.count) {
            // Insert button
            cell.textLabel.text = NSLocalizedString(@"Add light serial", @"Add light serial button");
        }
        else {
            // Light serial cell
            cell.textLabel.text = self.enteredLightSerials[indexPath.row];
        }
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.enabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    else if (indexPath.section == 1) {
        // Start search button
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = NSLocalizedString(@"Start searching", @"Start search button");
        cell.textLabel.enabled = self.enteredLightSerials.count > 0 ? YES : NO;
        
        if(cell.textLabel.enabled) {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    cell.shouldIndentWhileEditing = NO;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.enteredLightSerials.count) {
            // Insert row
            return UITableViewCellEditingStyleInsert;
        }
        else {
            // Light serial row
            return UITableViewCellEditingStyleDelete;
        }
    }
    else {
        // Start button
        return UITableViewCellEditingStyleNone;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row != self.enteredLightSerials.count) {
        // Remove number
        [self.enteredLightSerials removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSIndexPath *startButtonIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:startButtonIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == self.enteredLightSerials.count) {
        // Add button
        [self showEnterSerialAlertViewWithSerial:nil];
    }
    else if (indexPath.section == 1) {
        if (self.enteredLightSerials.count > 0) {
            
            // Start search button
            PHFindLightsResultViewController *resultsViewController = [[PHFindLightsResultViewController alloc] initWithNibName:@"PHFindLightsResultViewController" bundle:[NSBundle mainBundle] delegate:self.delegate lightSerials:self.enteredLightSerials previousResults:self.previousResults];
            [self.navigationController pushViewController:resultsViewController animated:YES];
            
            // Start the search
            [resultsViewController startSearch];
        }

    }
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == self.enterSerialAlertView && buttonIndex != alertView.cancelButtonIndex) {
        // Check if entered value was valid
        self.lastEnteredValue = [alertView textFieldAtIndex:0].text;
        
        // Check length
        if (self.lastEnteredValue.length != 6) {
            self.invalidSerialAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid serial", @"Invalid serial length title")
                                                                     message:NSLocalizedString(@"The serial number should have 6 characters.", @"Invalid serial length message")
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button"), nil];
            [self.invalidSerialAlertView show];
            return;
        }
        
        // Check for hex value
        NSCharacterSet *chars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFabcdef"] invertedSet];
        if ([self.lastEnteredValue rangeOfCharacterFromSet:chars].location != NSNotFound) {
            // Invalid char found
            self.invalidSerialAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid serial", @"Invalid serial characters title")
                                                                     message:NSLocalizedString(@"The entered serial contained an invalid character, please try again.", @"Invalid serial characters message")
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:NSLocalizedString(@"Ok", @"Ok button"), nil];
            [self.invalidSerialAlertView show];
            return;
        }
        
        // Valid serial enterd
        [self.enteredLightSerials addObject:[self.lastEnteredValue uppercaseString]];
        [self.tableView reloadData];
    }
    else if (alertView == self.invalidSerialAlertView) {
        // After error, show the entry screen again, with the entered value
        [self showEnterSerialAlertViewWithSerial:self.lastEnteredValue];
    }
}

#pragma mark - Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if((textField.text.length >= SERIAL_MAX_LENGTH && range.length == 0) ||
       (range.location + string.length > SERIAL_MAX_LENGTH)) {
        return NO;
    }
    return YES;
}

@end
