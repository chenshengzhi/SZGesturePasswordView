//
//  ViewController.m
//  SZGesturePasswordViewDemo
//
//  Created by 陈圣治 on 16/6/28.
//  Copyright © 2016年 陈圣治. All rights reserved.
//

#import "ViewController.h"
#import "SZGesturePasswordView.h"
#import "DataSourceModel.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) NSString *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _datasource = @[
                    [DataSourceModel modelWithTitle:@"3级" config:^(SZGesturePasswordView *gpView) {
                        gpView.edgeInset = UIEdgeInsetsMake(40, 40, 40, 40);
                    }],
                    [DataSourceModel modelWithTitle:@"4级" config:^(SZGesturePasswordView *gpView) {
                        gpView.dotViewsPadding = 20;
                        gpView.level = 4;
                    }],
                    [DataSourceModel modelWithTitle:@"安全输入" config:^(SZGesturePasswordView *gpView) {
                        gpView.isSecure = YES;
                    }],
                    [DataSourceModel modelWithTitle:@"可重复" config:^(SZGesturePasswordView *gpView) {
                        gpView.canDuplicateSelect = YES;
                    }],
                    ];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"IB" style:UIBarButtonItemStylePlain target:self action:@selector(ibActionHandler)];
}

- (void)ibActionHandler {
    [self performSegueWithIdentifier:@"ib" sender:nil];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    DataSourceModel *model = _datasource[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIViewController *vc = [[UIViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

    vc.view.backgroundColor = [UIColor whiteColor];

    SZGesturePasswordView *gpView = [[SZGesturePasswordView alloc] init];
    gpView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [vc.view addSubview:gpView];
    gpView.normalImage = [UIImage imageNamed:@"默认"];
    gpView.selectedImage = [UIImage imageNamed:@"选中"];
    gpView.errorImage = [UIImage imageNamed:@"错误"];
    DataSourceModel *model = _datasource[indexPath.row];
    model.config(gpView);
    [gpView sizeToFit];
    gpView.center = vc.view.center;

    vc.title = model.title;

    self.password = nil;
    __weak typeof(self) weakSelf = self;
    gpView.isErrorBlock = ^(SZGesturePasswordView *gpView, NSArray *indexs){
        NSString *slidePassword = [indexs componentsJoinedByString:@"|"];
        NSLog(@"%d, %s, %@", __LINE__, __PRETTY_FUNCTION__, slidePassword);
        if (!weakSelf.password) {
            weakSelf.password = slidePassword;
        } else {
            if (![weakSelf.password isEqualToString:slidePassword]) {
                return YES;
            }
        }
        return NO;
    };
}

@end
