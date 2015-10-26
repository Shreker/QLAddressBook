//
//  QLViewController.m
//  QLDemo
//
//  Created by Shrek on 15/5/12.
//  Copyright (c) 2015年 Personal. All rights reserved.
//

#import "QLViewController.h"
#import "QLAddressBookConst.h"
#import <AddressBookUI/AddressBookUI.h>

@interface QLViewController () <ABPeoplePickerNavigationControllerDelegate>

@end

@implementation QLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self openContactList];
}

- (void)openContactList {
    ABPeoplePickerNavigationController *ncPeoplePicker = [[ABPeoplePickerNavigationController alloc] init];
    [ncPeoplePicker setPeoplePickerDelegate:self];
    [self presentViewController:ncPeoplePicker animated:YES completion:nil];
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    return NO;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    return YES;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    /** 获取姓名 */
    NSString *strFirstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *strLastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    QLLog(@"姓名:%@ %@", strLastName, strFirstName);
    ABMultiValueRef multiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSArray *arrPhones = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(multiValueRef);
    QLLog(@"%@", arrPhones);
    //ABMultiValueGetCount(<#ABMultiValueRef multiValue#>) // 获取总条数
    //ABMultiValueCopyLabelAtIndex(<#ABMultiValueRef multiValue#>, <#CFIndex index#>) // 电话对应的名称(住宅,工作等)
    //ABMultiValueCopyValueAtIndex(<#ABMultiValueRef multiValue#>, <#CFIndex index#>) // 电话名称对应的电话号码
    ///*
    // 获得电话号码
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex phoneCount = ABMultiValueGetCount(phone);
    CFRelease(phone);
    NSMutableString *phoneStr = [NSMutableString string];
    [phoneStr appendString:@"电话："];
    for (int i = 0; i<phoneCount; i++) {
        NSString *label = (__bridge NSString *)(ABMultiValueCopyLabelAtIndex(phone, i));
        NSString *value = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phone, i));
        [phoneStr appendFormat:@"\n%@ : %@", label, value];
    }
    
    QLLog(@"%@", phoneStr); //*/
}


@end
