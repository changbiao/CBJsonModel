//
//  main.m
//  SampleApp
//
//  Created by 0xcb on 5/8/2017.
//  Copyright © 2017 changbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CBJsonModel.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        CBImageCDNURL = @"http://timgsa.baidu.com/";
        CBJsonModel *jm = [CBJsonModel modelFromJson:@"{\"msg\":\"/timg?image\"}"];
        NSLog(@"image url === %@", jm.msg.cbURL);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
