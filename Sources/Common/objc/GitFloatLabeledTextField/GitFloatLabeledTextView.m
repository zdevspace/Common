//
//  GitFloatLabeledTextView.m
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/10/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import "GitFloatLabeledTextView.h"
#import "NSString+TextDirectionality.h"
#import "FrameworkUtils.h"

static CGFloat const kFloatingLabelShowAnimationDuration = 0.3f;
static CGFloat const kFloatingLabelHideAnimationDuration = 0.3f;

@interface GitFloatLabeledTextView ()<UITextViewDelegate>


@end

@implementation GitFloatLabeledTextView
@synthesize clearWhenEditingBegins;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];

        // force setter to be called on a placeholder defined in a NIB/Storyboard
        if (self.placeholder) {
            self.placeholder = self.placeholder;
        }
    }
    return self;
}

- (void)commonInit
{
    self.startingTextContainerInsetTop = self.textContainerInset.top;
    self.floatingLabelShouldLockToTop = YES;
    self.textContainer.lineFragmentPadding = 0;
    
    _placeholderLabel = [[UILabel alloc] initWithFrame:self.frame];
    if (!self.font) {
        // by default self.font may be nil - so make UITextView use UILabel's default
        self.font = _placeholderLabel.font;
    }
    _placeholderLabel.font = self.font;
    _placeholderLabel.text = self.placeholder;
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _placeholderLabel.backgroundColor = [UIColor clearColor];
    _placeholderTextColor = [GitFloatLabeledTextView defaultiOSPlaceholderColor];
    _placeholderLabel.textColor = _placeholderTextColor;
    [self insertSubview:_placeholderLabel atIndex:0];
    
    _floatingLabel = [UILabel new];
    _floatingLabel.alpha = 0.0f;
    _floatingLabel.backgroundColor = self.backgroundColor;
    [self addSubview:_floatingLabel];
	
    // some basic default fonts/colors
    _floatingLabelFont = [self defaultFloatingLabelFont];
    _floatingLabel.font = _floatingLabelFont;
    _floatingLabelTextColor = [UIColor grayColor];
    _floatingLabel.textColor = _floatingLabelTextColor;
    _animateEvenIfNotFirstResponder = NO;
    _floatingLabelShowAnimationDuration = kFloatingLabelShowAnimationDuration;
    _floatingLabelHideAnimationDuration = kFloatingLabelHideAnimationDuration;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(layoutSubviews)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(layoutSubviews)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(layoutSubviews)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
    
    self.delegate = self;
    
}

- (void) showClearButton{
    for (int i=0; i<self.subviews.count; i++){
        UIView *subView = self.subviews[i];
        if (subView.tag == 100){
            return;
        }
    }
    
    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClear setTag:100];
    [btnClear setImage:[FrameworkUtils getImageFromFramework:@"UITextFieldClearButton.png" imageRenderMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
    btnClear.frame = CGRectMake(0, 0, 15, 15);
    btnClear.center = CGPointMake(self.frame.size.width - 15 , 15);
    [btnClear addTarget:self action:@selector(clearTextView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnClear];
}

-(void) removeClearButton{
    for (int i=0; i<self.subviews.count; i++){
        UIView *subView = self.subviews[i];
        if (subView.tag == 100){
            [subView removeFromSuperview];
            break;
        }
    }
}

- (void)clearTextView:(id)sender{
    self.text = @"";
}
    
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidChangeNotification
                                                  object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:self];
}

#pragma mark -

- (UIFont *)defaultFloatingLabelFont
{
    UIFont *textViewFont = nil;
    
    if (!textViewFont && self.placeholderLabel.attributedText && self.placeholderLabel.attributedText.length > 0) {
        textViewFont = [self.placeholderLabel.attributedText attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    }
    if (!textViewFont) {
        textViewFont = self.placeholderLabel.font;
    }
    
    return [UIFont fontWithName:textViewFont.fontName size:roundf(textViewFont.pointSize * 0.7f)];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
    _floatingLabel.text = placeholder;
    
    if (0 != self.floatingLabelShouldLockToTop) {
        _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                          _floatingLabel.frame.origin.y,
                                          self.frame.size.width,
                                          _floatingLabel.frame.size.height);
    }
    
    [self setNeedsLayout];
}

- (void)setPlaceholder:(NSString *)placeholder floatingTitle:(NSString *)floatingTitle
{
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
    _floatingLabel.text = floatingTitle;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self adjustTextContainerInsetTop];
    
    CGSize floatingLabelSize = [_floatingLabel sizeThatFits:_floatingLabel.superview.bounds.size];
    
    _floatingLabel.frame = CGRectMake(_floatingLabel.frame.origin.x,
                                      _floatingLabel.frame.origin.y,
                                      self.frame.size.width,
                                      floatingLabelSize.height);
    
    CGSize placeholderLabelSize = [_placeholderLabel sizeThatFits:_placeholderLabel.superview.bounds.size];
    
    CGRect textRect = [self textRect];
    
    _placeholderLabel.alpha = [self.text length] > 0 ? 0.0f : 1.0f;
    _placeholderLabel.frame = CGRectMake(textRect.origin.x, textRect.origin.y,
                                         placeholderLabelSize.width, placeholderLabelSize.height);
    
    [self setLabelOriginForTextAlignment];
    
    BOOL firstResponder = self.isFirstResponder;
    _floatingLabel.textColor = (firstResponder && self.text && self.text.length > 0 ?
                                self.labelActiveColor : self.floatingLabelTextColor);
    if ((!self.text || 0 == [self.text length]) && !self.alwaysShowFloatingLabel) {
        [self hideFloatingLabel:firstResponder];
    }
    else {
        [self showFloatingLabel:firstResponder];
    }
    
    // Without this code, the size of the view is not calculated correctly when it
    // is first displayed. Only seems relevant when scroll is disabled.
    if (!self.scrollEnabled && !CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize textFieldIntrinsicContentSize = [super intrinsicContentSize];

    if (self.text != nil && self.text.length > 0) {
        return textFieldIntrinsicContentSize;
    } else {
        CGFloat additionalHeight = _placeholderLabel.bounds.size.height - (_floatingLabel.bounds.size.height + _floatingLabelYPadding);

        return CGSizeMake(textFieldIntrinsicContentSize.width,
                          textFieldIntrinsicContentSize.height + additionalHeight);
    }
}

- (UIColor *)labelActiveColor
{
    if (_floatingLabelActiveTextColor) {
        return _floatingLabelActiveTextColor;
    }
    else if ([self respondsToSelector:@selector(tintColor)]) {
        return [self performSelector:@selector(tintColor)];
    }
    return [UIColor blueColor];
}

- (void)setAlwaysShowFloatingLabel:(BOOL)alwaysShowFloatingLabel
{
    _alwaysShowFloatingLabel = alwaysShowFloatingLabel;
    [self setNeedsLayout];
}

- (void)showFloatingLabel:(BOOL)animated
{
    void (^showBlock)(void) = ^{
        self->_floatingLabel.alpha = 1.0f;
        CGFloat top = self->_floatingLabelYPadding;
        if (0 != self.floatingLabelShouldLockToTop) {
            top += self.contentOffset.y;
        }
        self->_floatingLabel.frame = CGRectMake(self->_floatingLabel.frame.origin.x,
                                          top,
                                          self->_floatingLabel.frame.size.width,
                                          self->_floatingLabel.frame.size.height);
    };
    
    if ((animated || 0 != _animateEvenIfNotFirstResponder)
        && (0 == self.floatingLabelShouldLockToTop || _floatingLabel.alpha != 1.0f)) {
        [UIView animateWithDuration:_floatingLabelShowAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                         animations:showBlock
                         completion:nil];
    }
    else {
        showBlock();
    }
}

- (void)hideFloatingLabel:(BOOL)animated
{
    void (^hideBlock)(void) = ^{
        self->_floatingLabel.alpha = 0.0f;
        self->_floatingLabel.frame = CGRectMake(self->_floatingLabel.frame.origin.x,
                                          self->_floatingLabel.font.lineHeight + self->_placeholderYPadding,
                                          self->_floatingLabel.frame.size.width,
                                          self->_floatingLabel.frame.size.height);
        
    };
    
    if (animated || 0 != _animateEvenIfNotFirstResponder) {
        [UIView animateWithDuration:_floatingLabelHideAnimationDuration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:hideBlock
                         completion:nil];
    }
    else {
        hideBlock();
    }
}

- (void)adjustTextContainerInsetTop
{
    self.textContainerInset = UIEdgeInsetsMake(self.startingTextContainerInsetTop
                                               + _floatingLabel.font.lineHeight + _placeholderYPadding,
                                               self.textContainerInset.left,
                                               self.textContainerInset.bottom,
                                               self.textContainerInset.right);
}

- (void)setLabelOriginForTextAlignment
{
    CGFloat floatingLabelOriginX = [self textRect].origin.x;
    CGFloat placeholderLabelOriginX = floatingLabelOriginX;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        floatingLabelOriginX = (self.frame.size.width/2) - (_floatingLabel.frame.size.width/2);
        placeholderLabelOriginX = (self.frame.size.width/2) - (_placeholderLabel.frame.size.width/2);
    }
    else if (self.textAlignment == NSTextAlignmentRight) {
        floatingLabelOriginX = self.frame.size.width - _floatingLabel.frame.size.width;
        placeholderLabelOriginX = (self.frame.size.width
                                   - _placeholderLabel.frame.size.width - self.textContainerInset.right);
    }
    else if (self.textAlignment == NSTextAlignmentNatural) {
        GitTextDirection baseDirection = [_floatingLabel.text getBaseDirection];
        if (baseDirection == GitTextDirectionRightToLeft) {
            floatingLabelOriginX = self.frame.size.width - _floatingLabel.frame.size.width;
            placeholderLabelOriginX = (self.frame.size.width
                                       - _placeholderLabel.frame.size.width - self.textContainerInset.right);
        }
    }
    
    _floatingLabel.frame = CGRectMake(floatingLabelOriginX + _floatingLabelXPadding, _floatingLabel.frame.origin.y,
                                      _floatingLabel.frame.size.width, _floatingLabel.frame.size.height);
    
    _placeholderLabel.frame = CGRectMake(placeholderLabelOriginX, _placeholderLabel.frame.origin.y,
                                         _placeholderLabel.frame.size.width, _placeholderLabel.frame.size.height);
}

- (CGRect)textRect
{
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    
    if (self.textContainer) {
        rect.origin.x += self.textContainer.lineFragmentPadding;
        rect.origin.y += self.textContainerInset.top;
    }
    
    return CGRectIntegral(rect);
}

- (void)setFloatingLabelFont:(UIFont *)floatingLabelFont
{
    _floatingLabelFont = floatingLabelFont;
    _floatingLabel.font = _floatingLabelFont ? _floatingLabelFont : [self defaultFloatingLabelFont];
    self.placeholder = self.placeholder; // Force the label to lay itself out with the new font.
}

#pragma mark - Apple UITextView defaults

+ (UIColor *)defaultiOSPlaceholderColor
{
    return [[UIColor lightGrayColor] colorWithAlphaComponent:0.65f];
}

#pragma mark - UITextView

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    [super setTextAlignment:textAlignment];
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeholderLabel.font = self.font;
    [self layoutSubviews];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self layoutSubviews];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    _placeholderTextColor = placeholderTextColor;
    _placeholderLabel.textColor = _placeholderTextColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    if (0 != self.floatingLabelShouldLockToTop) {
        _floatingLabel.backgroundColor = self.backgroundColor;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self showClearButton];
    return true;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self removeClearButton];
}

@end
