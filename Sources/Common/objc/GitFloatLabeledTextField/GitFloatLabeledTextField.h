//
//  GitFloatLabeledTextField.h
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldValidator.h"

/**
 * `GitFloatLabeledTextField` is a `UITextField` subclass that implements the "Float Label Pattern".
 *
 * Due to space constraints on mobile devices, it is common to rely solely on placeholders as a means to label fields.
 * This presents a UX problem, in that, once the user begins to fill out a form, no labels are present.
 *
 * `GitFloatLabeledTextField` aims to improve the user experience by having placeholders transition into 
 * "floating labels" that hover above the text field after it is populated with text.
 *
 * GitFloatLabeledTextField supports iOS 6+.
 *
 * Credits for the concept to Matt D. Smith (@mds), and his original design:  http://mattdsmith.com/float-label-pattern/
 */
IB_DESIGNABLE
NS_CLASS_AVAILABLE_IOS(6_0) @interface GitFloatLabeledTextField : UITextField<UITextFieldDelegate>

/**
 * Read-only access to the floating label.
 */
@property (nonatomic, strong, readonly) UILabel * floatingLabel;

/**
 * Padding to be applied to the y coordinate of the floating label upon presentation.
 * Defaults to zero.
 */
@property (nonatomic) IBInspectable CGFloat floatingLabelYPadding;

/**
 * Padding to be applied to the x coordinate of the floating label upon presentation.
 * Defaults to zero
 */
@property (nonatomic) IBInspectable CGFloat floatingLabelXPadding;

/**
 * Ratio by which to modify the font size of the floating label.
 * Defaults to 70
 */
@property (nonatomic) IBInspectable CGFloat floatingLabelReductionRatio;

/**
 * Padding to be applied to the y coordinate of the placeholder.
 * Defaults to zero.
 */
@property (nonatomic) IBInspectable CGFloat placeholderYPadding;

/**
 * Font to be applied to the floating label. 
 * Defaults to the first applicable of the following:
 * - the custom specified attributed placeholder font at 70% of its size
 * - the custom specified textField font at 70% of its size
 */
@property (nonatomic, strong) UIFont * floatingLabelFont;

/**
 * Text color to be applied to the floating label. 
 * Defaults to `[UIColor grayColor]`.
 */
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelTextColor;

/**
 * Text color to be applied to the floating label while the field is a first responder.
 * Tint color is used by default if an `floatingLabelActiveTextColor` is not provided.
 */
@property (nonatomic, strong) IBInspectable UIColor * floatingLabelActiveTextColor;

/**
 * Indicates whether the floating label's appearance should be animated regardless of first responder status.
 * By default, animation only occurs if the text field is a first responder.
 */
@property (nonatomic, assign) IBInspectable BOOL animateEvenIfNotFirstResponder;

/**
 * Duration of the animation when showing the floating label. 
 * Defaults to 0.3 seconds.
 */
@property (nonatomic, assign) NSTimeInterval floatingLabelShowAnimationDuration;

/**
 * Duration of the animation when hiding the floating label. 
 * Defaults to 0.3 seconds.
 */
@property (nonatomic, assign) NSTimeInterval floatingLabelHideAnimationDuration;

/**
 * Indicates whether the clearButton position is adjusted to align with the text
 * Defaults to 1.
 */
@property (nonatomic, assign) IBInspectable BOOL adjustsClearButtonRect;

/**
 * Indicates whether or not to drop the baseline when entering text. Setting to YES (not the default) means the standard greyed-out placeholder will be aligned with the entered text
 * Defaults to NO (standard placeholder will be above whatever text is entered)
 */
@property (nonatomic, assign) IBInspectable BOOL keepBaseline;

/**
 * Force floating label to be always visible
 * Defaults to NO
 */
@property (nonatomic, assign) BOOL alwaysShowFloatingLabel;

/**
 * Color of the placeholder
 */
@property (nonatomic, strong) IBInspectable UIColor * placeholderColor;

@property (nonatomic,assign) BOOL isMandatory;   /**< Default is YES*/

@property (nonatomic,retain) IBOutlet UIView *presentInView;    /**< Assign view on which you want to show popup and it would be good if you provide controller's view*/

@property (nonatomic,retain) UIColor *popUpColor;   /**< Assign popup background color, you can also assign default popup color from macro "ColorPopUpBg" at the top*/

@property (nonatomic,assign) BOOL validateOnCharacterChanged; /**< Default is YES, Use it whether you want to validate text on character change or not.*/

@property (nonatomic,assign) BOOL validateOnResign; /**< Default is YES, Use it whether you want to validate text on resign or not.*/

/**
 *  Sets the placeholder and the floating title
 *
 *  @param placeholder The string that to be shown in the text field when no other text is present.
 *  @param floatingTitle The string to be shown above the text field once it has been populated with text by the user.
 */
- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle;

/**
 *  Sets the attributed placeholder and the floating title
 *
 *  @param attributedPlaceholder The string that to be shown in the text field when no other text is present.
 *  @param floatingTitle The string to be shown above the text field once it has been populated with text by the user.
 */
- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder floatingTitle:(NSString *)floatingTitle;

-(void)addRegx:(NSString *)strRegx withMsg:(NSString *)msg;

/**
 By deafult the message will be shown which is given in the macro "MsgValidateLength", but you can change message for each textfield as well.
 @param msg Message string to be displayed when length validation will fail.
 */
-(void)updateLengthValidationMsg:(NSString *)msg;

/**
 Use to add validation for validating confirm password
 @param txtPassword Hold reference of password textfield from which they will check text equality.
 */
-(void)addConfirmValidationTo:(TextFieldValidator *)txtPassword withMsg:(NSString *)msg;

/**
 Use to perform validation
 @return Bool It will return YES if all provided regex validation will pass else return NO
 
 Eg: If you want to apply validation on all fields simultaneously then refer below code which will be make it easy to handle validations
 if([txtField1 validate] & [txtField2 validate]){
 // Success operation
 }
 */
-(BOOL)validate;
-(void)tapOnError;
/**
 Use to dismiss error popup.
 */
-(void)dismissPopup;
@end
