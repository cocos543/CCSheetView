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
        [self registerClass:CCSheetCellComponent.class forCellReuseIdentifier:FMSheetCellReuseIdentifier];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (__kindof UITableViewHeaderFooterView *)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier forSection:(NSInteger)section {
    UITableViewHeaderFooterView *view = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if ([view isKindOfClass:CCSheetHeaderComponent.class]) {
        CCSheetHeaderComponent *sheetHeader = (CCSheetHeaderComponent *)view;
        sheetHeader.belongSection = section;
        sheetHeader.columnWidths = [self.delegate sheetView:self columnsNumberAndWidthsInSection:section];
        
        [sheetHeader setNotificationDelegate:self];
    }
    return view;
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

- (BOOL)isComponentCell:(UITableViewCell *)c inTheSameSection:(NSInteger)section {
    if ([c isKindOfClass:CCSheetCellComponent.class] && [self indexPathForCell:c].section == section) {
        return YES;
    }
    return NO;
}

#pragma mark - FMSheetTVCellScrollNotifyDelegate
- (void)sheetCell:(CCSheetCellComponent *)cell scrollingOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    self.sectionOffsetCache[@(indexPath.section)] = [NSValue valueWithCGPoint:offset];
    
    // 将所有可见cell都设置为禁用同步通知, 同步完成后再恢复
    for (UITableViewCell *c in self.visibleCells) {
        if (c == cell) {
            continue;
        }
        if (![self isComponentCell:c inTheSameSection:indexPath.section]) {
            continue;
        }
        
        // cell滚动的时候, 其他需要滚动的cell都需要暂时禁止发出滚动信号, 而且也要禁止向header发出滚动信号, 这是因为header的滚动信号已经由调用当前方法(sheetCell:scrollingOffset:withState:)的cell发出了, 所以其他cell不用再重复发出信号了
        CCSheetCellComponent *visibleCell = (CCSheetCellComponent *)c;
        visibleCell.disableScrollNotify = YES;
        visibleCell.disableHeaderScrollNotify = YES;
        [visibleCell.scrollView setContentOffset:offset animated:NO];
        visibleCell.disableScrollNotify = NO;
        visibleCell.disableHeaderScrollNotify = NO;
    }
    
}

/// 该方法将会由被手指拖动到那个cell调用, 其他cell都已经被暂时禁止调用该方法了
- (void)sheetCell:(CCSheetCellComponent *)cell scrollingForHeaderOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    CCSheetHeaderComponent *header = (CCSheetHeaderComponent *)[self headerViewForSection:indexPath.section];
    header.disableScrollNotify = YES;
    [header.scrollView setContentOffset:offset animated:NO];
    header.disableScrollNotify = NO;
}

#pragma mark - CCSheetTVHeaderScrollNotifyDelegate
- (void)sheetHeader:(CCSheetHeaderComponent *)header scrollingOffset:(CGPoint)offset withState:(UIGestureRecognizerState)state {
    NSInteger section = header.belongSection;
    
    CCSheetCellComponent *cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (cell) {
        // 需要把所有可见的cell都设置为disableHeaderScrollNotify = YES, 否则除了第一个cell, 其他cell都会把滚动信号发送给header, 这样会导致信号重复发送了
        for (UITableViewCell *c in self.visibleCells) {
            if (![self isComponentCell:c inTheSameSection:section]) {
                continue;
            }
            
            CCSheetCellComponent *visibleCell = (CCSheetCellComponent *)c;
            visibleCell.disableHeaderScrollNotify = YES;
        }
        
        [cell.scrollView setContentOffset:offset animated:NO];
        
        for (UITableViewCell *c in self.visibleCells) {
            if (![self isComponentCell:c inTheSameSection:section]) {
                continue;
            }
            
            CCSheetCellComponent *visibleCell = (CCSheetCellComponent *)c;
            visibleCell.disableHeaderScrollNotify = NO;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}
@end
