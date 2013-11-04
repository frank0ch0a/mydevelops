//
//  ModalPickerView.h
//  Glaux
//
//  Created by Francisco on 4/05/13.
//  Copyright (c) 2013 maravillatech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ModalPickerViewCallback)(BOOL madeChoice);

@interface ModalPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSString *selectedValue;
@property (nonatomic, retain) NSArray *values;

/* Initializes a new instance of the picker with the values to present to the user.
 (Note: call presentInView:withBlock: or presentInWindowWithBlock: to display the control)
 */
- (id)initWithValues:(NSArray *)values;

/* Presents the control embedded in the provided view.
 Arguments:
 view        - The view that will contain the control.
 callback    - The block that will receive the result of the user action.
 */
- (void)presentInView:(UIView *)view withBlock:(ModalPickerViewCallback)callback;

/* Presents the control embedded in the window.
 Arguments:
 callback    - The block that will receive the result of the user action.
 */
- (void)presentInWindowWithBlock:(ModalPickerViewCallback)callback;

@end
