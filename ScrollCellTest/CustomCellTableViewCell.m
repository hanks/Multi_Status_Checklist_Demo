//
//  CustomCellTableViewCell.m
//  ScrollCellTest
//
//  Created by 周 涵 on 2014/03/19.
//  Copyright (c) 2014年 hanks. All rights reserved.
//

#import "CustomCellTableViewCell.h"

#define kCatchWidth 148.0f

NSString *const TLSwipeForOptionsCellShouldHideMenuNotification = @"TLSwipeForOptionsCellShouldHideMenuNotification";

@interface CustomCellTableViewCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIView *scrollViewContentView;	//The cell content (like the label) goes in this view.
@property (nonatomic, weak) UIView *scrollViewButtonView;	//Contains our two buttons

@property (nonatomic, weak) UILabel *scrollViewLabel;

@property (nonatomic, assign) BOOL isShowingMenu;

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
	UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
	moreButton.backgroundColor = [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0f];
	moreButton.frame = CGRectMake(0.0f, 0.0f, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
	[moreButton setTitle:@"More" forState:UIControlStateNormal];
	[moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[moreButton addTarget:self action:@selector(userPressedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollViewButtonView addSubview:moreButton];
	
	UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
	deleteButton.backgroundColor = [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0f];
	deleteButton.frame = CGRectMake(kCatchWidth / 2.0f, 0.0f, kCatchWidth / 2.0f, CGRectGetHeight(self.bounds));
	[deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
	[deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[deleteButton addTarget:self action:@selector(userPressedDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.scrollViewButtonView addSubview:deleteButton];
	
	UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
	scrollViewContentView.backgroundColor = [UIColor whiteColor];
	[self.scrollView addSubview:scrollViewContentView];
	self.scrollViewContentView = scrollViewContentView;
	
	UILabel *scrollViewLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.scrollViewContentView.bounds, 10.0f, 0.0f)];
	self.scrollViewLabel = scrollViewLabel;
	[self.scrollViewContentView addSubview:scrollViewLabel];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenuOptions) name:TLSwipeForOptionsCellShouldHideMenuNotification object:nil];
}

- (void)hideMenuOptions {
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)userPressedDeleteButton:(id)sender {
    
}

- (void)userPressedMoreButton:(id)sender {
    
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
	
	if (scrollView.contentOffset.x >= kCatchWidth) {
		if (!self.isShowingMenu) {
			self.isShowingMenu = YES;
			//[self.delegate cell:self didShowMenu:self.isShowingMenu];
		}
	} else if (scrollView.contentOffset.x == 0.0f) {
		if (self.isShowingMenu) {
			self.isShowingMenu = NO;
			//[self.delegate cell:self didShowMenu:self.isShowingMenu];
		}
	}
}


@end
