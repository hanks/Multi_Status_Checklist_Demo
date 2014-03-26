#import "CustomCellTableViewCell.h"
#import "Checkbox.h"

#define kCatchWidth 148.0f

NSString *const CustomCellShouldHideMenuNotification = @"CustomCellShouldHideMenuNotification";

@interface CustomCellTableViewCell () <CheckboxChangeDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIView *scrollViewContentView;	//The cell content (like the label) goes in this view.
@property (nonatomic, weak) UIView *scrollViewButtonView;	//Contains our two buttons
@property (nonatomic, weak) UILabel *scrollViewLabel;

@property (nonatomic, weak) UIView *checkInfoBGView;
@property (nonatomic, weak) UIView *comletionLineView;
@property (nonatomic, assign) BOOL isShowingMenu;
@property (nonatomic, weak) UIButton *cancelButton;

@end

@implementation CustomCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
	// Set up our contentView hierarchy
	
	self.isShowingMenu = NO;
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
	scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + kCatchWidth, CGRectGetHeight(self.bounds));
	scrollView.delegate = self;
	scrollView.showsHorizontalScrollIndicator = NO;
	
	[self.contentView addSubview:scrollView];
	self.scrollView = scrollView;
	
	UIView *scrollViewButtonView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bounds) - kCatchWidth, 0.0f, kCatchWidth, CGRectGetHeight(self.bounds))];
	self.scrollViewButtonView = scrollViewButtonView;
	[self.scrollView addSubview:scrollViewButtonView];
	
	// Set up our two buttons
	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	cancelButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
	cancelButton.frame = CGRectMake(0.0f, 0.0f, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(userPressedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
	self.cancelButton = cancelButton;
    [self.scrollViewButtonView addSubview:cancelButton];
	
	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
	deleteButton.frame = CGRectMake(kCatchWidth / 2.0f, 0.0f, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
	[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollViewButtonView addSubview:deleteButton];
	
	UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
	scrollViewContentView.backgroundColor = [UIColor whiteColor];
    self.scrollViewContentView = scrollViewContentView;
	[self.scrollView addSubview:scrollViewContentView];
	
	
    // check info background view
    UIView *checkInfoBGView = [[UIView alloc] initWithFrame:CGRectMake(51.0f, 0.0f, CGRectGetWidth(self.bounds) - 51, CGRectGetHeight(self.bounds))];
    self.checkInfoBGView = checkInfoBGView;
    [self.scrollViewContentView addSubview:checkInfoBGView];
    
    // add label to checkInfoBGView
	UILabel *scrollViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 11.0f, CGRectGetWidth(self.checkInfoBGView.bounds), 21.0f)];
	self.scrollViewLabel = scrollViewLabel;
    [self.scrollViewLabel setFont:[UIFont systemFontOfSize:20.0f]];
	[self.checkInfoBGView addSubview:scrollViewLabel];
    
    // add completion line to checkInfoBGView
    UIView *completionLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, CGRectGetWidth(self.checkInfoBGView.bounds), 3)];
    [completionLineView setBackgroundColor:[UIColor grayColor]];
    [completionLineView setHidden:YES];
    self.comletionLineView = completionLineView;
    [self.checkInfoBGView addSubview:completionLineView];
    
    // add checkbox to scrollViewContentView
    Checkbox *checkbox = [[Checkbox alloc] initWithFrame:CGRectMake(14.0f, 0.0f, 29.0f, CGRectGetHeight(self.bounds))];
    self.checkbox = checkbox;
    self.checkbox.delegate = self;
    [self.scrollViewContentView addSubview:checkbox];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenuOptions) name:CustomCellShouldHideMenuNotification object:nil];
}

- (void)hideMenuOptions {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)userPressedDeleteButton:(id)sender {
    [self.delegate cellDidSelectDelete:self];
    [self hideMenuOptions];
}

- (void)userPressedCancelButton:(id)sender {
    [self.delegate cellDidSelectCancel:self];
    [self changeCellStatusWithCancelled:!self.checkbox.cancelled];
    [self hideMenuOptions];
}

- (UILabel *)textLabel {
    return self.scrollViewLabel;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.x < 0.0f) {
		scrollView.contentOffset = CGPointZero;
	}
	self.scrollViewButtonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kCatchWidth), 0.0f, kCatchWidth, CGRectGetHeight(self.bounds));
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
	if (scrollView.contentOffset.x > kCatchWidth) {
		targetContentOffset->x = kCatchWidth;
	} else {
		*targetContentOffset = CGPointZero;
		
		// Need to call this subsequently to remove flickering. Strange.
		dispatch_async(dispatch_get_main_queue(), ^{
			[scrollView setContentOffset:CGPointZero animated:YES];
		});
	}
}

#pragma mark -- CheckboxChangeDelegate Methods
- (void)changeCellStatusWithChecked:(BOOL)isChecked {
    [self.comletionLineView setHidden:!self.checkbox.checked];
    
    [self.delegate cell:self isChecked:isChecked];
    
    if (isChecked) {
        // make cell bgcolor gray
        [self.checkInfoBGView setBackgroundColor:[UIColor lightGrayColor]];
        
        // make font Italia
        [self.scrollViewLabel setFont:[UIFont italicSystemFontOfSize:20.0f]];
    } else {
        // make cell background white
        [self.checkInfoBGView setBackgroundColor: [UIColor whiteColor]];
        
        // make font normal
        [self.scrollViewLabel setFont:[UIFont systemFontOfSize:20.0f]];
    }
}

- (void)changeCellStatusWithCancelled:(BOOL)isCancelled {
    [self.comletionLineView setHidden:YES];
    self.checkbox.cancelled = isCancelled;
    [self.delegate cellDidSelectCancel:self];
    
    if (isCancelled) {
        // make cell background light yellow
        self.checkbox.checked = false;
        [self.checkInfoBGView setBackgroundColor: [UIColor yellowColor]];
        [self.cancelButton setTitle:@"Restore" forState:UIControlStateNormal];
    } else {
        // make cell background white
        [self.checkInfoBGView setBackgroundColor: [UIColor whiteColor]];
        
        // make font normal
        [self.scrollViewLabel setFont:[UIFont systemFontOfSize:20.0f]];
        
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];

    }
}


@end
