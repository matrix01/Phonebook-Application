//
//  Person.h
//  PhoneBookApplication
//
//  Created by Md. Milan Mia on 10/12/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject
@property (nonatomic) NSString *name;
@property (nonatomic) NSMutableArray *phoneNo;
@property (nonatomic) NSString *email;
@property (nonatomic) NSMutableArray *Id;
@property (nonatomic) UIImage *image;
@property (nonatomic) BOOL isFav;
@end
