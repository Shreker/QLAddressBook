//
//  QLAddressBookConst.h
//  Demo_QLAddressBook
//
//  Created by Shrek on 15/6/7.
//  Copyright (c) 2015年 M. All rights reserved.
//

#ifndef Demo_QLAddressBook_QLAddressBookConst_h
#define Demo_QLAddressBook_QLAddressBookConst_h

/** QLDEBUG Print | M:method, L:line, C:content*/
#ifdef DEBUG
#define QLLog(FORMAT, ...) fprintf(stderr,"M:%s|L:%d|C->%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define QLLog(FORMAT, ...)
#endif

#endif
