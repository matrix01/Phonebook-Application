//
//  Store.m
//  PhoneBookApplication
//
//  Created by Md. Milan Mia on 10/6/15.
//  Copyright (c) 2015 Apple. All rights reserved.
//

#import "Store.h"
#import "Person.h"
#import <UIKit/UIKit.h>

@implementation Store
@synthesize phoneBook;

+(instancetype)sharedStore{
    static Store *sharedStore;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
        [[Store sharedStore] createItems];
    }
    return sharedStore;
}
-(instancetype)initPrivate{
    self =[super init];
    phoneBook = [[NSMutableArray alloc]init];
    return self;
}
-(id)init{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[Store sharedStore]"
                                 userInfo:nil];
    return nil;
}
-(void)createItems{
    for(int i=0; i<=1000; i++){
        Person *person = [[Person alloc]init];
        person.name = [NSString stringWithFormat:@"Name %d", i];
        person.phoneNo = [[NSMutableArray alloc]init];
        [person.phoneNo addObject:[NSString stringWithFormat:@"%d%d%d%d%d", i, i, i, i, i]];
        person.email = [NSString stringWithFormat:@"xyz@%d.com", i];
        person.image = [UIImage imageNamed:@"contact"];
        person.Id = [[NSMutableArray alloc]init];
        [person.Id addObject:[NSString stringWithFormat:@"Id %d", i ]];
        person.isFav = NO;
        [self.phoneBook addObject:person];
    }
}
-(void)sortAndGroupBy:(int)option {
    NSArray *sortedArray;
    if(option ==1){
        sortedArray = [phoneBook sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            return [[(Person*)a name] compare:[(Person*)b name] options:NSNumericSearch];
        }];
        phoneBook = [sortedArray mutableCopy];
    }
    else if(option==2){
        sortedArray = [phoneBook sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            return [[(Person*)b name] compare:[(Person*)a name] options:NSNumericSearch];
        }];
        phoneBook = [sortedArray mutableCopy];
    }
    else if(option==3){
        sortedArray = [phoneBook sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            return [[(Person*)a name] compare:[(Person*)b name] options:NSNumericSearch];
        }];
        phoneBook = [sortedArray mutableCopy];
        NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"isFav" ascending:NO];
        [phoneBook sortUsingDescriptors:[NSArray arrayWithObject:sorter]];
    }
}
@end
