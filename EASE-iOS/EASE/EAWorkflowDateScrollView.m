//
//  EAWorkflowDateScrollView.m
//  EASE
//
//  Created by Aladin TALEB on 04/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflowDateScrollView.h"

@interface EAWorkflowDateScrollView ()
@property(nonatomic, strong) NSMutableArray *labelsArray;
@property(nonatomic, strong) NSMutableArray *auxLabelsArray;


@end

@implementation EAWorkflowDateScrollView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self initialize];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    
    return self;
}

-(void)initialize
{
    self.scrollEnabled = false;
    self.showsHorizontalScrollIndicator = false;
    self.showsVerticalScrollIndicator = false;
    
    self.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
    self.layer.masksToBounds = false;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1, 0);
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowRadius = 2;
    
     self.labelsArray = [NSMutableArray array];
    self.auxLabelsArray = [NSMutableArray array];

    
    
    
}

-(void)setColor:(UIColor *)color
{
    
    _color = color;
    
    //self.backgroundColor = [self.color colorWithAlphaComponent:0.7];
    
    for (UIView *view in self.labelsArray)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            ((UILabel*)view).textColor = _color;
        }
        else
        {
            view.backgroundColor = _color;
        }
    }
    
}

-(void)updateScrollViewWithTimeAnchorsDate:(NSArray*)timeAnchorsDate andTimeAnchorsY:(NSArray*)timeAnchorsY
{
    

    CGFloat width = self.frame.size.width;
    CGFloat height = ((NSNumber*)timeAnchorsY.lastObject).floatValue;
    
    self.contentSize = CGSizeMake(width, height);
    
    for (UIView *view in self.labelsArray)
         [view removeFromSuperview];
    for (UIView *view in self.auxLabelsArray)
        [view removeFromSuperview];
    
    [self.labelsArray removeAllObjects];
    [self.auxLabelsArray removeAllObjects];

    
    for (int i = 0; i< timeAnchorsDate.count-1; i++)
        [self createLabelsBetweenDate:timeAnchorsDate[i] atY:((NSNumber*)timeAnchorsY[i]).floatValue andDate:timeAnchorsDate[i+1] atY:((NSNumber*)timeAnchorsY[i+1]).floatValue];
    
    
    [self createLabelsBetweenDate:timeAnchorsDate[timeAnchorsDate.count-1] atY:((NSNumber*)timeAnchorsY[timeAnchorsDate.count-1]).floatValue andDate:nil atY:0];

}

-(void)createLabelsBetweenDate:(NSDate*)date1 atY:(CGFloat)Y1 andDate:(NSDate*)date2 atY:(CGFloat)Y2
{
    const CGFloat labelHeight = 12;
    const NSArray *tickIntervals = @[@0, @1, @2, @5, @15, @30, @60, @120, @300, @600];
    const NSArray *tickMustSee = @[@60, @60, @60, @60, @60, @60, @60, @60, @300, @300];

    const NSDateFormatter * f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"HH:mm"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y1, self.frame.size.width-45, 1)];
    line.backgroundColor = self.color;
    
    [self.labelsArray addObject:line];
    [self addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, Y1-labelHeight/2, self.frame.size.width-5, labelHeight)];
    
    
    
    label.textColor = self.color;
    label.text = [f stringFromDate:date1];
    label.textAlignment = NSTextAlignmentRight;
    //label.alpha = 0.7;
    
    label.font  = [UIFont fontWithName:@"HelveticaNeue" size:13];
    
    [self.labelsArray addObject:label];
    
    [self addSubview:label];
    
    
    if (!date2)
        return;
    

    NSTimeInterval interval = [date2 timeIntervalSinceDate:date1];
    
    int nbOfTicks = (Y2-Y1-labelHeight-10)/(labelHeight+10);
    
    NSTimeInterval tickInterval = interval/nbOfTicks;
    
    NSLog(@"Real tick interval : %f", tickInterval);
    
    int indexOfTickInterval;
    
    for (indexOfTickInterval = 0; indexOfTickInterval < tickIntervals.count; indexOfTickInterval++) {
        if (tickInterval <= ((NSNumber*)tickIntervals[indexOfTickInterval]).intValue)
        {
            tickInterval =  ((NSNumber*)tickIntervals[indexOfTickInterval]).intValue;
            break;
        }
    }
    
    
    
    NSLog(@"Round tick interval : %f", tickInterval);

    if (tickInterval <= 1)
        return;
    
    NSTimeInterval date1Timestamp = [date1 timeIntervalSince1970];
    date1Timestamp = ceil(date1Timestamp/tickInterval)*tickInterval;
    
    NSDate *date1Unit = [NSDate dateWithTimeIntervalSince1970:date1Timestamp];
    
    
    NSLog(@"\nDate1 : %@\nDate1Round : %@", date1, date1Unit);
    
    while ([date1Unit compare:date2] == NSOrderedAscending) {
        
        NSTimeInterval date1Interval = [date1Unit timeIntervalSinceDate:date1];
        
        
        CGFloat y = Y1+(Y2-Y1)*date1Interval/interval;
        if (y < Y2-labelHeight/2-10 && y > Y1+labelHeight/2+10)
        {
            
            
            int indexOfRealTickInterval;
            
            for (indexOfRealTickInterval = tickIntervals.count-1; indexOfRealTickInterval >= 0; indexOfRealTickInterval--) {
                if ((int)date1Timestamp % ((NSNumber*)tickIntervals[indexOfRealTickInterval]).intValue == 0 )
                    break;
            }
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y, 5+indexOfRealTickInterval, 1)];
            line.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1.0];

            //line.alpha = 0.7;
            [self addSubview:line];
            
            [self.auxLabelsArray addObject:line];
            
            
            if ((int)date1Timestamp% ((NSNumber*)tickMustSee[indexOfRealTickInterval]).intValue == 0)
            {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y-labelHeight/2, self.frame.size.width-5, labelHeight)];
                
                //label.alpha = 0.7;
                label.text = [f stringFromDate:date1Unit];
                label.textAlignment = NSTextAlignmentRight;
                
                
                label.font  = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
                label.textColor = [UIColor colorWithWhite:200/255.0 alpha:1.0];

                [self.auxLabelsArray addObject:label];
                
                [self addSubview:label];
                
                
            }
            
        }
        
        
      
        
        date1Unit = [date1Unit dateByAddingTimeInterval:tickInterval];
        date1Timestamp+=tickInterval;
        
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
