//
//  PhoneBookVC.m
//  PhoneBookApplication
//
//  Created by Md. Milan Mia on 10/6/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "PhoneBookVC.h"
#import "Store.h"
#import "ContactEditVC.h"
#import "Person.h"

@interface PhoneBookVC(){
    ContactEditVC *contactEdit;
}
@end
@implementation PhoneBookVC
- (void)viewDidLoad {
    [super viewDidLoad];
    contactEdit = (ContactEditVC*)[self.storyboard instantiateViewControllerWithIdentifier:@"contactEdit"];
    pickerView.hidden = YES;
    flag = false;
    offset = 0;
}
-(void)viewWillAppear:(BOOL)animated{
    [myTable reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Store sharedStore].phoneBook count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCustomCell" forIndexPath:indexPath];
    UILabel *label = (UILabel*)[cell viewWithTag:130];
    Person *person = [[Store sharedStore].phoneBook objectAtIndex:indexPath.row];
    label.text = person.name;
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label = (UILabel*)[cell viewWithTag:131];
    label.text = [person.phoneNo objectAtIndex:0];
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    label = (UILabel*)[cell viewWithTag:132];
    label.text = person.email;
    label.layer.borderColor = [[UIColor whiteColor] CGColor];
    UIImageView *imageV = (UIImageView*)[cell viewWithTag:133];
    UIImage *image = person.image;
    imageV.layer.borderColor = [[UIColor whiteColor] CGColor];
    if(image){
        imageV.image = image;
    }
    else{
        imageV.image = [UIImage imageNamed:@"contact"];
    }
    UIButton *favButton = (UIButton*)[cell viewWithTag:250];
    if(person.isFav)
        [favButton setImage:[UIImage imageNamed:@"star-blue"] forState:UIControlStateNormal];
    else
        [favButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    /*Cell configure End*/
    UIView *myView = (UIView*)[cell viewWithTag:151];
    __block CGRect newFrame = myView.frame;
    newFrame.origin.x = offset;
    [UIView animateWithDuration:0.3 animations:^{
        myView.frame = newFrame;
    }];
    UIView *leftView = (UIView*)[cell viewWithTag:145];
    leftView.hidden = !flag;
    return cell;
}
#pragma mark - mail, message delegates
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)sendMessage:(id)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        controller.body = @"SMS message here";
        controller.recipients = [NSArray arrayWithObjects:@"1(234)567-8910", nil];
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
- (IBAction)sendMail:(UIButton *)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"example@email.com"]];
        [composeViewController setSubject:@"example subject"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
#pragma mark - Edit Delete mode actions
- (IBAction)toggleEditingMode:(id)sender {
    if(flag){
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor blueColor];
        flag = false;
        offset = 0;
    }
    else{
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor redColor];
        flag = true;
        offset = 45;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [myTable reloadData];
    });
}
- (IBAction)editContact:(UIButton *)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:myTable];
    NSIndexPath *indexPath = [myTable indexPathForRowAtPoint:buttonPosition];
    contactEdit.index = indexPath;
    [self.navigationController pushViewController:contactEdit animated:YES];
}
- (IBAction)deleteContact:(UIButton *)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:myTable];
    NSIndexPath *indexPath = [myTable indexPathForRowAtPoint:buttonPosition];
    [myTable beginUpdates];
    [[Store sharedStore].phoneBook removeObjectAtIndex:indexPath.row];
    [myTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [myTable endUpdates];
    [myTable reloadData];
}
#pragma mark - picker delegates
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[Store sharedStore].phoneBook count];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Person *person = [[Store sharedStore].phoneBook objectAtIndex:row];
    return person.name;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
}
- (IBAction)showPicker:(id)sender {
    pickerView.hidden = NO;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
}
#pragma mark - picker actions
- (IBAction)pickerDone:(id)sender {
    NSInteger row= [myPickerView selectedRowInComponent:0];
    Person *person =[[Store sharedStore].phoneBook objectAtIndex:row];
    UIImage *imageAttach = person.image;
    pickerView.hidden = YES;
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[@"example@email.com"]];
        [composeViewController setSubject:@"example subject"];
        NSData *myData = UIImageJPEGRepresentation(imageAttach, 0.9);
        [composeViewController addAttachmentData:myData mimeType:@"image/jpg" fileName:@"attach.jpg"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}
- (IBAction)pickerCancel:(id)sender {
    pickerView.hidden = YES;
}
- (IBAction)rightNavButton:(id)sender {
    [self.navigationController pushViewController:contactEdit animated:YES];
}
#pragma mark - ActionSheet methods and delegate
- (IBAction)showActionSheet:(id)sender {
    NSString *actionSheetTitle = @"Sort Contacts"; //Action Sheet Title
    NSString *other1 = @"Sort Ascending";
    NSString *other2 = @"Sort Descending";
    NSString *other3 = @"Sort Favourite";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, other3, nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if  ([buttonTitle isEqualToString:@"Destructive Button"]) {
    }
    if ([buttonTitle isEqualToString:@"Sort Ascending"]) {
        [[Store sharedStore] sortAndGroupBy:1];
        [myTable reloadData];
    }
    if ([buttonTitle isEqualToString:@"Sort Descending"]) {
        [[Store sharedStore] sortAndGroupBy:2];
        [myTable reloadData];
    }
    if ([buttonTitle isEqualToString:@"Sort Favourite"]) {
        [[Store sharedStore] sortAndGroupBy:3];
        [myTable reloadData];
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
    }
}
- (IBAction)isFavButton:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:myTable];
    NSIndexPath *indexPath = [myTable indexPathForRowAtPoint:buttonPosition];
    Person *person = [[Store sharedStore].phoneBook objectAtIndex:indexPath.row];
    if(person.isFav)
        person.isFav = NO;
    else
        person.isFav = YES;
    [myTable reloadData];
}

@end