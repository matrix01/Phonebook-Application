//
//  ContactEditVC.h
//  PhoneBookApplication
//
//  Created by Md. Milan Mia on 10/8/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactEditVC : UIViewController<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate> {
    UIImage *image;
    __weak IBOutlet UITextField *nameField;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *imageInput;
@property (weak, nonatomic) IBOutlet UITableView *idTable;
@property (weak, nonatomic) IBOutlet UITableView *phoneTable;
@property (nonatomic) NSIndexPath *index;
@end