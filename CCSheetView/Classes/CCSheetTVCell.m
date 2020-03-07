//
//  CCSheetTVCell.m
//
//
//  Created by Cocos on 2020/2/28.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetTVCell.h"
#import "Masonry.h"

NSString* const CCSheetFirstFixedCellReuseIdentifier = @"CCSheetFirstFixedCellReuseIdentifier";

@interface CCSheetTVCell () <UIScrollViewDelegate>

@end

@implementation CCSheetTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if ([reuseIdentifier isEqualToString:CCSheetFirstFixedCellReuseIdentifier]) {
            [self.contentView addSubview:self.scrollView];
            [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
        }

    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.disableScrollNotify = NO;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(1000, 0);
        _scrollView.delegate = self;
        
        [_scrollView addSubview:({
            UILabel *l = UILabel.new;
            l.text = @"11111111111111";
            l.textColor = UIColor.blackColor;
            l.font = [UIFont systemFontOfSize:14];
            l.frame = CGRectMake(0, 0, 200, 50);
            l;
        })];
    }
    return _scrollView;
}

#pragma mark - UIScrollViewDelegate
// 封装ScrollView的滚动事件, 表示成滚动的状态(开始, 进行, 停止)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (!self.disableScrollNotify && [self.notificationDelegate respondsToSelector:@selector(sheetCell:scrollingOffset:withState:)]) {
        [self.notificationDelegate sheetCell:self scrollingOffset:scrollView.contentOffset withState:UIGestureRecognizerStateBegan];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (!self.disableScrollNotify && [self.notificationDelegate respondsToSelector:@selector(sheetCell:scrollingOffset:withState:)]) {
        [self.notificationDelegate sheetCell:self scrollingOffset:scrollView.contentOffset withState:UIGestureRecognizerStateEnded];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.disableScrollNotify && [self.notificationDelegate respondsToSelector:@selector(sheetCell:scrollingOffset:withState:)]) {
        if (decelerate) {
            [self.notificationDelegate sheetCell:self scrollingOffset:scrollView.contentOffset withState:UIGestureRecognizerStateChanged];
        }else {
            [self.notificationDelegate sheetCell:self scrollingOffset:scrollView.contentOffset withState:UIGestureRecognizerStateEnded];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.disableScrollNotify && [self.notificationDelegate respondsToSelector:@selector(sheetCell:scrollingOffset:withState:)]) {
        [self.notificationDelegate sheetCell:self scrollingOffset:scrollView.contentOffset withState:UIGestureRecognizerStateEnded];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.disableScrollNotify && [self.notificationDelegate respondsToSelector:@selector(sheetCell:scrollingOffset:withState:)]) {
        [self.notificationDelegate sheetCell:self scrollingOffset:scrollView.contentOffset withState:UIGestureRecognizerStateChanged];
    }
}


@end
