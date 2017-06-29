//
//  CBJsonModel.h
//  CBJsonModel
//
//  Created by 0xcb on 2017/5/8.
//  Copyright © 2017年 changbiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel/JSONModel.h>


#if DEBUG
#define CBLog NSLog
#else
#define CBLog
#endif

//设置图片 cdn 地址,如果后台返回图片 url 是相对地址
extern NSString *CBImageCDNURL;
extern UIColor *CBTableViewBgColor;

#define CBJsonProtocol(__N__) @protocol __N__ <NSObject> @end
#define CBEnsureClassPtr(_OBJ_, _CLS_) ((_CLS_ *)((_OBJ_ && [_OBJ_ isKindOfClass:[_CLS_ class]]) ? _OBJ_ : nil))
#define CBEnsureNotNull(_STR_) (((_STR_)==nil || [_STR_ isEqual:[NSNull null]] || ![_STR_ isKindOfClass:[NSString class]]) ? @"" : _STR_)
#define CBEnsureNotNullNum(_STR_) (((_STR_)==nil || [_STR_ isEqual:[NSNull null]] || ![_STR_ isKindOfClass:[NSNumber class]]) ? @(0) : _STR_)

@class CBJsonModel;
@protocol CBCellProtocol;
CBJsonProtocol(CBJsonModel);
CBJsonProtocol(NSMutableArray);
CBJsonProtocol(NSMutableDictionary);
CBJsonProtocol(NSMutableString);
typedef Class (^AFCBClassProperty)(Class cls);
typedef void (^AFCBItemListener)(UITableViewCell *cell);
typedef void (^AFCBItemAdapter)(id /*<CBCellProtocol>*/ cell, id <CBJsonModel>model);
typedef id <CBJsonModel> (^AFCBAddItemWrapper) (id <CBJsonModel>model);
typedef NSMutableArray *(^AFCBAddItemBlock) (AFCBAddItemWrapper wrapper);

@protocol CBJsonModelListProtocol <CBJsonModel>
@property (nonatomic, copy) NSNumber <Optional>*total;
@property (nonatomic, copy) NSNumber <Optional>*page;
@property (nonatomic, retain) NSMutableArray <CBJsonModel, Optional>*list;
@end

@protocol CBCellProtocol <NSObject>
@property (class, nonatomic, assign, readonly) CGFloat cb_Height;
@end

@interface CBJsonModel : JSONModel
@property (nonatomic, copy) NSNumber <Optional>*ret;
@property (nonatomic, copy) NSString <Optional>*msg;
@property (nonatomic, retain) NSObject <CBJsonModelListProtocol, NSMutableArray, CBJsonModel, NSMutableDictionary, NSMutableString, Optional>*data;
@property (nonatomic, copy) AFCBItemAdapter cb_onUpdate;
@property (nonatomic, copy) AFCBItemAdapter cb_onSelected;

+ (instancetype)modelFromJson:(NSString *)jsonString;
+ (instancetype)modelFromDict:(NSDictionary *)jsonDict;
@end


@interface CBJsonModel (__0xcb_wrapper__)
@property (nonatomic, copy, readonly) AFCBClassProperty cb_cellClass;
@property (nonatomic, copy, readonly) AFCBItemListener cb_updateListener;
@property (nonatomic, copy, readonly) AFCBItemListener cb_eventListener;
@end


@interface NSString (__0xcb__)
@property (nonatomic, copy, readonly) NSURL *cbURL;
@property (nonatomic, copy, readonly) NSNumber *cbIntNumber;
@property (nonatomic, copy, readonly) NSString *cbTrim;
- (NSString *)cbAppend:(NSString *)aString;
- (NSString *)cbReplace:(NSString *)aString with:(NSString *)repString;
+ (NSString *)cbFormatSize:(NSUInteger)size;
+ (BOOL)cbIsEmpty:(NSString *)str;
- (BOOL)cbRegex:(NSString *)regex;
- (BOOL)cbIsEmail;
- (BOOL)cbIsMobile;
- (BOOL)cbIsCarNo;
- (BOOL)cbIsCarType;
- (BOOL)cbIsUserName;
- (BOOL)cbIsPassword;
- (BOOL)cbIsNickname;
- (BOOL)cbIsIdentityCard;
@end


@interface NSNumber (__0xcb__)
@property (nonatomic, assign, readonly) BOOL cbBool;
@property (nonatomic, assign, readonly) int cbInt;
@property (nonatomic, assign, readonly) long cbLong;
@property (nonatomic, assign, readonly) float cbFloat;
@property (nonatomic, assign, readonly) double cbDouble;
@property (nonatomic, copy, readonly) NSString *cbString;
@property (nonatomic, copy, readonly) NSString *cbPriceString;
@property (nonatomic, copy, readonly) NSDate *cbDate;
@property (nonatomic, copy, readonly) NSString *cbTimestamp;
- (NSString *)cbDateStringWithFmt:(NSString *)fmtStr;
//yyyy.MM.dd
- (NSString *)cbDateYYYYMMDD_DOT;
//yyyy-MM-dd
- (NSString *)cbDateYYYY_MM_DD;
- (NSString *)cbDateYYYY_MM_DD_HH_mm;
- (NSString *)cbDateMM_DD_HH_mm;
@end


@interface UITableView (__0xcb__)
- (void)cb_registerNibClass:(Class)nibClass;
@end


@interface NSMutableArray (__0xcb__)
@property (nonatomic, copy, readonly) AFCBAddItemBlock cb_addModel;
@end



@interface CBDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy, readonly) AFCBAddItemBlock cb_addModel;
@property (nonatomic, weak) UITableView *cb_tableView;
- (void)cb_removeAll;
- (void)cb_setupWithTable:(UITableView *)tableView;
@end


