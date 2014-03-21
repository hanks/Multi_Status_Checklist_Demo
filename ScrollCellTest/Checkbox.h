#import <UIKit/UIKit.h>

@protocol CheckboxChangeDelegate <NSObject>

- (void)changeCellStatusWithChecked:(BOOL)isChecked;
- (void)changeCellStatusWithCancelled:(BOOL)isCancelled;

@end

@interface Checkbox : UIControl

@property (nonatomic, readwrite, getter = isChecked) BOOL checked;
@property (nonatomic, readwrite, getter = isCanlled) BOOL cancelled;
@property (nonatomic, weak) id<CheckboxChangeDelegate> delegate;

@end
