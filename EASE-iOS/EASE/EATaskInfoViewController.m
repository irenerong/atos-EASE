//
//  EAPendingTaskInfoViewController.m
//  EASE
//
//  Created by Aladin TALEB on 03/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EATaskInfoViewController.h"
#import "UIImage+ImageEffects.h"
#import "UIImageView+XLProgressIndicator.h"
#import "EAWorkflow.h"
#import "NSDate+Complements.h"
@interface EATaskInfoViewController ()

@end

@implementation EATaskInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.imageView.clipsToBounds = true;
    buttons                      = [NSMutableArray array];

    self.progressBar.trackTintColor = [UIColor colorWithWhite:230 / 255. alpha:1.];

    [self.fullScreenButton setImage:[UIImage imageNamed:@"fullScreen"] forState:UIControlStateNormal];

    self.progressBar.type        = YLProgressBarTypeFlat;
    self.progressBar.hideStripes = YES;
    self.progressBar.hideGloss   = YES;

    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateDate) userInfo:nil repeats:true];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskUpdate:) name:EATaskUpdate object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTask:(EATask *)task {
    _task = task;

    if (self.isViewLoaded) {
        UIColor *color = self.task.workflow.color;

        self.agentNameBackgroundView.backgroundColor = color;

        self.workflowTitleBackgroundView.backgroundColor = [UIColor whiteColor];

        self.workflowTitleLabel.text = _task.workflow.title;


        self.fullScreenButton.tintColor = _task.workflow.color;

        NSMutableAttributedString *taskNameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _task.metatask.name] attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13] }];

        [taskNameString appendAttributedString:[[NSAttributedString alloc] initWithString:_task.title attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13] }]];

        self.taskNameLabel.numberOfLines  = 0;
        self.taskNameLabel.attributedText = taskNameString;


        self.agentNameLabel.textColor     = [UIColor whiteColor];
        self.workflowTitleLabel.textColor = color;
        self.taskNameLabel.textColor      = [UIColor whiteColor];

        self.taskNameBackgroundView.backgroundColor      = color;
        self.agentNameBackgroundView.layer.masksToBounds = false;
        self.agentNameBackgroundView.layer.shadowOffset  = CGSizeMake(0, -2);
        self.agentNameBackgroundView.layer.shadowOpacity = 0.2;
        self.agentNameBackgroundView.layer.shadowRadius  = 2;
        self.agentNameBackgroundView.layer.shadowColor   = [UIColor blackColor].CGColor;

        self.taskNameBackgroundView.layer.masksToBounds = false;
        self.taskNameBackgroundView.layer.shadowOffset  = CGSizeMake(0, 0);
        self.taskNameBackgroundView.layer.shadowOpacity = 0.1;
        self.taskNameBackgroundView.layer.shadowRadius  = 1;
        self.taskNameBackgroundView.layer.shadowColor   = [UIColor blackColor].CGColor;

        self.dateBackgroundView.layer.masksToBounds = false;
        self.dateBackgroundView.layer.shadowOffset  = CGSizeMake(0, 0);
        self.dateBackgroundView.layer.shadowOpacity = 0.1;
        self.dateBackgroundView.layer.shadowRadius  = 3;
        self.dateBackgroundView.layer.shadowColor   = [UIColor blackColor].CGColor;

        self.buttonsBackgroundView.backgroundColor     = color;
        self.buttonsBackgroundView.layer.masksToBounds = false;
        self.buttonsBackgroundView.layer.shadowOffset  = CGSizeMake(0, -2);
        self.buttonsBackgroundView.layer.shadowOpacity = 0.2;
        self.buttonsBackgroundView.layer.shadowRadius  = 3;
        self.buttonsBackgroundView.layer.shadowColor   = [UIColor blackColor].CGColor;

        self.beginLabel.textColor = color;
        self.endLabel.textColor   = color;

        self.progressBar.progressTintColors = @[color, color];


        NSMutableAttributedString *agentsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", _task.agent.name] attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13] }];

        [agentsString appendAttributedString:[[NSAttributedString alloc] initWithString:_task.agent.type attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13] }]];

        self.agentNameLabel.attributedText = agentsString;




        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle                  = NSDateFormatterShortStyle;
        dateFormatter.dateStyle                  = NSDateFormatterShortStyle;
        dateFormatter.doesRelativeDateFormatting = YES;

        self.beginLabel.text = [[dateFormatter stringFromDate:self.task.dateInterval.startDate] stringByReplacingOccurrencesOfString:@", " withString:@"\n"];
        self.endLabel.text   = [[dateFormatter stringFromDate:self.task.dateInterval.endDate] stringByReplacingOccurrencesOfString:@", " withString:@"\n"];

        [self updateDate];

        for (UIButton *button in buttons)
            [button removeFromSuperview];
        [buttons removeAllObjects];




        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, self.view.frame.size.width, self.buttonsBackgroundView.frame.size.height - 3)];
        [button addTarget:self action:@selector(didTapCenterButton:) forControlEvents:UIControlEventTouchUpInside];

        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateHighlighted];

        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];


        if (_task.status == EATaskStatusPending)
            [button setTitle:@"Start" forState:UIControlStateNormal];

        else if (_task.status == EATaskStatusWorking)
            [button setTitle:@"Done" forState:UIControlStateNormal];

        else
            [button setTitle:@"" forState:UIControlStateNormal];


        [self.buttonsBackgroundView addSubview:button];
        [buttons addObject:button];


        [button mas_makeConstraints:^(MASConstraintMaker *make) {
             make.edges.equalTo(button.superview).with.insets(UIEdgeInsetsMake(5, 5, 5, 5));
         }];




        [self.descriptionView loadHTMLString:task.metatask.htmlDescription baseURL:nil];


        [self.imageView setImageWithProgressIndicatorAndURL:self.task.workflow.metaworkflow.imageURL];
        [self.imageView.progressIndicatorView setStrokeProgressColor:color];

        [self.imageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240 / 255. alpha:1.]];




        if (_task.status == EATaskStatusPending) {
            self.statusLabel.text = @"Pending";
            self.progressBar.progress = 0;

        } else if (_task.status == EATaskStatusWorking) {
            self.statusLabel.text     = [NSString stringWithFormat:@"Working (%d%%)", (int)(100 * self.task.completionPercentage)];
            self.progressBar.progress = self.task.completionPercentage;
        } else if (_task.status == EATaskStatusFinished) {
            self.statusLabel.text     = @"Finished";
            self.progressBar.progress = 1;
        }
        else
            
        {
            self.progressBar.progress = 0;

        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
}

- (void)updateDate {
    if (_task) {
        if (_task.status == EATaskStatusWorking) {
            self.timeStatusLabel.text = [NSString stringWithFormat:@"%@ left", [NSDate timeLeftMessage:_task.timeLeft]];
        } else if (_task.status == EATaskStatusPending) {
            self.timeStatusLabel.text = [NSDate lateFromDate:self.task.dateInterval.startDate];
        } else {
            self.timeStatusLabel.text = @"";
        }
    }
}

- (void)didTapCenterButton:(UIButton *)sender {
    [sender setEnabled:false];

    if (_task.status == EATaskStatusPending) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.showAnimationType = SlideInFromCenter;
        alert.backgroundType    = Blur;
        alert.customViewColor   = [UIColor colorWithWhite:200 / 255. alpha:1.0];
        alert.iconTintColor     = [UIColor whiteColor];

        [alert addButton:@"Everything's ok ! Let's do it !" actionBlock:^{
             [[EANetworkingHelper sharedHelper] startTask:self.task completionBlock:^(NSError *error) {
                  NSLog(@"START !");
                  [sender setEnabled:true];
              }];
         }];

        [alert showWarning:self title:@"Warning" subTitle:@"Do you really want to fire this task ? (Be sure you're next to the device !)" closeButtonTitle:@"Let me check ..." duration:0];
    }
    if (_task.status == EATaskStatusWorking) {
        [[EANetworkingHelper sharedHelper] finishTask:self.task completionBlock:^(NSError *error) {
             NSLog(@"FINISH !");
             [sender setEnabled:true];
         }];
    }
}

- (void)taskUpdate:(NSNotification *)notification {
    if (!_task)
        return;
    int taskID = ((NSNumber *)notification.userInfo[@"id"]).intValue;

    if (taskID == _task.taskID)
        [_task updateWithFeedback:notification.userInfo[@"data"]];

    self.task = _task;
}

- (IBAction)descFullScreen:(id)sender {
    self.fullScreenWebView                          = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.fullScreenWebView.scrollView.contentOffset = self.descriptionView.scrollView.contentOffset;

    _disableFullScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 35, self.view.bounds.size.height - 35, 30, 30)];
    [_disableFullScreenButton setImage:[[UIImage imageNamed:@"notFullScreen"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];

    _disableFullScreenButton.tintColor = _task.workflow.color;
    _disableFullScreenButton.alpha     = 0;
    [_disableFullScreenButton addTarget:self action:@selector(descDisableFullScreen:) forControlEvents:UIControlEventTouchUpInside];


    self.fullScreenWebView.alpha = 0;

    NSString *html = _task.metatask.htmlDescription;
    [self.fullScreenWebView loadHTMLString:html baseURL:nil];

    [self.view addSubview:self.fullScreenWebView];

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
         self.descriptionView.alpha = 0;
         self.fullScreenWebView.alpha = 1;
     } completion:^(BOOL finished) {
         [self.view addSubview:_disableFullScreenButton];

         [UIView animateWithDuration:0.3 animations:^{
              _disableFullScreenButton.alpha = 1;
          }];
     }];
}

- (void)descDisableFullScreen:(id)sender {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:0 animations:^{
         self.descriptionView.scrollView.contentOffset = self.fullScreenWebView.scrollView.contentOffset;
         self.fullScreenWebView.alpha = 0;
         self.disableFullScreenButton.alpha = 0;
         self.descriptionView.alpha = 1;
     } completion:^(BOOL finished) {
         [self.disableFullScreenButton removeFromSuperview];
         [self.fullScreenWebView removeFromSuperview];
     }];
}

@end
