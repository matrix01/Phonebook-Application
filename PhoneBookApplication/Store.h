//
//  Store.h
//  PhoneBookApplication
//
//  Created by Md. Milan Mia on 10/6/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject
@property (nonatomic, strong) NSMutableArray *phoneBook;
+(instancetype)sharedStore;
-(void)createItems;
-(void)sortAndGroupBy:(int)option;
@end
