//
//  EASearchSortTableViewController.m
//  EASE
//
//  Created by Aladin TALEB on 14/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EASearchSortTableViewController.h"

@interface EASearchSortTableViewController ()

@property(nonatomic, retain) NSArray *sortStrings;
@property(nonatomic, readwrite) int sortIndex;


@end

@implementation EASearchSortTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.sortIndex = 1;
    
    self.sortStrings = @[@"Consumption", @"Title", @"Duration"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSortIndex:(int)sortIndex
{
    _sortIndex = sortIndex;
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.sortStrings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    
    cell.textLabel.text = self.sortStrings[indexPath.row];
    
    if (self.sortIndex != 0)
    {
        
        int index = self.sortIndex;
        
        if (index < 0)
            index *= -1;
        
        index--;
        
        if (index == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            cell.detailTextLabel.text = @"";

           /* if (self.sortIndex < 0)
                cell.detailTextLabel.text = @"Décroissant";
            else
                cell.detailTextLabel.text = @"Croissant";
            
            */
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = @"";

        }

    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int index = self.sortIndex;
    
    if (index < 0)
        index = -1*index;
    
    index--;

    
    if (index == indexPath.row)
    {
        self.sortIndex *= -1;
    }
    else
    {
        self.sortIndex = indexPath.row+1;
    }
    
    [tableView reloadData];
    
}

-(void)setSortBy:(NSString*)string
{
        if ([string isEqualToString:@"consumption"])
            self.sortIndex = 1;
    else if ([string isEqualToString:@"title"])
        self.sortIndex = 2;
    else if ([string isEqualToString:@"duration"])
        self.sortIndex = 3;
}

-(NSString*)sortBy
{
    
    switch (abs(self.sortIndex)) {
        case 1:
            return @"consumption";
            break;
            
        case 2:
            return @"title";
            break;
            
        case 3:
            return @"duration";
            break;
            
        default:
            break;
    }
    
    return @"";
}
@end
