//
//  CustomViewWithKeyboardAccessory.m
//  RouteToDo
//
//  Created by Juan Pablo Marzetti on 12/5/15.
//  Copyright © 2015 RouteToDo. All rights reserved.
//

#import "CustomViewWithKeyboardAccessory.h"

@implementation CustomViewWithKeyboardAccessory

- (bool) canBecomeFirstResponder {
    return true;
}

- (UIView *)inputAccessoryView {
    if(!_inputAccessoryView) {
        _inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        _inputAccessoryView.backgroundColor = [UIColor redColor];
    }
    return _inputAccessoryView;
}

@end
