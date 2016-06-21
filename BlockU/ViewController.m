//
//  ViewController.m
//  BlockU
//
//  Created by hite on 6/21/16.
//  Copyright © 2016 hite. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UITextField *textField;
@end

@implementation ViewController
- (IBAction)toggleEditting:(id)sender {
    [self.tableView setEditing:!self.tableView.isEditing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置参数";
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(didAddToBlackList:)];
    self.navigationItem.rightBarButtonItem = save;
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:5];
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.app.blockU"];
    NSArray<NSString *> *list = [myDefaults objectForKey:@"blockList"];
    [list enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataSource addObject:obj];
    }];
    
    UITextField *tf = [[UITextField alloc] init];
    tf.frame = CGRectMake(15, 0, CGRectGetWidth(self.view.frame), 60.0f);
    tf.placeholder = @"输入手机号";
    tf.delegate = self;
    tf.text = @"13706715603";
    tf.returnKeyType = UIReturnKeyDone;
    self.textField = tf;
    self.tableView.tableHeaderView = tf;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event
- (void)didAddToBlackList:(id)sender{
    NSString *tel =  self.textField.text;
    if (tel.length == 0) {
        NSLog(@"tel is nil");
        return;
    }
    [self.dataSource addObject:tel];
    self.textField.text = @"";
    [self.textField endEditing:YES];
    [self.tableView reloadData];
    
    [self syncUD];
}

- (void)syncUD{
    //save
    NSUserDefaults *myDefaults = [[NSUserDefaults alloc]
                                  initWithSuiteName:@"group.app.blockU"];
    [myDefaults setObject:self.dataSource forKey:@"blockList"];
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField endEditing:YES];
    return YES;
}

#pragma mark - datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}


#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self syncUD];
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"kIdentiferReuseCell"];
    NSInteger row = [indexPath row];
    NSString *tel = [self.dataSource objectAtIndex:row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ blocked",tel];
    return cell;
}
@end
