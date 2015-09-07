MMPopupView
=============
[![Total views](https://sourcegraph.com/api/repos/github.com/adad184/MMPopupView/.counters/views.png)](https://sourcegraph.com/github.com/adad184/MMPopupView)
[![Views in the last 24 hours](https://sourcegraph.com/api/repos/github.com/adad184/MMPopupView/.counters/views-24h.png)](https://sourcegraph.com/github.com/adad184/MMPopupView)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/MMPopupView/badge.png)](http://cocoapods.org/?q=MMPopupView)

A subclass of UITableViewCell to present the parallax effect. MMParallaxCell is a drop-in solution, basically you don't need to configure anything, but also you can customize it youself. 

Besides, you don't have to add additional codes in UITableView's Delegate Method, use it as natural as UITableViewCell :)

Parallax effect in demo project

![demo](https://github.com/adad184/MMParallaxCell/blob/master/DEMO.gif)


Installation
============

The preferred way of installation is via [CocoaPods](http://cocoapods.org). Just add

```ruby
pod 'MMParallaxCell'
```

and run `pod install`. It will install the most recent version of MMParallaxCell.

If you would like to use the latest code of MMParallaxCell use:

```ruby
pod 'MMParallaxCell', :head
```

Usage
===============

simply, you only need to set the image you wanna display.

```objc

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";
    MMParallaxCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[MMParallaxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell.parallaxImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://lorempixel.com/400/400/technics/%ld/",indexPath.row]]];
    
    return cell;
}

```


and you can change the ratio of the parallax effect.

```objc

@property (nonatomic, assign) CGFloat parallaxRatio; //ratio of cell height, should between [1.0f, 2.0f], default is 1.5f;

```
	

Changelog
===============

v1.2  now it's more safer when using KVO in code (thx @keyboardsamurai) and you can used for custom nibs (thx @kirualex)

v1.1  fixed crash caused by "removeObserver"

v1.0  you can custom or simply use it by

```objc

@interface MMParallaxCell : UITableViewCell

@property (nonatomic, strong) UIImageView *parallaxImage;

@property (nonatomic, assign) CGFloat parallaxRatio; //ratio of cell height, should between [1.0f, 2.0f], default is 1.5f;

@end
```


