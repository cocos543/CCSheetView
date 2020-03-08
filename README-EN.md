# CCSheetView

[! [CI Status] (https://img.shields.io/travis/Cocos/CCSheetView.svg?style=flat)] (https://travis-ci.org/Cocos/CCSheetView)
[! [Version] (https://img.shields.io/cocoapods/v/CCSheetView.svg?style=flat)] (https://cocoapods.org/pods/CCSheetView)
[! [License] (https://img.shields.io/cocoapods/l/CCSheetView.svg?style=flat)] (https://cocoapods.org/pods/CCSheetView)
[! [Platform] (https://img.shields.io/cocoapods/p/CCSheetView.svg?style=flat)] (https://cocoapods.org/pods/CCSheetView)

## Features

** CCSheetView ** inherits from ** UITableView **, which implements the horizontal scrolling function of the Cell, and supports multiple cells' horizontal synchronous scrolling. The effect looks like Office Excel, and it can display the row and column views.

Developers can customize their own Cell interface by inheriting the internal Component. For specific customization methods, please continue to see the `Tutorial` section.

** Design: **
<div>
<img src = "https://raw.githubusercontent.com/cocos543/CCSheetView/dev/demo.gif" width = "40%" />
</ div>


## compatibility

Support iOS9 and above

## Installation

``` ruby
pod 'CCSheetView'
```

## Tutorial

`CCSheetViewDelegate` inherits from` UITableViewDelegate`. Developers can implement the method `CCSheetViewDelegate` to tell ** CCSheetView ** how many columns the current Section has.

``` objc
- (NSArray<NSNumber *> *)sheetView:(CCSheetView *)sheetView columnsNumberAndWidthsInSection:(NSInteger)section {
    // 返回每一列的宽度, 数组长度也表示列数
    if (section == 1) {
        return @[@(100), @(100), @(100), @(100), @(100), @(100), @(100), @(100)];
    }else {
        return @[@(150), @(100), @(100), @(100), @(100), @(100), @(100), @(100), @(100), @(100), @(100), @(100), @(100)];
    }
}
```

Subsequently, in the Section that needs to support horizontal scrolling, the developer provides an object that inherits from the Cell or Header of the Component when returning the Cell. It can also return an ordinary Cell, so that this Cell is no different from the usual UITableView

> Note that the creation of the Header object must use the `dequeueReusableHeaderFooterViewWithIdentifier: forSection` method, otherwise the scroll event of the Header will not be passed to the Cell in the corresponding Section

``` objc
// 最简单的用法, 返回类库自带的Component
- (UIView *)tableView:(CCSheetView *)tableView viewForHeaderInSection:(NSInteger)section {    
    CCSheetHeaderComponent *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CCSheetHeaderComponentReuseIdentifier forSection:section];
    return header;
}
- (UITableViewCell *)tableView:(CCSheetView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CCSheetCellComponent *cell = [tableView dequeueReusableCellWithIdentifier:CCSheetCellComponentReuseIdentifier forIndexPath:indexPath];
    cell.didSelectedBlock = ^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"select %@", indexPath);
    };
    return cell;
}
```

> To handle the click event of Column, you need to assign the processing logic to the cell.didSelectedBlock block.

The following code demonstrates that if you customize the UI, `CCFirstColumnFixedSheetHeader` and` CCFirstColumnFixedSheetCell` are a view with the first column fixed in the class library.This view is more common in stock software.

``` objc
- (UIView *)tableView:(CCSheetView *)tableView viewForHeaderInSection:(NSInteger)section {
    // 要支持横向滚动的header, 必须调用dequeueReusableHeaderFooterViewWithIdentifier:forSection方法, 这样这个header才会跟着所在的section里的cell同步滚动.
    
    if (section == 1) {
        CCSheetHeaderComponent *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CCSheetHeaderComponentReuseIdentifier forSection:section];
        return header;
    }else if (section == 2) {
        CCFirstColumnFixedSheetHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:CCFirstColumnFixedSheetHeaderReuseIdentifier forSection:section];
        header.firstColumnTitleLabel.text = @"首列标题";
        NSInteger count = [self sheetView:tableView columnsNumberAndWidthsInSection:section].count - 1;
        NSMutableArray *contents = @[].mutableCopy;
        for (int i = 0; i < count; i++) {
            [contents addObject:@"列标题"];
        }
        header.contentItems = contents;
        return header;
    }
    return nil;
}

- (UITableViewCell *)tableView:(CCSheetView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        for (int i = 0; i < [self sheetView:tableView columnsNumberAndWidthsInSection:indexPath.section].count - 1; i++) {
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
```


## Author

Cocos543, 543314602@qq.com

## License

CCSheetView is available under the MIT license. See the LICENSE file for more info.
