//
//  CCSheetView.m
//  
//
//  Created by Cocos on 2020/2/27.
//  Copyright © 2020 Cocos. All rights reserved.
//

#import "CCSheetView.h"

@interface CCSheetView () <UIScrollViewDelegate>

/// 用来缓存每一个section的对应的横向offset, 这样能保证每一个section的横向offset都是独立的
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSValue *> *sectionOffsetCache;

@end

@implementation CCSheetView
@dynamic delegate;

- (NSMutableDictionary<NSNumber *,NSValue *> *)sectionOffsetCache {
    if (!_sectionOffsetCache) {
        _sectionOffsetCache = @{}.mutableCopy;
    }
    return _sectionOffsetCache;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self registerClass:CCSheetCellComponent.class forCellReuseIdentifier:CCSheetCellReuseIdentifier];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if ([cell isKindOfClass:CCSheetCellComponent.class]) {
        CCSheetCellComponent *sheetCell = (CCSheetCellComponent *)cell;
        
        // 代理必须实现该方法
        sheetCell.columnWidths = [self.delegate sheetView:self columnsNumberAndWidthsInSection:indexPath.section];
        
        [sheetCell setNotificationDelegate:self];
        // 新的cell在出现在屏幕之前, 最好是能够知道他初始的contentOffset, 所以这里需要找到合适的contentOffset设置给他
        
        // 标记是否在屏幕上找到相同的section, 如果没有, 则从cache中找到初始的offset
        BOOL bingoFlag = NO;
        for (UITableViewCell *c in self.visibleCells) {
            if (![c isKindOfClass:CCSheetCellComponent.class]) {
                continue;
            }
            
            if ([self indexPathForCell:c].section != indexPath.section) {
                continue;
            }
            
            CCSheetCellComponent *visibleCell = (CCSheetCellComponent *)c;
            sheetCell.disableScrollNotify = YES;
            [sheetCell.scrollView setContentOffset:visibleCell.scrollView.contentOffset animated:NO];
            sheetCell.disableScrollNotify = NO;
            bingoFlag = YES;
            break;
        }
        if (!bingoFlag) {
            [sheetCell.scrollView setContentOffset:[self.sectionOffsetCache[@(indexPath.section)] CGPointValue] animated:NO];
        }
    }
    
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        
    }
}

#pragma mark - CCSheetTVCellScrollNotifyDelegate
- (void)sheetCell:(CCSheetCellComponent *)cell scrollingOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    self.sectionOffsetCache[@(indexPath.section)] = [NSValue valueWithCGPoint:offset];
    
    // 将所有可见cell都设置为禁用同步通知, 同步完成后再恢复
    for (UITableViewCell *c in self.visibleCells) {
        if (c == cell) {
            continue;
        }
        if (![c isKindOfClass:CCSheetCellComponent.class]) {
            continue;
        }
        
        if ([self indexPathForCell:c].section != indexPath.section) {
            continue;
        }
        
        CCSheetCellComponent *visibleCell = (CCSheetCellComponent *)c;
        visibleCell.disableScrollNotify = YES;
        [visibleCell.scrollView setContentOffset:offset animated:NO];
        visibleCell.disableScrollNotify = NO;
    }
    
}

@end
