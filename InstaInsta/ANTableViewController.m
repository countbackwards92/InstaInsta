//
//  ANTableViewController.m
//  homework_1
//
//  Created by Администратор on 11/17/13.
//  Copyright (c) 2013 MSU. All rights reserved.
//

#import "ANTableViewController.h"
#import "ANTableCellEditController.h"

@interface ANTableViewController ()



@end

@implementation ANTableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    }
    // Configure the cell... setting the text of our cell's label
   // NSObject *fetch = [self.items objectAtIndex:indexPath.row];
   // cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.attributedText = [self.attr_items objectAtIndex:indexPath.row];

    cell.showsReorderControl = YES;
    
    cell.textLabel.numberOfLines = 0;
    
   

    return cell;
}

#define PADDING 15.0f
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 //   NSString *text = [self.items objectAtIndex:indexPath.row];
    NSAttributedString *attr_text = [self.attr_items objectAtIndex:indexPath.row];
    
    CGSize textSize = [attr_text boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - PADDING * 3, 1000.0f)  options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
 //   CGSize textSize = [text boundingRectWithSize:CGSizeMake(self.tableView.frame.size.width - PADDING * 3, 1000.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],} context:nil].size;
    
    return textSize.height + PADDING * 3;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle: @"Cancel"
                                       style: UIBarButtonItemStyleBordered
                                       target: nil action: nil];
        
        [self.navigationItem setBackBarButtonItem: backButton];
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        self.navigationItem.rightBarButtonItem.title = @"Rearrange";
        self.navigationItem.title = @"Text";
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
     return YES;
 }
 

- (IBAction)clearTable:(id)sender {
    [self.items removeAllObjects];
    [self.attrib removeAllObjects];
    [self.attr_items removeAllObjects];
    [self.tableView reloadData];
}

 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [self.items removeObjectAtIndex:indexPath.item];
         [self.attr_items removeObjectAtIndex:indexPath.item];
         [self.attrib removeObjectAtIndex:indexPath.item];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     NSObject *swapper;
     swapper = [self.items objectAtIndex:fromIndexPath.item];
     [self.items removeObjectAtIndex:fromIndexPath.item];
     [self.items insertObject:swapper atIndex:toIndexPath.item];
     
     NSObject *swapper2;
     swapper2 = [self.attr_items objectAtIndex:fromIndexPath.item];
     [self.attr_items removeObjectAtIndex:fromIndexPath.item];
     [self.attr_items insertObject:swapper2 atIndex:toIndexPath.item];
     
     NSObject *swapper3;
     swapper3 = [self.attrib objectAtIndex:fromIndexPath.item];
     [self.attrib removeObjectAtIndex:fromIndexPath.item];
     [self.attrib insertObject:swapper3 atIndex:toIndexPath.item];
     
     [self.tableView reloadData];
 }


 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // If you want to push another view upon tapping one of the cells on your table.
    
    
     ANTableCellEditController *detailViewController = [[ANTableCellEditController alloc] initWithNibName:@"ANTableCellEditController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    
    [detailViewController.initialString setString:[self.items objectAtIndex:indexPath.item]];
    detailViewController.indexindex = indexPath.item;
    
    NSDictionary *initialAttribs = [self.attrib objectAtIndex:indexPath.item];
    detailViewController.isInitBold = [[initialAttribs objectForKey:@"Bold"] boolValue];
    detailViewController.isInitItalic = [[initialAttribs objectForKey:@"Italic"] boolValue];
    detailViewController.initFontSize = [[initialAttribs objectForKey:@"Size"] floatValue];
    detailViewController.initColor = [[initialAttribs objectForKey:@"Color"] floatValue];

    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    detailViewController = nil;
    
}

- (IBAction)addItem:(id)sender {

    ANTableCellEditController *detailViewController = [[ANTableCellEditController alloc] initWithNibName:@"ANTableCellEditController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    
    [detailViewController.initialString setString:@""];
    detailViewController.indexindex = -1;
    detailViewController.initColor = 0.5;
    detailViewController.initFontSize = 0.5;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    detailViewController = nil;
}

- (void) doneWithString:(NSString *)string Attributed:(NSAttributedString*)attributed Attributes:(NSMutableArray*)attributes atIndex:(NSInteger)iindex
{
    if (iindex != -1) {
        [self.items setObject:string atIndexedSubscript:iindex];
        [self.attr_items setObject:attributed atIndexedSubscript:iindex];
        [self.attrib setObject:attributes atIndexedSubscript:iindex];
        [self.tableView reloadData];
    } else {
        [self.items addObject:string];
        [self.attr_items addObject:attributed];
        [self.attrib addObject:attributes];
        [self.tableView reloadData];
    }
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    if (editing) {
        [super setEditing:YES animated:YES]; //Do something for edit mode
        [self.tableView setEditing:YES animated:YES];
    }
    else {
        [super setEditing:NO animated:YES]; //Do something for non-edit mode
        [self.tableView setEditing:NO animated:YES];
    }
    
    if (editing)
    {
        self.editButtonItem.title = @"Done";
    }
    else
    {
        self.editButtonItem.title = @"Rearrange";
        
    }
}
@end
