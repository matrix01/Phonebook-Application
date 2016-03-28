//
//  ContactEditVC.m
//  PhoneBookApplication
//
//  Created by Md. Milan Mia on 10/8/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "ContactEditVC.h"
#import "Store.h"
#import "Person.h"

@interface ContactEditVC (){
    Person *person;
    NSString *name;
    NSString *phone;
    NSString *Id;
}

@end

@implementation ContactEditVC
@synthesize nameField;
- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)viewWillAppear:(BOOL)animated {
    person= [[Store sharedStore].phoneBook objectAtIndex:_index.row];
    nameField.text = person.name;
    if(_imageInput.image == nil){
        _imageInput.image = [UIImage imageNamed:@"contact"];
    }
    else{
        _imageInput.image = person.image;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    _imageInput.userInteractionEnabled = YES;
    [_imageInput addGestureRecognizer:tap];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _imageInput.image = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _phoneTable){
        return [person.phoneNo count];
    }
    else if(tableView == _idTable){
        return [person.Id count];
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(tableView == _phoneTable){
        cell = [tableView dequeueReusableCellWithIdentifier:@"phoneNoCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
        }
        UITextField *textField = (UITextField*)[cell viewWithTag:120];
        textField.text = [person.phoneNo objectAtIndex:indexPath.row];
        if(indexPath.row%2){
            textField.backgroundColor = [UIColor cyanColor];
        }
        else{
            textField.backgroundColor = [UIColor greenColor];
        }
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"idCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"idCell"];
        }
        UITextField *textField = (UITextField*)[cell viewWithTag:121];
        textField.text = [person.Id objectAtIndex:indexPath.row];
        if(indexPath.row%2){
            textField.backgroundColor = [UIColor cyanColor];
        }
        else{
            textField.backgroundColor = [UIColor greenColor];
        }
    }
    return cell;
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    CGPoint textFieldPosition = [textField convertPoint:CGPointZero toView:_phoneTable];
    NSIndexPath *indexPath = [_phoneTable indexPathForRowAtPoint:textFieldPosition];
    if(textField.tag == 120){
        phone = textField.text;
        [person.phoneNo replaceObjectAtIndex:indexPath.row withObject:phone];
    }
    else{
        Id = textField.text;
        [person.Id replaceObjectAtIndex:indexPath.row withObject:Id];
    }
}
#pragma mark - image picker delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    image = info[UIImagePickerControllerOriginalImage];
    _imageInput.image = image;
    person.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - button actions
- (void)myTapMethod {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (IBAction)addPhoneNo:(UIButton *)sender {
    [person.phoneNo addObject:[NSString stringWithFormat:@"Phone %ld", _index.row]];
    [_phoneTable reloadData];
}
- (IBAction)addNewId:(UIButton *)sender {
    UITextField *txtField = (UITextField*)[_phoneTable viewWithTag:121];
    txtField.delegate = self;
    [person.Id addObject:[NSString stringWithFormat:@"Id %ld", _index.row+1]];
    [_idTable reloadData];
}
- (IBAction)backBarButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneButton:(UIBarButtonItem *)sender {
    name = nameField.text;
    person.name = name;
    if(name!=nil && phone!=nil && image!=nil){
        [[Store sharedStore].phoneBook replaceObjectAtIndex:_index.row withObject:person];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
