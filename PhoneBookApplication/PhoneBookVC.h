//
//  PhoneBookVC.h
//  PhoneBookApplication
//
//  Created by Md. Milan Mia on 10/6/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface PhoneBookVC : UIViewController<MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    bool flag;
    __weak IBOutlet UITableView *myTable;
    __weak IBOutlet UIPickerView *myPickerView;
    __weak IBOutlet UIView *pickerView;
    int offset;
}
- (void)showActionSheet:(id)sender;
@end
