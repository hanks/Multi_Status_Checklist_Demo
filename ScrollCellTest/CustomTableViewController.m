#import "CustomTableViewController.h"
#import "CustomCellTableViewCell.h"

@interface CustomTableViewController () <CustomCellTableViewCellDelegate>

@property NSMutableArray *_objects;
@property (nonatomic, weak)UIView *progressBarView;
@property (nonatomic, weak)UILabel *percentageLabel;
@property (nonatomic, weak)UIView *progressBar;

@property int percentageValue;

@end

@implementation CustomTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self loadInitData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadInitData];
    [self initProgressbarView];
}

- (void)initProgressbarView {
    UIView *progressBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), 20)];
    self.progressBarView = progressBarView;
    
    UILabel *percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 1.0f, 20.0f, 20.0f)];
    percentageLabel.text = @"0%";
    percentageLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    percentageLabel.textAlignment = NSTextAlignmentRight;
    self.percentageLabel = percentageLabel;
    [self.progressBarView addSubview:percentageLabel];
    
    UIView *progressBar = [[UIView alloc] initWithFrame:CGRectMake(49.0f, 3.0f, CGRectGetWidth(self.tableView.bounds) - 51, 15.f)];
    [progressBar setBackgroundColor:[self colorFromHexString:@"#D9D9D9"]];
    [progressBar.layer setCornerRadius:6.0f];
    self.progressBar = progressBar;
    [self.progressBarView addSubview:self.progressBar];
    
    self.tableView.tableHeaderView = self.progressBarView;
    
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (void)loadInitData {
    self._objects = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [self._objects addObject:[NSString stringWithFormat:@"task_%d", i]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self._objects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [self._objects objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CustomCellTableViewCellDelegate Methods
- (void)cell:(CustomCellTableViewCell *)cell didShowMenu:(BOOL)isShowingMenu {
    
}

- (void)cellDidSelectDelete:(CustomCellTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self._objects removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)cellDidSelectCancel:(CustomCellTableViewCell *)cell {
    
}

@end
