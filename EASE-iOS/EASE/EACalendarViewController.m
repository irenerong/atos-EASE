//
//  EACalendarViewController.m
//  EASE
//
//  Created by Aladin TALEB on 08/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACalendarViewController.h"


#import "EASearchResults.h"
#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"
@interface EACalendarViewController ()


@property(nonatomic, strong) NSMutableArray  *tasks;
@property(nonatomic, strong) NSMutableArray  *workflows;
@property(strong, nonatomic) EASearchResults *results;

@property(nonatomic, strong) MZFormSheetController *formSheet;


@end

@implementation EACalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    _displayWorkflow = YES;

    ((EACollectionViewWorkflowLayout *)self.timelineCollectionView.collectionViewLayout).delegate    = self;
    ((EACollectionViewWorkflowLayout *)self.timelineCollectionView.collectionViewLayout).minHeight   = 170;
    ((EACollectionViewWorkflowLayout *)self.timelineCollectionView.collectionViewLayout).maxHeight   = 170;
    ((EACollectionViewWorkflowLayout *)self.timelineCollectionView.collectionViewLayout).emptyHeight = 30;
    ((EACollectionViewWorkflowLayout *)self.timelineCollectionView.collectionViewLayout).itemWidth   = 200;

    ((EACollectionViewWorkflowLayout *)self.timelineCollectionView.collectionViewLayout).cellInset = CGSizeMake(5, 7);

    self.view.backgroundColor                   = [UIColor colorWithWhite:245/255.0 alpha:1.0];
    self.timelineCollectionView.backgroundColor = [UIColor clearColor];


    CGFloat contentViewHeight = self.contentView.frame.size.height;

    self.timelineCollectionView.contentInset          = UIEdgeInsetsMake(10+contentViewHeight, 72, 10, 10);
    self.timelineCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0+contentViewHeight, 72, 0, 0);

    self.dateScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.dateScrollView.color        = [UIColor colorWithWhite:150/255. alpha:1.0];

    self.tasks     = [NSMutableArray array];
    self.workflows = [NSMutableArray array];

    self.timelineCollectionView.alwaysBounceVertical   = YES;
    self.timelineCollectionView.alwaysBounceHorizontal = YES;



    self.contentView.backgroundColor = [UIColor colorWithWhite:246/255. alpha:1.];
    self.contentView.backgroundColor = [UIColor clearColor];



    self.contentView.layer.borderColor = [UIColor colorWithWhite:180/255. alpha:1.].CGColor;
    self.contentView.layer.borderWidth = 0.5;

    self.calendar = [JTCalendar new];


    {
        self.calendar.calendarAppearance.calendar.firstWeekday      = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.dayCircleRatio             = 1;
        self.calendar.calendarAppearance.dayTextColor               = [UIColor colorWithWhite:180/255. alpha:1.];

        self.calendar.calendarAppearance.dayCircleColorToday    = [UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0];
        self.calendar.calendarAppearance.dayCircleColorSelected = [UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:0.3];

        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar       *calendar         = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps            = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger        currentMonthIndex = comps.month;

            static NSDateFormatter *dateFormatter;
            if (!dateFormatter) {
                dateFormatter          = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }

            while (currentMonthIndex <= 0) {
                currentMonthIndex += 12;
            }

            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];


            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };

        [self.calendar setCurrentDate:[[NSDate date] dateByAddingTimeInterval:2*7*24*3600]];
        [self.calendar setCurrentDateSelected:[NSDate date]];


        self.calendar.calendarAppearance.isWeekMode = true;
    }

    [self.calendar setContentView:self.contentView];
    [self.calendar setDataSource:self];
    self.date = self.calendar.currentDateSelected;

    [self.calendar reloadData];



    [self updateTitleWithDate:self.date];
    //init a normal UIButton using that image



    self.modeSwitchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [self.modeSwitchButton setBackgroundImage:[[UIImage imageNamed:@"zoom-in"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.modeSwitchButton setShowsTouchWhenHighlighted:YES];

    //set the button to handle clicks - this one calls a method called 'downloadClicked'
    [self.modeSwitchButton addTarget:self action:@selector(switchMode:) forControlEvents:UIControlEventTouchDown];
    self.modeSwitchButton.showsTouchWhenHighlighted = false;

    //finally, create your UIBarButtonItem using that button
    self.modeSwitchBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.modeSwitchButton];

    //then set it.  phew.

    self.navigationItem.rightBarButtonItems = @[self.addButton, self.modeSwitchBarButton];


}

- (void)viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.5 animations:^{
         self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0];

     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDate:(NSDate *)date {
    _date = date;

    [self.tasks removeAllObjects];
    [self.workflows removeAllObjects];


    [UIView animateWithDuration:0.3 animations:^{
         self.timelineCollectionView.alpha = 0;
         self.dateScrollView.alpha = 0;
         self.nothingToDisplayLabel.alpha = 1;
         self.nothingToDisplayLabel.text = @"Loading ...";

     } completion:^(BOOL finished) {




         [[EANetworkingHelper sharedHelper] tasksAtDay:date completionBlock:^(EASearchResults *results, NSError *error) {

              self.results = results;

              if (results && results.workflows.count) {
                  [UIView animateWithDuration:0.3 animations:^{
                       self.timelineCollectionView.alpha = 1;
                       self.dateScrollView.alpha = 1;
                       self.nothingToDisplayLabel.alpha = 0;

                   }];

              } else {
                  self.nothingToDisplayLabel.text = @"Nothing today !\nTap the '+' button to create a workflow !";

                  [UIView animateWithDuration:0.3 animations:^{
                       self.nothingToDisplayLabel.alpha = 1;
                   }];
              }

          }];

     }];






}

- (void)setResults:(EASearchResults *)results {
    _results = results;

    NSMutableArray *allTasks = [NSMutableArray array];

    for (EAWorkflow *workflow in self.results.workflows) {
        [allTasks addObjectsFromArray:[workflow tasksAtDate:self.date]];
    }

    self.tasks     = allTasks;
    self.workflows = self.results.workflows;

    [self.timelineCollectionView reloadData];


}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"Workflow"]) {
        EAWorkflowMasterViewController *vc               = segue.destinationViewController;
        EAWorkflow                     *selectedWorkflow = _workflows[  ((NSIndexPath *)[[self.timelineCollectionView indexPathsForSelectedItems] firstObject]).row];

        vc.workflow = selectedWorkflow;

    } else if ([segue.identifier isEqualToString:@"CreateWorkflow"]) {
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;

        self.formSheet                                         = formSheetSegue.formSheetController;
        self.formSheet.transitionStyle                         = MZFormSheetTransitionStyleDropDown;
        self.formSheet.cornerRadius                            = 8.0;
        self.formSheet.shouldCenterVertically                  = true;
        self.formSheet.presentedFormSheetSize                  = CGSizeMake(300, 255);
        self.formSheet.movementWhenKeyboardAppears             = MZFormSheetWhenKeyboardAppearsMoveToTopInset;
        self.formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location) {

        };

        self.formSheet.shouldDismissOnBackgroundViewTap = YES;

        self.formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController) {
            ((EASearchPopupViewController *)presentedFSViewController).delegate = self;


        };

    } else if ([segue.identifier isEqualToString:@"ShowTask"]) {
        int index = ((NSIndexPath *)self.timelineCollectionView.indexPathsForSelectedItems.firstObject).row;

        EATask *task = self.tasks[index];


        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;

        MZFormSheetController *formSheet = formSheetSegue.formSheetController;

        ((EATaskInfoViewController *)formSheet.presentedFSViewController).task = task;

        formSheet.transitionStyle        = MZFormSheetTransitionStyleDropDown;
        formSheet.cornerRadius           = 0;
        formSheet.shouldCenterVertically = true;

        CGSize screenSize = [UIScreen mainScreen].bounds.size;

        formSheet.presentedFormSheetSize = CGSizeMake(screenSize.width-50, screenSize.height-100);



        formSheet.shouldDismissOnBackgroundViewTap = YES;

        formSheet.willDismissCompletionHandler = ^(UIViewController *presentedFSViewController) {


        };

    }

}

- (void)popupFoundWorkflows:(EASearchResults *)searchResults {
    [self.formSheet dismissAnimated:true completionHandler:^(UIViewController *presentedFSViewController) {
         UINavigationController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsController"];


         ((EAWorkflowListCollectionViewController *)controller.viewControllers.firstObject).searchResults = searchResults;
         ((EAWorkflowListCollectionViewController *)controller.viewControllers.firstObject).delegate = self;

         [self presentViewController:controller animated:YES completion:nil];
     }];
}

- (void)workflowListAskToDismiss {
    [self dismissViewControllerAnimated:true completion:^{
         self.date = _date;
     }];



}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {


    return self.displayWorkflow ? self.workflows.count : self.tasks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    if (self.displayWorkflow) {
        EACalendarWorkflowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WorkflowCell" forIndexPath:indexPath];



        cell.workflow = self.workflows[indexPath.row];

        return cell;
    } else {
        EACalendarTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];

        cell.task = self.tasks[indexPath.row];

        return cell;
    }



    return nil;

}

#pragma mark - EACollectionViewWorkflowLayoutDelegate

- (EADateInterval *)collectionView:(UICollectionView *)collectionView workflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout askForDateIntervalOfTaskAtIndexPath:(NSIndexPath *)indexPath {

    return self.displayWorkflow ? ((EAWorkflow *)self.workflows[indexPath.row]).dateInterval : ((EATask *)self.tasks[indexPath.row]).dateInterval;
}

- (void)collectionView:(UICollectionView *)collectionView didUpdateAnchorsForWorkflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout {
    [self.dateScrollView updateScrollViewWithTimeAnchorsDate:workflowLayout.timeAnchorsDate andTimeAnchorsY:workflowLayout.timeAnchorsY];
    [self scrollViewDidScroll:self.timelineCollectionView];


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {


    self.dateScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);

}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date {
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date {
    self.date = date;
}

- (void)calendarDidLoadPreviousPage {
    NSLog(@"Previous page loaded : %@", self.calendar.currentDate);
    [self updateTitleWithDate:self.calendar.currentDate];

}

- (void)calendarDidLoadNextPage {
    NSLog(@"Next page loaded : %@", self.calendar.currentDate);
    [self updateTitleWithDate:self.calendar.currentDate];
}

- (void)updateTitleWithDate:(NSDate *)date {

    NSCalendar       *calendar         = self.calendar.calendarAppearance.calendar;
    NSDateComponents *comps            = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSInteger        currentMonthIndex = comps.month;

    static NSDateFormatter *dateFormatter;
    if (!dateFormatter) {
        dateFormatter          = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendar.calendarAppearance.calendar.timeZone;
    }

    while (currentMonthIndex <= 0) {
        currentMonthIndex += 12;
    }

    NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];



    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", monthText] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:19], NSForegroundColorAttributeName: [UIColor colorWithWhite:130/255. alpha:1.]}];

    [dateString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", comps.year] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:19], NSForegroundColorAttributeName: [UIColor colorWithWhite:130/255. alpha:1.]}]];


    UILabel *titleLabel = [UILabel new];

    titleLabel.attributedText = dateString;
    [titleLabel sizeToFit];

    [UIView animateWithDuration:0.3 animations:^{
         self.navigationItem.titleView.alpha = 0;
     } completion:^(BOOL finished) {
         self.navigationItem.titleView = titleLabel;
         titleLabel.alpha = 0;

         [UIView animateWithDuration:0.3 animations:^{
              titleLabel.alpha = 1;
          }];
     }];




}

- (IBAction)switchMode:(id)sender {
    self.displayWorkflow = !_displayWorkflow;



    [UIView animateWithDuration:0.3 animations:^{
         if (!self.displayWorkflow)
             [self.modeSwitchButton setImage:[[UIImage imageNamed:@"zoom-out"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];


         else
             [self.modeSwitchButton setImage:[[UIImage imageNamed:@"zoom-in"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
     }];




    self.date = _date;

}

@end
