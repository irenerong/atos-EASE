//
//  EACollectionViewWorkflowLayout.m
//  EASE
//
//  Created by Aladin TALEB on 03/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EACollectionViewWorkflowLayout.h"

@interface EACollectionViewWorkflowLayout ()

@property(nonatomic, strong) NSMutableArray *itemAttributes;
@property(nonatomic, strong) NSMutableArray *dateSupplementaryAttributes;

@property(nonatomic, strong) EADateInterval *dateInterval;
@property(nonatomic, readwrite) int nbOfColumns;

@property(nonatomic, readwrite) CGFloat yOffset;




@end

@implementation EACollectionViewWorkflowLayout



-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.itemAttributes = [NSMutableArray array];
        self.itemWidth = 240;
        self.emptyHeight = 20;
        self.minHeight = 70;
        self.maxHeight = 150;
        
        self.yOffset = 5;
        self.cellInset = CGSizeMake(5, 5);
    }
    return self;
}

-(void)prepareLayout
{
    [self.itemAttributes removeAllObjects];
    
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    if (numberOfItems <= 0)
    {
        
        
        return;
    }
    
    self.dateInterval = [EADateInterval new];
    
    NSMutableArray *taskDateIntervals;
    
    EADateInterval *firstTaskDateInterval = [self.delegate collectionView:self.collectionView workflowLayout:self askForDateIntervalOfTaskAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    
    
    if (firstTaskDateInterval)
    {
        self.dateInterval.startDate = [NSDate dateWithTimeInterval:0 sinceDate: firstTaskDateInterval.startDate];
        self.dateInterval.endDate = [NSDate dateWithTimeInterval:0 sinceDate: firstTaskDateInterval.endDate];
        taskDateIntervals = [NSMutableArray arrayWithObject:firstTaskDateInterval];
    }
    else
        return;
    
    
    //Get date interval scope
    
    for (NSInteger i = 1; i < numberOfItems; i++)
    {
        EADateInterval *taskDateInterval = [self.delegate collectionView:self.collectionView workflowLayout:self askForDateIntervalOfTaskAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        [taskDateIntervals addObject:taskDateInterval];
        
        if ([self.dateInterval.startDate compare:taskDateInterval.startDate] == NSOrderedDescending)
            self.dateInterval.startDate = [NSDate dateWithTimeInterval:0 sinceDate: taskDateInterval.startDate];
        
        if ([self.dateInterval.endDate compare:taskDateInterval.endDate] == NSOrderedAscending)
            self.dateInterval.endDate = [NSDate dateWithTimeInterval:0 sinceDate: taskDateInterval.endDate];
        
        
    }
    
    NSArray *columnDateIntervals = [self columnDateIntervalsFromDateIntervals:taskDateIntervals];
    self.nbOfColumns = columnDateIntervals.count;
    
    [self updateTimeAchorsWithDateIntervals:taskDateIntervals];
    
    
    //Update item frames
    
    for (NSInteger i = 0; i < numberOfItems; i++)
    {
        EADateInterval *taskDateInterval = taskDateIntervals[i];
        
        UICollectionViewLayoutAttributes *taskAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        CGFloat x = (self.itemWidth+1)*[self indexOfColumnOfDateInterval:taskDateInterval basedOnColumns:columnDateIntervals];
        
        CGFloat yStart = [self yForDate:taskDateInterval.startDate];
        CGFloat yEnd = [self yForDate:taskDateInterval.endDate];
        
        
        taskAttributes.frame = CGRectInset( CGRectMake(x, yStart, self.itemWidth, yEnd-yStart), self.cellInset.width, self.cellInset.height);
        
        [self.itemAttributes addObject:taskAttributes];
        
    }
    
    
    
    [self.delegate collectionView:self.collectionView didUpdateAnchorsForWorkflowLayout:self];
    
    
    
}

-(void)updateTimeAchorsWithDateIntervals:(NSArray*)dateIntervals
{
    
    /*self.timeAnchorsY = [NSMutableArray array];
     [self.timeAnchorsY addObject:@(self.yOffset)];
     [self.timeAnchorsY addObject:@(self.yOffset+1500)];
     
     
     self.timeAnchorsDate = [NSMutableArray array];
     [self.timeAnchorsDate addObject:[NSDate dateWithTimeInterval:-10*3600 sinceDate:[NSDate date]]];
     [self.timeAnchorsDate addObject:[NSDate dateWithTimeInterval:10*3600 sinceDate:[NSDate date]]];
     */
    
    
    
    
    
    self.timeAnchorsY = [NSMutableArray array];
    [self.timeAnchorsY addObject:@(self.yOffset)];
    
    self.timeAnchorsDate = [NSMutableArray array];
    [self.timeAnchorsDate addObject:self.dateInterval.startDate];
    
    
    if (!dateIntervals)
        return;
    
    BOOL fromStart;
    
    NSDate *date = [self dateAfterDate:self.dateInterval.startDate inDateIntervals:dateIntervals fromStartDate:&fromStart];
    
    
    [self.timeAnchorsY addObject:@((self.minHeight+self.maxHeight)/2)];
    [self.timeAnchorsDate addObject:date];
    
    date = [self dateAfterDate:date inDateIntervals:dateIntervals fromStartDate:&fromStart];
    
    
    while (date) {
        
        
        CGFloat previousDateY = [self yForDate:self.timeAnchorsDate.lastObject];
        
        
        
        CGFloat dateY = [self yForDate:date];
        
        CGFloat deltaDateY = dateY - previousDateY;
        
        if (!fromStart && self.timeAnchorsDate.count > 2)
            deltaDateY  = dateY - ([self yForDate:self.timeAnchorsDate[self.timeAnchorsDate.count-2]] - [self yForDate:self.timeAnchorsDate[self.timeAnchorsDate.count-3]]);
        
        
        
        if (deltaDateY >= 0.001 && !fromStart)
        {
            
            
            
            if (deltaDateY < self.minHeight)
            {
                deltaDateY = self.minHeight;
                
            }
            else if (deltaDateY > self.maxHeight)
            {
                deltaDateY = self.maxHeight;
                
            }
            
            [self.timeAnchorsY addObject:@(deltaDateY+previousDateY)];
            
            [self.timeAnchorsDate addObject:date];
        }
        else
        {
            deltaDateY = self.emptyHeight;
            [self.timeAnchorsY addObject:@(deltaDateY+previousDateY)];
            
            [self.timeAnchorsDate addObject:date];
        }
        
        
        
        date = [self dateAfterDate:date inDateIntervals:dateIntervals fromStartDate:&fromStart];
    }
    
    
}

-(NSDate*)dateAfterDate:(NSDate*)date inDateIntervals:(NSArray*)dateIntervals fromStartDate:(BOOL*)startDate;
{
    
    NSDate *nextDate;
    
    for (EADateInterval *dateInterval in dateIntervals)
    {
        if ([date compare:dateInterval.startDate] == NSOrderedAscending)
        {
            if (!nextDate || [nextDate compare:dateInterval.startDate] == NSOrderedDescending)
            {
                nextDate = dateInterval.startDate;
                *startDate = true;
            }
            
        }
        
        else if ([date compare:dateInterval.endDate] == NSOrderedAscending)
        {
            if (!nextDate || [nextDate compare:dateInterval.endDate] == NSOrderedDescending)
            {
                nextDate = dateInterval.endDate;
                *startDate = false;
                
            }
            
        }
    }
    
    return nextDate;
    
}

-(CGFloat)yForDate:(NSDate*)date
{
    
    
    
    int indexOfDate;
    
    for (indexOfDate = 0; indexOfDate < self.timeAnchorsDate.count-1; indexOfDate++)
    {
        NSDate *anchorDate = self.timeAnchorsDate[indexOfDate];
        
        if ([date compare:anchorDate] == NSOrderedAscending)
            break;
        
    }
    
    
    if (indexOfDate == 0)
        return 0;
    
    NSDate *previousAnchorDate = self.timeAnchorsDate[indexOfDate-1];
    NSDate *nextAnchorDate = self.timeAnchorsDate[indexOfDate];
    
    float previousAnchorCoef = ((NSNumber*)self.timeAnchorsY[indexOfDate-1]).floatValue;
    float nextAnchorCoef = ((NSNumber*)self.timeAnchorsY[indexOfDate]).floatValue;
    
    
    return (previousAnchorCoef+ [date timeIntervalSinceDate:previousAnchorDate]/[nextAnchorDate timeIntervalSinceDate:previousAnchorDate]*(nextAnchorCoef-previousAnchorCoef));
    
    
    
}

-(NSArray*)columnDateIntervalsFromDateIntervals:(NSArray*)dateIntervals
{
    
    NSMutableArray *columnDateIntervals = [NSMutableArray array];
    
    for (EADateInterval *dateInterval in dateIntervals)
    {
        int indexOfColumn = [self indexOfColumnOfFutureDateInterval:dateInterval basedOnColumns:columnDateIntervals];
        
        if (indexOfColumn == columnDateIntervals.count)
            [columnDateIntervals addObject:[NSMutableArray array]];
        
        [((NSMutableArray*)columnDateIntervals[indexOfColumn]) addObject:dateInterval];
        
    }
    
    return columnDateIntervals;
    
}

-(int)indexOfColumnOfDateInterval:(EADateInterval*)dateInterval basedOnColumns:(NSArray*)columnDateIntervals
{
    int nbOfColumns = columnDateIntervals.count;
    
    int indexOfColumn;
    
    for (indexOfColumn = 0; indexOfColumn < nbOfColumns; indexOfColumn++)
    {
        if ([((NSArray*)columnDateIntervals[indexOfColumn]) containsObject:dateInterval])
            return indexOfColumn;
    }
    
    return -1;
}

-(int)indexOfColumnOfFutureDateInterval:(EADateInterval*)dateInterval basedOnColumns:(NSArray*)columnDateIntervals
{
    int nbOfColumns = columnDateIntervals.count;
    
    int indexOfColumn;
    
    for (indexOfColumn = 0; indexOfColumn < nbOfColumns; indexOfColumn++)
    {
        BOOL canFitIn = true;
        for (EADateInterval *interval in columnDateIntervals[indexOfColumn])
        {
            if ([interval intersects:dateInterval])
            {
                canFitIn = false;
                break;
            }
        }
        
        if (canFitIn)
            break;
        
    }
    
    return indexOfColumn;
}


-(CGSize)collectionViewContentSize
{
    
    if (!self.dateInterval)
        return CGSizeZero;
    
    
    CGFloat width = (self.nbOfColumns)*self.itemWidth;
    
    CGFloat height = ((NSNumber*)self.timeAnchorsY.lastObject).floatValue + 2*self.yOffset;
    
    return CGSizeMake(width, height);
    
    
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    
    
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    CGFloat x = round(proposedContentOffset.x/self.itemWidth)*self.itemWidth;
//
//    return CGPointMake(x, proposedContentOffset.y);
//}

//-(UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

@end
