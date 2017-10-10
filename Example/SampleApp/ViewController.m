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
    
    
    
    //测试输出字典映射模型类到控制台
    NSError *jsonErr = nil;
    NSString *testJsonPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
    NSData *testJsonData = [NSData dataWithContentsOfFile:testJsonPath];
    id jsonObj = [NSJSONSerialization JSONObjectWithData:testJsonData options:    NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:&jsonErr];
    if (jsonErr) {
        NSLog(@"json parser err ====== %@", jsonErr);
    }
    NSLog(@"model class ====== \n%@", [CBJsonModel convertToModel:jsonObj name:@"AFCBGoods"]);
    
    
    //]^
    uint8_t commandBytes[] = {
        ']', '^'
    };
    NSMutableData *mutData = [NSMutableData data];
    [mutData appendBytes:commandBytes length:sizeof(commandBytes)];
    NSLog(@"数据对比 === \n>>>%@<<< \n>>>%@<<<", mutData, [@"]^" dataUsingEncoding:NSUTF8StringEncoding]);
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
