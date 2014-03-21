#import <UIKit/UIKit.h>

@class CustomCellTableViewCell;

@protocol CustomCellTableViewCellDelegate <NSObject>

- (void)cell:(CustomCellTableViewCell *)cell didShowMenu:(BOOL)isShowingMenu;

- (void)cellDidSelectDelete:(CustomCellTableViewCell *)cell;

- (void)cellDidSelectCancel:(CustomCellTableViewCell *)cell;

@end

@interface CustomCellTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CustomCellTableViewCellDelegate> delegate;

@end
