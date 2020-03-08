# CCSheetView

[![CI Status](https://img.shields.io/travis/Cocos/CCSheetView.svg?style=flat)](https://travis-ci.org/Cocos/CCSheetView)
[![Version](https://img.shields.io/cocoapods/v/CCSheetView.svg?style=flat)](https://cocoapods.org/pods/CCSheetView)
[![License](https://img.shields.io/cocoapods/l/CCSheetView.svg?style=flat)](https://cocoapods.org/pods/CCSheetView)
[![Platform](https://img.shields.io/cocoapods/p/CCSheetView.svg?style=flat)](https://cocoapods.org/pods/CCSheetView)

## 功能介绍

**CCSheetView**继承自**UITableView**, 它实现了Cell的横向滚动功能, 并且支持多个Cell横向同步滚动, 效果看起来就像Office Excel, 能展示出行列视图.

通过继承内部的Component, 来定制自己的Cell界面.

 其中Component内部已经集成了一个UICollectionView,  并提供了UIScrollView和UICollectionView两个属性(指向同一个CollectionView), 用户可以向UICollectionView注册新的ColumnCell来定制列UI, 这样的好处是横向滚动也支持复用, 也可以简单使用UIScrollView作为横向滚动的承载视图. 或者完成重写Component的布局, 自己设计Cell. 
 
 需要注意的是, Cell和Header子类必须要继承自Component, 提供UIScrollView或者子类, 这个是支持横向滚动的关键.

具体定制方法可以继续往下看`教程`部分.

**效果图:**
<div>
<img src="https://raw.githubusercontent.com/cocos543/CCSheetView/dev/demo.gif"  width="40%"/>
</div>


## 兼容性

支持 iOS9 以上

## 安装

```ruby
pod 'CCSheetView'
```

## 教程

`CCSheetViewDelegate`继承自`UITableViewDelegate`,  开发者可以实现`CCSheetViewDelegate`的方法, 用来告诉**CCSheetView**当前的Section一共有多少列.

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

随后, 在需要支持横向滚动的Section里, 开发者在返回Cell的时候, 提供继承自Component的Cell或者Header的对象.  也可以返回普通的Cell, 这样这个Cell就和平时UITableView中的没什么区别了.

> Component类中有一个ScrollView属性, 这个属性就是用来实现横向滚动, 开发者可以根据需求来重写ScrollView的布局
> 需要注意的是, Header对象的创建必须使用`dequeueReusableHeaderFooterViewWithIdentifier:forSection`方法, 否则Header的滚动事件不会传递给对应Section中的Cell

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

> 处理Column的点击事件, 需要把处理逻辑赋值给`cell.didSelectedBlock`这个Block.

下面代码演示了如果定制UI, 其中`CCFirstColumnFixedSheetHeader `和`CCFirstColumnFixedSheetCell `就是类库自带的一个首列被固定住的视图, 这种视图在股票软件里面是比较常见的.

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


## 作者

Cocos543, 543314602@qq.com

## License

CCSheetView is available under the MIT license. See the LICENSE file for more info.
