//
//  ScrollableTarget.m
//  ListModelTest
//
//  Created by Aaron on 2021/5/15.
//

#import "ScrollableTarget.h"

@implementation ScrollableTarget

- (nonnull NSArray<NSString *> *)supportedSelectors {
    NSMutableArray<NSString *> *selectors = [NSMutableArray array];
    [selectors addObjectsFromArray: @[
        NSStringFromSelector(@selector(scrollViewDidZoom:)),
        NSStringFromSelector(@selector(scrollViewWillBeginDragging:)),
        NSStringFromSelector(@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)),
        NSStringFromSelector(@selector(scrollViewDidEndDragging:willDecelerate:)),
        NSStringFromSelector(@selector(scrollViewWillBeginDecelerating:)),
        NSStringFromSelector(@selector(scrollViewDidEndDecelerating:)),
        NSStringFromSelector(@selector(scrollViewDidEndScrollingAnimation:)),
        NSStringFromSelector(@selector(viewForZoomingInScrollView:)),
        NSStringFromSelector(@selector(scrollViewWillBeginZooming:withView:)),
        NSStringFromSelector(@selector(scrollViewDidEndZooming:withView:atScale:)),
        NSStringFromSelector(@selector(scrollViewShouldScrollToTop:)),
        NSStringFromSelector(@selector(scrollViewDidScrollToTop:)),
    ]];
    if (@available(iOS 11.0, *)) {
        [selectors addObject:NSStringFromSelector(@selector(scrollViewDidChangeAdjustedContentInset:))];
    }
    return selectors;
}

// MARK: - UIScrollView
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (self.didZoom != nil) {
        self.didZoom(scrollView);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.willBeginDragging != nil) {
        self.willBeginDragging(scrollView);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.willEndDragging != nil) {
        self.willEndDragging(scrollView, velocity, targetContentOffset);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.didEndDragging != nil) {
        self.didEndDragging(scrollView, decelerate);
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.willBeginDecelerating != nil) {
        self.willBeginDecelerating(scrollView);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.didEndDecelerating != nil) {
        self.didEndDecelerating(scrollView);
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.didEndScrollingAnimation != nil) {
        self.didEndScrollingAnimation(scrollView);
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (self.viewForZooming != nil) {
        return self.viewForZooming(scrollView);
    }
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if (self.willBeginZooming != nil) {
        self.willBeginZooming(scrollView, view);
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if (self.didEndZooming != nil) {
        self.didEndZooming(scrollView, view, scale);
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if (self.shouldScrollToTop != nil) {
        return self.shouldScrollToTop(scrollView);
    }
    return true;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if (self.didScrollToTop != nil) {
        self.didScrollToTop(scrollView);
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    if (self.adjustedContentInsetChanged != nil) {
        self.adjustedContentInsetChanged(scrollView);
    }
}

@end
