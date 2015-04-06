//
//  EACalendarViewController.m
//  EASE
//
//  Created by Aladin TALEB on 08/03/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACalendarViewController.h"



@interface EACalendarViewController ()


@property(nonatomic, strong) NSMutableArray *tasks;
@property(nonatomic, strong) NSMutableArray *workflows;

@end

@implementation EACalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _displayWorkflow = YES;
    
    ((EACollectionViewWorkflowLayout*)self.timelineCollectionView.collectionViewLayout).delegate = self;
    ((EACollectionViewWorkflowLayout*)self.timelineCollectionView.collectionViewLayout).minHeight = 100;
    ((EACollectionViewWorkflowLayout*)self.timelineCollectionView.collectionViewLayout).maxHeight = 200;

    ((EACollectionViewWorkflowLayout*)self.timelineCollectionView.collectionViewLayout).cellInset = CGSizeMake(5, 7);

    self.view.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1.0];
    self.timelineCollectionView.backgroundColor = [UIColor clearColor];

    
    CGFloat contentViewHeight = self.contentView.frame.size.height;
    
    self.timelineCollectionView.contentInset = UIEdgeInsetsMake(10+contentViewHeight, 72, 10, 10);
    self.timelineCollectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0+contentViewHeight, 72, 0, 0);
    
    self.dateScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.dateScrollView.color = [UIColor colorWithWhite:150/255. alpha:1.0];
    
    self.tasks = [NSMutableArray array];
    self.workflows = [NSMutableArray array];

    self.timelineCollectionView.alwaysBounceVertical = YES;
    self.timelineCollectionView.alwaysBounceHorizontal = YES;

    
    self.date = [NSDate date];
    
    self.contentView.backgroundColor = [UIColor colorWithWhite:246/255. alpha:1.];
    self.contentView.backgroundColor = [UIColor clearColor];

    /*self.contentView.layer.masksToBounds = false;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 1);
    self.contentView.layer.shadowOpacity = 0.7;
    self.contentView.layer.shadowRadius = 1;
    self.contentView.layer.shadowColor = [UIColor colorWithWhite:210/255. alpha:1.0].CGColor;
    */
    
    self.contentView.layer.borderColor = [UIColor colorWithWhite:180/255. alpha:1.].CGColor;
    self.contentView.layer.borderWidth = 0.5;
    
    self.calendar = [JTCalendar new];
    
    
    // All modifications on calendarAppearance have to be done before setMenuMonthsView and setContentView
    // Or you will have to call reloadAppearance
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.dayCircleRatio = 1;
        self.calendar.calendarAppearance.dayTextColor =[UIColor colorWithWhite:180/255. alpha:1.];
        
        self.calendar.calendarAppearance.dayCircleColorToday = [UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:1.0];
        self.calendar.calendarAppearance.dayCircleColorSelected = [UIColor colorWithRed:44/255.0 green:218/255.0 blue:252/255.0 alpha:0.3];

        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            
            return [NSString stringWithFormat:@"%ld\n%@", comps.year, monthText];
        };
        
        [self.calendar setCurrentDateSelected:self.date];
        [self.calendar setCurrentDate:[self.date dateByAddingTimeInterval:2*7*24*3600]];
        
        self.calendar.calendarAppearance.isWeekMode = true;
    }
    
    [self.calendar setContentView:self.contentView];
    [self.calendar setDataSource:self];
    
    
    [self.calendar reloadData];
    
    

    [self updateTitleWithDate:self.date];

    self.navigationItem.rightBarButtonItems = @[self.addButton, self.modeSwitchButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    [self.tasks removeAllObjects];
    [self.workflows removeAllObjects];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.timelineCollectionView.alpha = 0;
        self.dateScrollView.alpha = 0;
    } completion:^(BOOL finished) {
        
        
        if (self.displayWorkflow)
        {
            
            [[EANetworkingHelper sharedHelper] workflowsAtDay:date completionBlock:^(NSArray *workflows) {
                
                [self.workflows addObjectsFromArray:workflows];
                [self.timelineCollectionView reloadData];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.timelineCollectionView.alpha = 1;
                    self.dateScrollView.alpha = 1;
                }];
                
                
            }];
        }
        else
        {
            
            [[EANetworkingHelper sharedHelper] tasksAtDay:date completionBlock:^(NSArray *tasks) {
                
                [self.tasks addObjectsFromArray:tasks];
                [self.timelineCollectionView reloadData];
                
                [UIView animateWithDuration:0.3 animations:^{
                    self.timelineCollectionView.alpha = 1;
                    self.dateScrollView.alpha = 1;
                }];
                
                
            }];
        }
       
    }];
   
    
  
   
    
    
}

-(void)setDisplayWorkflow:(BOOL)displayWorkflow
{
    _displayWorkflow = displayWorkflow;
    
    self.date = _date;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Workflow"])
    {
        EAWorkflowMasterViewController *vc = segue.destinationViewController;
        EAWorkflow *selectedWorkflow =  _workflows[  ((NSIndexPath*) [[self.timelineCollectionView indexPathsForSelectedItems] firstObject]).row];
        
        vc.workflow = selectedWorkflow;
        
    }
    
}




#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return self.displayWorkflow ? self.workflows.count : self.tasks.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.displayWorkflow)
    {
        EACalendarWorkflowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WorkflowCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.layer.masksToBounds = false;
        cell.layer.shadowColor = [UIColor colorWithWhite:100/255. alpha:1.0].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2);
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shadowRadius = 2;
        
        cell.workflow = self.workflows[indexPath.row];
        
        return cell;
    }
    else
    {
        EACalendarTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TaskCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.layer.masksToBounds = false;
        cell.layer.shadowColor = [UIColor colorWithWhite:100/255. alpha:1.0].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0, 2);
        cell.layer.shadowOpacity = 0.5;
        cell.layer.shadowRadius = 2;
        
        cell.task = self.tasks[indexPath.row];
        
        return cell;
    }
    
   
    
    return nil;
    
}

#pragma mark - EACollectionViewWorkflowLayoutDelegate

-(EADateInterval*)collectionView:(UICollectionView *)collectionView workflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout askForDateIntervalOfTaskAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.displayWorkflow ? ((EAWorkflow*)self.workflows[indexPath.row]).dateInterval : ((EATask*)self.tasks[indexPath.row]).dateInterval;
}


-(void)collectionView:(UICollectionView *)collectionView didUpdateAnchorsForWorkflowLayout:(EACollectionViewWorkflowLayout *)workflowLayout
{
   [self.dateScrollView updateScrollViewWithTimeAnchorsDate:workflowLayout.timeAnchorsDate andTimeAnchorsY:workflowLayout.timeAnchorsY];
    [self scrollViewDidScroll:self.timelineCollectionView];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    self.dateScrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    
}

#pragma mark - JTCalendarDataSource

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
       return YES;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    self.date = date;
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded : %@", self.calendar.currentDate);
    [self updateTitleWithDate:self.calendar.currentDate];

}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded : %@", self.calendar.currentDate);
    [self updateTitleWithDate:self.calendar.currentDate];
}

-(void)updateTitleWithDate:(NSDate*)date
{
    
    NSCalendar *calendar = self.calendar.calendarAppearance.calendar;
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    NSInteger currentMonthIndex = comps.month;
    
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = self.calendar.calendarAppearance.calendar.timeZone;
    }
    
    while(currentMonthIndex <= 0){
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
    
    
}
@end
