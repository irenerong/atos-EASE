//
//  EAWorkflowInfosViewController.m
//  EASE
//
//  Created by Aladin TALEB on 09/02/2015.
//  Copyright (c) 2015 Aladin TALEB. All rights reserved.
//

#import "EAWorkflowInfosViewController.h"
#import "MBPullDownController.h"



@interface EAWorkflowInfosViewController ()

@end

@implementation EAWorkflowInfosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.clipsToBounds = true;
    
    
    self.separatorView.layer.masksToBounds = false;
    self.separatorView.layer.shadowRadius = 2;
    self.separatorView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.separatorView.layer.shadowOpacity = 0.2;
    self.separatorView.layer.shadowOffset = CGSizeMake(0, 1);
    
    self.infosCollectionView.layer.masksToBounds = false;
    self.infosCollectionView.layer.shadowRadius = 2;
    self.infosCollectionView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.infosCollectionView.layer.shadowOpacity = 0.2;
    self.infosCollectionView.layer.shadowOffset = CGSizeMake(0,-1);
    
    //((UICollectionViewFlowLayout*)self.infosCollectionView.collectionViewLayout)
    
    UIEdgeInsets contentInset = UIEdgeInsetsMake(0, 0, self.pullDownController.openBottomOffset+6, 0);
    UIEdgeInsets scrollInset = UIEdgeInsetsMake(0, 0, self.pullDownController.openBottomOffset+10, 0);

    self.agentsTableView.contentInset = contentInset;
    self.agentsTableView.scrollIndicatorInsets = scrollInset;

    self.ingredientsTableView.contentInset = contentInset;
    self.ingredientsTableView.scrollIndicatorInsets = scrollInset;
    
    
    if (_workflow)
    self.workflow = _workflow;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setWorkflow:(EAWorkflow *)workflow
{
    
    _workflow = workflow;
    
    if (self.isViewLoaded)
    {
        self.view.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
        
      
        self.titleLabel.text = workflow.title;
        self.titleLabel.textColor = workflow.color;
        
        self.agentsNumberLabel.textColor = workflow.color;
        self.ingredientsNumberLabel.textColor = workflow.color;
    
        self.infosCollectionView.backgroundColor = [workflow.color colorWithAlphaComponent:0.8];
    
        
        self.ingredientsTableView.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
        self.agentsTableView.backgroundColor = [UIColor colorWithWhite:255/255.0 alpha:1.0];
        
        
        
        if (_workflow.ingredients.count)
        {
            NSMutableAttributedString *ingredientsString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d/%d", _workflow.availableIngredients, _workflow.ingredients.count] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]}];
            
            [ingredientsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Ingredients" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]}]];
            
            self.ingredientsNumberLabel.attributedText = ingredientsString;
        }
       else
       {
           self.ingredientsNumberLabel.text = @"";

       }

        
        NSMutableAttributedString *agentsString = [[NSMutableAttributedString alloc] initWithString:@""];
        
        if (_workflow.users.count)
        {
            [agentsString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d/%d", _workflow.availableUsers, _workflow.users.count] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]}]];
            
            [agentsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" User  " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]}]];
        }
        
        if (_workflow.agents.count)
        {
            [agentsString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %d/%d", _workflow.availableAgents, _workflow.agents.count] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:17]}]];
            
            [agentsString appendAttributedString:[[NSAttributedString alloc] initWithString:@" Agents" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:13]}]];
            
        }
        
        
        
        self.agentsNumberLabel.attributedText = agentsString;
        
        
        [self.imageView setImageWithProgressIndicatorAndURL:self.workflow.metaworkflow.imageURL indicatorCenter:CGPointMake(0, -50)];
        [self.imageView.progressIndicatorView setStrokeProgressColor:self.workflow.color];
        [self.imageView.progressIndicatorView setStrokeRemainingColor:[UIColor colorWithWhite:240/255. alpha:1.]];

        
        [self.buyButton setTitleColor:_workflow.color forState:UIControlStateNormal];
        
        
        
    }

}



#pragma mark - UITableViewDataSource

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    int nbItems = [self collectionView:collectionView numberOfItemsInSection:0];
    int itemWidth = collectionViewLayout.itemSize.width;
    int space = collectionViewLayout.minimumInteritemSpacing;
    
    int w = nbItems*(itemWidth+space);
    
    int delta = (collectionView.frame.size.width-w)/2;
    
    return UIEdgeInsetsMake(0, delta, 0, 0);
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.ingredientsTableView)
    {
        return _workflow.ingredients.count;
    }
    else if (tableView == self.agentsTableView)
    {
        
        if (section == 0)
            return _workflow.users.count;
        else
            return _workflow.agents.count;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.ingredientsTableView)
        return 1;
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView == self.ingredientsTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"IngredientsCell"];
        
        EAIngredient *ingredient = _workflow.ingredients[indexPath.row];
        
        cell.textLabel.text = ingredient.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f %@", ingredient.quantity, ingredient.unit];

        
        
        cell.tintColor = self.workflow.color;
        cell.accessoryType = ingredient.available ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        

    }
    else if (tableView == self.agentsTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AgentsCell"];
        
        EAAgent *agent;
        
        if (indexPath.section == 0)
            agent = _workflow.users[indexPath.row];
        
        else
            agent = _workflow.agents[indexPath.row];
        
        cell.textLabel.text = agent.name;
        cell.detailTextLabel.text =@"";

        if (![agent.type isEqualToString:@"user"])
        cell.detailTextLabel.text = agent.type;
        
        cell.tintColor = self.workflow.color;
        
        cell.accessoryType = agent.agentID > 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;

    }
    return cell;
}

#pragma mark - UITableViewDelegate



#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.workflow.consumption.allKeys.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = self.workflow.consumption;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InfoCell" forIndexPath:indexPath];
    
    NSString *key = dic.allKeys[indexPath.row];
    
    UIImageView *imageView = [cell viewWithTag:2];
    imageView.image = [UIImage imageNamed:key];
    
    UILabel *label = [cell viewWithTag:1];
    
    
    if ([key isEqualToString:@"time"])
    {
        
        int TI = ceil(((NSNumber*)dic.allValues[indexPath.row]).floatValue)/60;
        int minutes = TI%60;
        int hours =  TI/60;
        
        label.text = [NSString stringWithFormat:@"%dh%dm", hours, minutes];
        
        
    }
    else if ([key isEqualToString:@"WATER"])
        label.text = [NSString stringWithFormat:@"%0.1fL", ((NSNumber*)dic.allValues[indexPath.row]).floatValue];
    else if ([key isEqualToString:@"CO2"])
        label.text = [NSString stringWithFormat:@"%0.2fg/CO2", ((NSNumber*)dic.allValues[indexPath.row]).floatValue];

    
    
    label.textColor = [UIColor whiteColor];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
