//
//  RCSignupViewController.h
//  RainbowChat
//
//  Created by レー フックダイ on 5/7/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCSignupViewController;


@protocol RCSignupViewControllerDelegate <NSObject>

- (void)signupViewControllerDidSignupUser;

@end


@interface RCSignupViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) id <RCSignupViewControllerDelegate> delegate;

@end