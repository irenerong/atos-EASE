//
//  MBPullDownController.m
//  MBPullDownController
//
//  Created by Matej Bukovinski on 22. 02. 13.
//  Copyright (c) 2013 Matej Bukovinski. All rights reserved.
//

#import "MBPullDownController.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <tgmath.h>


static CGFloat const kDefaultClosedTopOffset           = 44.f;
static CGFloat const kDefaultOpenBottomOffset          = 44.f;
static CGFloat const kDefaultOpenDragOffset            = NAN;
static CGFloat const kDefaultCloseDragOffset           = NAN;
static CGFloat const kDefaultOpenDragOffsetPercentage  = .05;
static CGFloat const kDefaultCloseDragOffsetPercentage = .05;


@interface MBPullDownControllerTapUpRecognizer : UITapGestureRecognizer

@end


@interface MBPullDownControllerContainerView : UIView

@property (nonatomic, weak) MBPullDownController *pullDownController;

@end


@interface MBPullDownController ()

@property (nonatomic, strong) MBPullDownControllerTapUpRecognizer *tapUpRecognizer;
@property (nonatomic, assign) BOOL                                adjustedScroll;

@end


@implementation MBPullDownController

#pragma mark - Lifecycle

- (id)init {
    return [self initWithFrontController:nil backController:nil];
}

- (id)initWithFrontController:(UIViewController *)front backController:(UIViewController *)back {
    self = [super init];
    if (self) {
        _frontController = front;
        _backController  = back;
        [self sharedInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInitialization];
    }
    return self;
}

- (void)sharedInitialization {
    _pullToToggleEnabled       = YES;
    _closedTopOffset           = kDefaultClosedTopOffset;
    _openBottomOffset          = kDefaultOpenBottomOffset;
    _openDragOffset            = kDefaultOpenDragOffset;
    _closeDragOffset           = kDefaultCloseDragOffset;
    _openDragOffsetPercentage  = kDefaultOpenDragOffsetPercentage;
    _closeDragOffsetPercentage = kDefaultCloseDragOffsetPercentage;
    _backgroundView            = [MBPullDownControllerBackgroundView new];

    //_backgroundView.backgroundColor = [UIColor greenColor];
}

- (void)loadView {
    CGRect                            frame = [UIScreen mainScreen].bounds;
    MBPullDownControllerContainerView *view = [[MBPullDownControllerContainerView alloc] initWithFrame:frame];
    view.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.pullDownController = self;
    self.view               = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeBackControllerFrom:nil to:self.backController];
    [self changeFrontControllerFrom:nil to:self.frontController];


    self.navigationController.navigationBar.tintColor = [UIColor grayColor];

}

- (void)dealloc {
    [self cleanUpControllerScrollView:self.frontController];
}

#pragma mark - Layout

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self setOpen:self.open animated:NO];
}

#pragma mark - Controllers

- (void)setFrontController:(UIViewController *)frontController {
    if (_frontController != frontController) {
        UIViewController *oldController = _frontController;
        _frontController = frontController;
        if (self.isViewLoaded) {
            [self changeFrontControllerFrom:oldController to:frontController];
        }
    }
}

- (void)setBackController:(UIViewController *)backController {
    if (_backController != backController) {
        UIViewController *oldController = _backController;
        _backController = backController;
        if (self.isViewLoaded) {
            [self changeBackControllerFrom:oldController to:backController];
        }
    }
}

#pragma mark - Offsets

- (void)setClosedTopOffset:(CGFloat)closedTopOffset {
    [self setClosedTopOffset:closedTopOffset animated:NO];
}

- (void)setClosedTopOffset:(CGFloat)closedTopOffset animated:(BOOL)animated {
    if (_closedTopOffset != closedTopOffset) {
        _closedTopOffset = closedTopOffset;
        if (!self.open) {
            [self setOpen:NO animated:animated];
        }
    }
}

- (void)setOpenBottomOffset:(CGFloat)openBottomOffset {
    [self setOpenBottomOffset:openBottomOffset animated:NO];
}

- (void)setOpenBottomOffset:(CGFloat)openBottomOffset animated:(BOOL)animated {
    if (_openBottomOffset != openBottomOffset) {
        _openBottomOffset = openBottomOffset;
        if (self.open) {
            [self setOpen:YES animated:animated];
        }
    }
}

- (void)setOpenDragOffsetPercentage:(CGFloat)openDragOffsetPercentage {
    NSAssert(openDragOffsetPercentage >= 0.f && openDragOffsetPercentage <= 1.f,
             @"openDragOffsetPercentage out of bounds [0.f, 1.f]");
    _openDragOffsetPercentage = openDragOffsetPercentage;
}

- (void)setCloseDragOffsetPercentage:(CGFloat)closeDragOffsetPercentage {
    NSAssert(closeDragOffsetPercentage >= 0.f && closeDragOffsetPercentage <= 1.f,
             @"closeDragOffsetPercentage out of bounds [0.f, 1.f]");
    _closeDragOffsetPercentage = closeDragOffsetPercentage;
}

- (CGFloat)computedOpenDragOffset {
    if (!isnan(_openDragOffset)) {
        return _openDragOffset;
    }
    return _openDragOffsetPercentage * self.view.bounds.size.height;
}

- (CGFloat)computedCloseDragOffset {
    if (!isnan(_closeDragOffset)) {
        return _closeDragOffset;
    }
    return _closeDragOffsetPercentage * self.view.bounds.size.height;
}

#pragma mark - Open / close actions

- (void)toggleOpenAnimated:(BOOL)animated {
    [self setOpen:!_open animated:animated];
}

- (void)setOpen:(BOOL)open {
    [self setOpen:open animated:NO];
}

- (void)setOpen:(BOOL)open animated:(BOOL)animated {
    if (open != _open) {
        [self willChangeValueForKey:@"open"];
        _open = open;
        [self didChangeValueForKey:@"open"];
    }

    UIScrollView *scrollView = [self scrollView];
    if (!scrollView) {
        return;
    }

    if ([self.frontController conformsToProtocol:@protocol(MBPullDownChildController)]) {
        if (open) {
            if ([self.frontController respondsToSelector:@selector(pullDownWillOpenAnimated:)]) {
                [(id < MBPullDownChildController >)self.frontController pullDownWillOpenAnimated:animated];
            }
        } else {
            if ([self.frontController respondsToSelector:@selector(pullDownWillCloseAnimated:)]) {
                [(id < MBPullDownChildController >)self.frontController pullDownWillCloseAnimated:animated];
            }
        }
    }
    if ([self.backController conformsToProtocol:@protocol(MBPullDownChildController)]) {
        if (open) {
            if ([self.backController respondsToSelector:@selector(pullDownWillOpenAnimated:)]) {
                [(id < MBPullDownChildController >)self.backController pullDownWillOpenAnimated:animated];
            }
        } else {
            if ([self.backController respondsToSelector:@selector(pullDownWillCloseAnimated:)]) {
                [(id < MBPullDownChildController >)self.backController pullDownWillCloseAnimated:animated];
            }
        }
    }

    CGFloat offset  = open ? self.view.bounds.size.height - self.openBottomOffset : self.closedTopOffset;
    CGPoint sOffset = scrollView.contentOffset;
    // Set content inset (no animation)
    UIEdgeInsets contentInset = scrollView.contentInset;
    contentInset.top        = offset;
    scrollView.contentInset = contentInset;
    // Restor the previous scroll offset, sicne the contentInset change coud had changed it
    [scrollView setContentOffset:sOffset];

    // Update the scroll indicator insets
    void (^updateScrollInsets)(void) = ^{
        UIEdgeInsets scrollIndicatorInsets = scrollView.scrollIndicatorInsets;
        scrollIndicatorInsets.top        = offset;
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
    };
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:0 animations:updateScrollInsets completion:nil];
    } else {
        updateScrollInsets();
    }

    // Move the content

    CGFloat contentOffsetX = scrollView.contentOffset.x;

    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointMake(contentOffsetX, -offset) animated:YES];
        });
    } else {
        [scrollView setContentOffset:CGPointMake(contentOffsetX, -offset)];
    }
    if ([self.frontController conformsToProtocol:@protocol(MBPullDownChildController)]) {
        if (open) {
            if ([self.frontController respondsToSelector:@selector(pullDownDidOpenAnimated:)]) {
                [(id < MBPullDownChildController >)self.frontController pullDownDidOpenAnimated:animated];
            }
        } else {
            if ([self.frontController respondsToSelector:@selector(pullDownDidCloseAnimated:)]) {
                [(id < MBPullDownChildController >)self.frontController pullDownDidCloseAnimated:animated];
            }
        }
    }
    if ([self.backController conformsToProtocol:@protocol(MBPullDownChildController)]) {
        if (open) {
            if ([self.backController respondsToSelector:@selector(pullDownDidOpenAnimated:)]) {
                [(id < MBPullDownChildController >)self.backController pullDownDidOpenAnimated:animated];
            }
        } else {
            if ([self.backController respondsToSelector:@selector(pullDownDidCloseAnimated:)]) {
                [(id < MBPullDownChildController >)self.backController pullDownDidCloseAnimated:animated];
            }
        }
    }

    if ([self.frontController conformsToProtocol:@protocol(MBPullDownChildController)]) {
        if ([self.frontController respondsToSelector:@selector(setControllerViewEnabled:)]) {
            [(id < MBPullDownChildController >)self.frontController setControllerViewEnabled:!open];
        }
    }
}

#pragma mark - Container controller
- (UIScrollView *)scrollViewForController:(UIViewController *)controller {

    if (!controller)
        return nil;

    if ([controller respondsToSelector:@selector(scrollView)]) {
        return (UIScrollView *)[controller performSelector:@selector(scrollView)];
    } else if ([controller respondsToSelector:@selector(collectionView)]) {
        return (UIScrollView *)[controller performSelector:@selector(collectionView)];
    } else {
        return (UIScrollView *)controller.view;
    }

}

- (void)changeFrontControllerFrom:(UIViewController *)current to:(UIViewController *)new {




    [current removeFromParentViewController];
    [self cleanUpControllerScrollView:current];
    [current.view removeFromSuperview];

    if (new) {
        [self addChildViewController:new];
        UIView *containerView = self.view;
        UIView *newView       = [self scrollViewForController:new];
        NSAssert(newView || [newView isKindOfClass:[UIScrollView class]],
                 @"The front controller's view is nil.");
        if (newView) {
            newView.frame = containerView.bounds;
            [containerView addSubview:newView];
            [new didMoveToParentViewController:self];
        }
    }

    [self prepareControllerScrollView:new];
    [self setOpen:self.open animated:NO];
}

- (void)changeBackControllerFrom:(UIViewController *)current to:(UIViewController *)new {

    [current removeFromParentViewController];
    [current.view removeFromSuperview];

    if (new) {
        [self addChildViewController:new];
        UIView *containerView = self.view;
        UIView *newView       = new.view;
        if (newView) {
            newView.frame = containerView.bounds;
            [containerView insertSubview:newView atIndex:0];
            [new didMoveToParentViewController:self];
        }
    }
}

#pragma mark - BacgroundView

- (void)setBackgroundView:(UIView *)backgroundView {
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    [self initializeBackgroundView];
}

- (void)initializeBackgroundView {
    UIView       *containerView  = self.view;
    UIView       *backgroundView = self.backgroundView;
    UIScrollView *scrollView     = [self scrollView];
    if (scrollView && backgroundView) {
        backgroundView.frame = CGRectInset(containerView.bounds, 0, -20);
        [containerView insertSubview:backgroundView belowSubview:scrollView];
        [self updateBackgroundViewForScrollOfset:scrollView.contentOffset];
    }
}

- (void)updateBackgroundViewForScrollOfset:(CGPoint)offset {
    CGRect frame = self.backgroundView.frame;
    frame.origin.y            = MAX(0.f, -offset.y-10);
    self.backgroundView.frame = frame;
}

#pragma mark - ScrollView

- (UIScrollView *)scrollView {
    return [self scrollViewForController:self.frontController];
}

- (void)prepareControllerScrollView:(UIViewController *)controller {
    UIScrollView *scrollView = (UIScrollView *)[self scrollViewForController:controller];
    if (scrollView) {
        scrollView.backgroundColor      = [UIColor clearColor];
        scrollView.alwaysBounceVertical = YES;
        [self registerForScrollViewKVO:scrollView];
        [self addGestureRecognizersToView:scrollView];
        [self initializeBackgroundView];
    }
}

- (void)cleanUpControllerScrollView:(UIViewController *)controller {
    UIScrollView *scrollView = (UIScrollView *)[self scrollViewForController:controller];

    if (scrollView) {
        [self unregisterFromScrollViewKVO:scrollView];
        [self.backgroundView removeFromSuperview];
        [self removeGesureRecognizersFromView:controller.view];
    }
}

- (void)checkOpenCloseConstraints {
    BOOL    open    = self.open;
    BOOL    enabled = self.pullToToggleEnabled;
    CGPoint offset  = [self scrollView].contentOffset;
    if (!open && enabled && offset.y < -[self computedOpenDragOffset] - self.closedTopOffset) {
        [self setOpen:YES animated:YES];
    } else if (open) {
        if (enabled && offset.y > [self computedCloseDragOffset] - self.view.bounds.size.height + self.openBottomOffset) {
            [self setOpen:NO animated:YES];
        } else {
            //			[self setOpen:YES animated:YES];
            [self setOpen:(abs(offset.y) == (int)[self scrollView].bounds.size.height - self.openBottomOffset) ? NO : YES animated:YES];

        }
    }
}

#pragma mark - Gestures

- (void)addGestureRecognizersToView:(UIView *)view {
    MBPullDownControllerTapUpRecognizer *tapUp;
    tapUp = [[MBPullDownControllerTapUpRecognizer alloc] initWithTarget:self action:@selector(tapUp:)];
    [view addGestureRecognizer:tapUp];
    self.tapUpRecognizer = tapUp;
}

- (void)removeGesureRecognizersFromView:(UIView *)view {
    [view removeGestureRecognizer:self.tapUpRecognizer];
}

- (void)tapUp:(MBPullDownControllerTapUpRecognizer *)recognizer {
    [self checkOpenCloseConstraints];
}

#pragma mark - KVO

- (void)registerForScrollViewKVO:(UIScrollView *)scrollView {
    self.adjustedScroll = NO;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)unregisterFromScrollViewKVO:(UIScrollView *)scrollView {
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        UIScrollView *scrollView = object;
        if (!self.adjustedScroll) {
            CGPoint oldValue = [[change valueForKey:NSKeyValueChangeOldKey] CGPointValue];
            CGPoint newValue = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
            CGPoint adjusted = newValue;
            // Hide the scroll indicator while dragging
            if ((self.open || newValue.y < -self.closedTopOffset)) {
                scrollView.showsVerticalScrollIndicator = NO;
            } else {
                scrollView.showsVerticalScrollIndicator = YES;
            }
            // Simulate the scroll view elasticity effect while dragging in the open state
            if (self.open && [self scrollView].dragging) {
                CGFloat delta = round((oldValue.y - newValue.y) / 3);
                adjusted                 = CGPointMake(newValue.x, oldValue.y - delta);
                self.adjustedScroll      = YES; // prevent infinite recursion
                scrollView.contentOffset = adjusted;
            }
            [self updateBackgroundViewForScrollOfset:adjusted];
        } else {
            self.adjustedScroll = NO;
        }
    }
}

@end


@implementation UIViewController (MBPullDownController)

- (MBPullDownController *)pullDownController {
    UIViewController *controller = self;
    while (controller != nil) {
        if ([controller isKindOfClass:[MBPullDownController class]]) {
            return (MBPullDownController *)controller;
        }
        controller = controller.parentViewController;
    }
    return nil;
}

@end


@implementation MBPullDownControllerTapUpRecognizer

#pragma mark - Lifecycle

- (id)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.cancelsTouchesInView = NO;
        self.delaysTouchesBegan   = NO;
        self.delaysTouchesEnded   = NO;

    }
    return self;
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateRecognized;
    self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    self.state = UIGestureRecognizerStateRecognized;
    self.state = UIGestureRecognizerStateEnded;
}

#pragma mark - Tap prevention

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer {
    return NO;
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer {
    return NO;
}

@end


@implementation MBPullDownControllerBackgroundView

#pragma mark - Lifecycle

- (id)init {
    self = [super initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    if (self) {
        //self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.dropShadowVisible = true;
    }
    return self;
}

#pragma mark - Shadow

- (void)setDropShadowVisible:(BOOL)dropShadowVisible {
    if (_dropShadowVisible != dropShadowVisible) {
        CALayer *layer = self.layer;
        layer.shadowOffset  = CGSizeMake(0, -1);
        layer.shadowRadius  = 1;
        layer.shadowOpacity = dropShadowVisible ? .05f : 0.f;
        [self setNeedsLayout];
        _dropShadowVisible = dropShadowVisible;
    }
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end


@implementation MBPullDownControllerContainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIScrollView *scrollView = [self.pullDownController scrollView];
    if (scrollView) {
        CGPoint pointInScrollVeiw = [scrollView convertPoint:point fromView:self];
        if (pointInScrollVeiw.y <= 0.f) {
            return [self.pullDownController.backController.view hitTest:point withEvent:event];
        }
    }
    return [super hitTest:point withEvent:event];
}

@end