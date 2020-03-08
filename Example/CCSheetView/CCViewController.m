//
//  CCViewController.m
//  CCSheetView
//
//  Created by Cocos on 03/07/2020.
//  Copyright (c) 2020 Cocos. All rights reserved.
//

#import "CCViewController.h"
#import "CCSheetView.h"
#import "CCFirstColumnFixedSheetCell.h"
#import "CCFirstColumnFixedSheetHeader.h"
#import "Masonry.h"

@interface CCViewController ()<UITableViewDataSource, CCSheetViewDelegate>

@property (nonatomic, strong) CCSheetView *sheetView;

@end

@implementation CCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Add SheetView
    self.sheetView = [[CCSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.sheetView.allowsSelection = YES;
    self.sheetView.delegate = self;
    self.sheetView.dataSource = self;
    [self.view addSubview:self.sheetView];
    
    [self.sheetView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.sheetView registerNib:[UINib nibWithNibName:@"CCTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    // SheetView 内部自带两个默认的Cell, 均可以支持横向扩展, 复用标记分别是CCSheetCellComponentReuseIdentifier, CCSheetHeaderComponentReuseIdentifier
    // 开发者可以自己继承Component, 实现自己的Cell.
    // CCFirstColumnFixedSheetCell是我已经实现的一个继承自CCSheetCellComponent的子类, 实现了首列不可滚动的UI
    [self.sheetView registerClass:CCFirstColumnFixedSheetCell.class forCellReuseIdentifier:CCFirstColumnFixedSheetCellReuseIdentifier];
    [self.sheetView registerClass:CCFirstColumnFixedSheetHeader.class forHeaderFooterViewReuseIdentifier:CCFirstColumnFixedSheetHeaderReuseIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource & CCSheetViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 50;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 60.f;
    }else if (section == 2) {
        return 50.f;
    }
    return 0.f;
}

- (UIView *)tableView:(CCSheetView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 要支持横向滚动的header, 必须调用dequeueReusableHeaderFooterViewWithIdentifier:forSection方法, 这样这个header才会跟着所在的section里的cell同步滚动.
    
    if (section == 1) {
        UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CCSheetHeaderComponentReuseIdentifier forSection:section];
        return header;
    }else if (section == 2) {
        CCFirstColumnFixedSheetHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CCFirstColumnFixedSheetHeaderReuseIdentifier forSection:section];
        header.firstColumnTitleLabel.text = @"首列标题";
        header.contentItems = @[@"列标题", @"列标题", @"列标题", @"列标题", @"列标题", @"列标题"];
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        CCSheetCellComponent *cell = [tableView dequeueReusableCellWithIdentifier:CCSheetCellComponentReuseIdentifier forIndexPath:indexPath];
        cell.didSelectedBlock = ^(NSIndexPath * _Nonnull indexPath) {
            NSLog(@"select %@", indexPath);
        };
        return cell;
    }else if(indexPath.section == 2) {
        // CCFirstColumnFixedSheetCell是内置的可用视图, 开发者可以自己重新开发自己的Cell
        CCFirstColumnFixedSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:CCFirstColumnFixedSheetCellReuseIdentifier forIndexPath:indexPath];
        CCFirstColumnFixedFirstItem *item = [[CCFirstColumnFixedFirstItem alloc] init];
        item.icon = [UIImage imageNamed:@"icon001"];
        item.title = [[NSAttributedString alloc] initWithString:@"固定列"];
        cell.firstItem = item;
        
        
        NSMutableArray *contents = @[].mutableCopy;
        //contentItems的数量和列数对应, contentItems.count+1等于总列数
        for (int i = 0; i < 6; i++) {
            CCFirstColumnFixedContentItem *item = [[CCFirstColumnFixedContentItem alloc] initWithIdentifier:CCSheetViewColumnCellOneTextReuseIdentifier];
            item.texts = @[[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"滚动列%@", @(i)]]];
            [contents addObject:item];
        }
        cell.contentItems = contents;
        
        cell.didSelectedBlock = ^(NSIndexPath * _Nonnull indexPath) {
            NSLog(@"select %@", indexPath);
        };
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        UILabel *label = [cell viewWithTag:1];
        label.text = @"这是一个普通Cell";
        return cell;
    }
}

- (NSArray<NSNumber *> *)sheetView:(CCSheetView *)sheetView columnsNumberAndWidthsInSection:(NSInteger)section {
    // 返回每一列的宽度, 数组长度也表示列数
    if (section == 1) {
        return @[@(100), @(100), @(100), @(100), @(100), @(100), @(100), @(100)];
    }else {
        return @[@(150), @(100), @(100), @(100), @(100), @(100), @(100)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath);
}
@end
