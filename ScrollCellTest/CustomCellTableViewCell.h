#import <UIKit/UIKit.h>
#import "Checkbox.h"

@class CustomCellTableViewCell;

@protocol CustomCellTableViewCellDelegate <NSObject>

- (void)cell:(CustomCellTableViewCell *)cell didShowMenu:(BOOL)isShowingMenu;

- (void)cellDidSelectDelete:(CustomCellTableViewCell *)cell;

- (void)cellDidSelectCancel:(CustomCellTableViewCell *)cell;

- (void)cell:(CustomCellTableViewCell *)cell isChecked:(BOOL)isChecked;

@end


@interface CustomCellTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CustomCellTableViewCellDelegate> delegate;
@property (nonatomic, weak) Checkbox *checkbox;

@end
