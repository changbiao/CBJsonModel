//
//  ViewController.m
//  SampleApp
//
//  Created by 0xcb on 5/8/2017.
//  Copyright © 2017 changbiao. All rights reserved.
//

#import "ViewController.h"
#import "CBJsonModel.h"
#import "CBTableViewCell.h"



@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) CBDelegateDataSource *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [CBDelegateDataSource new];
    self.dataSource.delegate = self;
    //test before
//    self.dataSource.cb_addModel(^CBDriverModel(CBJsonModel *model) {
//        model.cb_cellClass([CBTableViewCell class]);
//        model.cb_onUpdate = ^(CBTableViewCell *cell, CBDriverModel model) {
//            cell.centerLabel.text = ({
//                NSMutableString *ms = [NSMutableString string];
//                for (int i=0; i<8; i++) {
//                    [ms appendString:@"0123456789\n"];
//                }
//                ms;
//            });
//        };
//        model.cb_onSelected = ^(CBTableViewCell *cell, CBDriverModel model) {
//            NSLog(@"cell selected! %@", cell);
//        };
//        return model;
//    });
    
    [self.dataSource cb_setupWithTable:self.tableView];
    
    
    
    //test after
    self.dataSource.cb_addModel(^CBDriverModel(CBJsonModel *model) {
        model.cb_cellClass([CBTableViewCell class]);
        model.cb_onSelected = ^(CBTableViewCell *cell, CBDriverModel model) {
            NSLog(@"cell selected! %@", cell);
        };
        return model;
    });
    {
        CBJsonModel *jm = [CBJsonModel modelFromDict:@{}];
        jm.cb_cellClass([CBTableViewCell class]);
        jm.cb_onSelected = ^(CBTableViewCell *cell, CBDriverModel model) {
            NSLog(@"cell selected! %@", cell);
        };
        [self.dataSource.cb_dataArray addObject:jm];
    }
    {
        CBJsonModel *jm = [CBJsonModel modelFromDict:@{}];
        jm.cb_cellClass([CBTableViewCell class]);
        jm.cb_onSelected = ^(CBTableViewCell *cell, CBDriverModel model) {
            NSLog(@"cell selected! %@", cell);
        };
        [self.dataSource.cb_dataArray insertObject:jm atIndex:1];
    }
    {
        CBJsonModel *jm = [CBJsonModel modelFromDict:@{}];
        jm.cb_cellClass([CBTableViewCell class]);
        jm.cb_onSelected = ^(CBTableViewCell *cell, CBDriverModel model) {
            NSLog(@"cell selected! %@", cell);
        };
        [self.dataSource.cb_dataArray replaceObjectAtIndex:1 withObject:jm];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    NSLog(@"%@ %s", self, __func__);
}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    NSLog(@"%@ %s", self, __func__);
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%@ %s", self, __func__);
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
