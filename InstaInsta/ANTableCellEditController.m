//
//  ANTableCellEditController.m
//  homework_1
//
//  Created by Администратор on 11/17/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import "ANTableCellEditController.h"
#import "ANTableViewController.h"

@interface ANTableCellEditController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@property (weak, nonatomic) IBOutlet UISwitch *isBold;
@property (weak, nonatomic) IBOutlet UISwitch *isItalic;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;


@property (strong, nonatomic) IBOutlet UITableViewCell *slidersCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *textCell;
@property (strong, nonatomic) NSArray *cells;

@end

@implementation ANTableCellEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle: @"Cancel"
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        [self.navigationItem setBackBarButtonItem: backButton];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing:)];
        

    }
    return self;
}


- (NSMutableString *) initialString
{
    if (!_initialString) _initialString = [[NSMutableString alloc] initWithString:@"LMAO"];
    return _initialString;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.textView setText:self.initialString];
    self.navigationController.navigationBar.translucent = NO;
    if (self.indexindex == -1) {
        self.navigationItem.title = @"Add line";
    } else {
        self.navigationItem.title = [NSString stringWithFormat:@"Edit line #%d", self.indexindex + 1];
    }
    self.colorSlider.value = self.initColor;
    self.sizeSlider.value = self.initFontSize;
    [self.isBold setOn:self.isInitBold];
    [self.isItalic setOn:self.isInitItalic];
    
    [self.colorLabel setTextColor:[UIColor colorWithHue:self.colorSlider.value saturation:0.8 brightness:0.8 alpha:1.0]];
    
    UIFont *currentFont;

    if (self.isItalic.isOn && self.isBold.isOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:(self.sizeSlider.value + 0.1) * 100];
    } else if (self.isBold.isOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-Bold" size:(self.sizeSlider.value + 0.1) * 100];
    } else if (self.isItalic.isOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-Oblique" size:(self.sizeSlider.value + 0.1) * 100];
    } else {
        currentFont = [UIFont fontWithName:@"Helvetica" size:(self.sizeSlider.value + 0.1) * 100];
    }
    
    [self.textView setFont:currentFont];
    [self.textView setTextColor:[UIColor colorWithHue:self.colorSlider.value saturation:1 brightness:1 alpha:1.0]];
    
    self.cells = [NSArray arrayWithObjects:self.slidersCell, self.textCell, nil];
    for (UITableViewCell *cell in self.cells)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneEditing:(id)sender {
    id controller = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
    
    NSDictionary *currentAttributes = @{@"Bold": [NSNumber numberWithBool:self.isBold.isOn], @"Italic": [NSNumber numberWithBool:self.isItalic.isOn], @"Size": [NSNumber numberWithFloat:self.sizeSlider.value], @"Color": [NSNumber numberWithFloat:self.colorSlider.value]};
    
    [controller doneWithString: self.textView.text Attributed:self.textView.attributedText Attributes:currentAttributes atIndex:self.indexindex];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cells objectAtIndex:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.cells objectAtIndex:indexPath.row];
    return cell.bounds.size.height;  // use the height set in IB
}

- (IBAction)colorChanged:(id)sender {
    [self.colorLabel setTextColor:[UIColor colorWithHue:self.colorSlider.value saturation:1 brightness:1 alpha:1.0]];
    [self.textView setTextColor:[UIColor colorWithHue:self.colorSlider.value saturation:1 brightness:1 alpha:1.0]];
}

- (void) updateFont
{
    UIFont *currentFont;
    
    if (self.isItalic.isOn && self.isBold.isOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-BoldOblique" size:(self.sizeSlider.value + 0.1) * 100];
    } else if (self.isBold.isOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-Bold" size:(self.sizeSlider.value + 0.1) * 100];
    } else if (self.isItalic.isOn) {
        currentFont = [UIFont fontWithName:@"Helvetica-Oblique" size:(self.sizeSlider.value + 0.1) * 100];
    } else {
        currentFont = [UIFont fontWithName:@"Helvetica" size:(self.sizeSlider.value + 0.1) * 100];
    }
    
    [self.textView setFont:currentFont];
    [self.textView setTextColor:[UIColor colorWithHue:self.colorSlider.value saturation:1 brightness:1 alpha:1.0]];
}

- (IBAction)sizeChanged:(id)sender {
    [self updateFont];
}

- (IBAction)boldSwitched:(id)sender {
    [self updateFont];
}
- (IBAction)italicSwitched:(id)sender {
    [self updateFont];
}

@end
