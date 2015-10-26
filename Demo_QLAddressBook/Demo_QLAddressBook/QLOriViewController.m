//
//  QLOriViewController.m
//  Demo_QLAddressBook
//
//  Created by Shrek on 15/6/7.
//  Copyright (c) 2015年 M. All rights reserved.
//

#import "QLOriViewController.h"
#import "QLAddressBookConst.h"
#import <AddressBook/AddressBook.h>
#import "AddressBook.h"

@implementation QLOriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

#pragma mark - 利用RHAddressBook框架

- (void)rh {
    // 需要在每个头文件中添加 #import "RHARCSupport.h"
    RHAddressBook *book = [[RHAddressBook alloc] init];
    
    //    [book addPerson:<#(RHPerson *)#>];
    //    [book addPerson:<#(RHPerson *)#>];
    //    [book addPerson:<#(RHPerson *)#>];
    //    [book save];
    
    NSArray *people = [book people];
    for (RHPerson *p in people) {
        NSLog(@"%@ %@", p.firstName, p.lastName);
        
        RHMultiValue *phones = p.phoneNumbers;
        NSInteger phoneCount = phones.count;
        for (NSInteger i = 0; i<phoneCount; i++) {
            NSString *label1 = [phones labelAtIndex:i];
            NSString *label2 = [phones localizedLabelAtIndex:i];
            NSString *value = phones.values[i];
            NSLog(@"%@ %@ %@", label1, label2, value);
        }
    }
}

#pragma mark - 利用CoreFoundation
/** 获取通讯录的授权状态 */
- (void)getAddressBookAuthorization {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusNotDetermined:
            // 用户还没有决定是否授权你的程序进行访问
            [self requestForAccess]; // 申请授权
            break;
        case kABAuthorizationStatusAuthorized:
            // 用户已经授权给你的程序对通讯录进行访问
            
            break;
        case kABAuthorizationStatusDenied:
            // 用户明确的拒绝了你的程序对通讯录的访问
            
            break;
        case kABAuthorizationStatusRestricted:
            // iOS设备上的家长控制或其它一些许可配置阻止程序与通讯录数据库进行交
            
            break;
    }
}

/** 申请授权 */
- (void)requestForAccess {
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) { // 授权成功
            QLLog(@"%@", @"授权成功");
            [self accessForAddressBook];
        } else { // 授权失败
            QLLog(@"%@", @"授权失败");
        }
        CFRelease(addressBookRef);
    });
}

- (void)accessForAddressBook {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status != kABAuthorizationStatusAuthorized) {
        QLLog(@"%@", @"没有授权或者用户已拒绝或者,不可用");
        return;
    }
    /** 获得通讯录对象 */
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    /** 访问通讯录数据 */
    CFArrayRef arrRPeoples = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    CFIndex count = CFArrayGetCount(arrRPeoples);
    for (CFIndex index = 0; index < count; index ++) {
        ABRecordRef people = CFArrayGetValueAtIndex(arrRPeoples, index);
        /** 获取姓名 */
        NSString *strFirstName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
        NSString *strLastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        QLLog(@"姓名:%@ %@", strLastName, strFirstName);
        
        /** 获得电话号码 */
        ABMultiValueRef phone = ABRecordCopyValue(people, kABPersonPhoneProperty);
        CFIndex phoneCount = ABMultiValueGetCount(phone);
        CFRelease(phone);
        NSMutableString *phoneStr = [NSMutableString string];
        [phoneStr appendString:@"电话："];
        for (int i = 0; i<phoneCount; i++) {
            NSString *label = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(phone, i));
            NSString *value = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phone, i));
            [phoneStr appendFormat:@"\n%@ : %@", label, value];
        }
        
        QLLog(@"%@", phoneStr);
    }
    
    
    /** 释放对象 */
    CFRelease(addressBookRef);
    CFRelease(arrRPeoples);
}

#pragma mark - Load default UI and Data
- (void)loadDefaultSetting {
    self.title = @"AddressBook";
}

@end
