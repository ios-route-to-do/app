//
//  Utils.h
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 11/23/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

#define kDarkPurpleColorHex 0x673AB7
#define kLightBlueColorHex 0x03A9F4

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#endif /* Utils_h */
