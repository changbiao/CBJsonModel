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
CBJsonProtocol(NSNumber);
CBJsonProtocol(NSString);
CBJsonProtocol(NSMutableArray);
CBJsonProtocol(NSMutableDictionary);
CBJsonProtocol(NSMutableString);

//type 
typedef Class (^CBClassPropertyGetterSetter)(Class cls);
//need implementation protocol <CBCellProtocol>
typedef id CBDrivableCell;
//need implementation protocol <CBJsonModel>
typedef id CBDriverModel;
//model drive cell
typedef void (^CBItemAdapter)(CBDrivableCell cell, CBDriverModel model);
typedef CGFloat (^CBItemHeightCalculator)(CBJsonModel *model, UITableView *table);
typedef BOOL (^CBItemCanEdit)(CBDrivableCell cell, CBDriverModel model);
typedef UITableViewCellEditingStyle (^CBItemEditStyle)(CBDrivableCell cell, CBDriverModel model);
typedef void (^CBItemEditor)(CBDrivableCell cell, CBDriverModel model, UITableViewCellEditingStyle editStyle);
typedef NSString *(^CBItemDelComfirm)(CBDrivableCell cell, CBDriverModel model);
//model ability, Just for impl
typedef void (^CBItemListener)(UITableViewCell *cell);
typedef BOOL (^CBItemCanEditListener)(UITableViewCell *cell);
typedef UITableViewCellEditingStyle (^CBItemEditStyleListener)(UITableViewCell *cell);
typedef void (^CBItemEditorListener)(UITableViewCell *cell, UITableViewCellEditingStyle editStyle);
typedef NSString *(^CBItemDelComfirmListener)(UITableViewCell *cell);
//data source geter/setter
typedef CBDriverModel (^CBAddItemWrapper) (CBDriverModel model);
typedef CBDriverModel (^CBGetItemWrapper)(NSUInteger index);
typedef NSMutableArray *(^CBAddItemBlock) (CBAddItemWrapper wrapper);

@protocol CBJsonModelListProtocol <CBJsonModel>
@property (nonatomic, copy) NSNumber <Optional>*total;
@property (nonatomic, copy) NSNumber <Optional>*page;
@property (nonatomic, retain) NSMutableArray <CBJsonModel, Optional>*list;
@end

@protocol CBCellProtocol <NSObject>
@property (class, nonatomic, assign, readonly) CGFloat cbHeight;
+ (CGFloat)cbHeightWithModel:(CBJsonModel *)model;
- (CGSize)intrinsicContentSize;
@end

@interface CBJsonModel : JSONModel
@property (nonatomic, copy) NSNumber <Optional>*ret;
@property (nonatomic, copy) NSString <Optional>*msg;
@property (nonatomic, retain) NSObject <CBJsonModelListProtocol, NSMutableArray, CBJsonModel, NSMutableDictionary, NSMutableString, Optional>*data;

//additions
//Call property CBClassProperty cb_cellClass to set cell class,
//because JSONModel can't define a `Class` type property.
//@property (nonatomic, assign) Class cb_cellClass;
@property (nonatomic, retain, readonly) NSMutableDictionary *cb_params;
@property (nonatomic, copy) CBItemAdapter cb_onUpdate;
@property (nonatomic, copy) CBItemAdapter cb_onSelected;
@property (nonatomic, copy) CBItemHeightCalculator cb_calcHeight;
@property (nonatomic, copy) CBItemCanEdit cb_canEdit;
@property (nonatomic, copy) CBItemEditStyle cb_editStyle;
@property (nonatomic, copy) CBItemEditor cb_onEditor;
@property (nonatomic, copy) CBItemDelComfirm cb_onDelConfirm;

+ (instancetype)modelFromJson:(NSString *)jsonString;
+ (instancetype)modelFromDict:(NSDictionary *)jsonDict;
@end


@interface CBJsonModel (__0xcb_wrapper__)
@property (nonatomic, copy, readonly) CBClassPropertyGetterSetter cb_cellClass;
@property (nonatomic, copy, readonly) CBItemListener cb_updateListener;
@property (nonatomic, copy, readonly) CBItemListener cb_eventListener;
@property (nonatomic, copy, readonly) CBItemCanEditListener cb_canEditListener;
@property (nonatomic, copy, readonly) CBItemEditStyleListener cb_editStyleListener;
@property (nonatomic, copy, readonly) CBItemEditorListener cb_editorListener;
@property (nonatomic, copy, readonly) CBItemDelComfirmListener cb_delConfirmListener;
+ (BOOL)cb_isDrivableCell:(UITableViewCell *)cell;
- (BOOL)cb_isSelfDriveCell:(UITableViewCell *)cell;
@end

//不维护这一部分了，已经用Paw加自己写的插件，根据接口返回的json生成对应的模型类到项目工程目录下
@interface CBJsonModel (__0xcb_converter__)
+ (NSString *)convertToModel:(id)jsonObject name:(NSString *)name;
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
- (void)cc_registerCellClass:(Class)cellClass;
- (__kindof UITableViewCell *)cc_dequeueReusableCellWithCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;
@end


@interface NSMutableArray (__0xcb__)
@property (nonatomic, copy, readonly) CBAddItemBlock cb_addModel;
@property (nonatomic, copy, readonly) CBGetItemWrapper cb_atIndex;
@end



@interface CBDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *cb_tableView;
@property (nonatomic, copy, readonly) CBGetItemWrapper cb_atIndex;
@property (nonatomic, copy, readonly) CBAddItemBlock cb_addModel;
//forward tableView's delegate dataSource.
@property (nonatomic, weak) NSObject <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>*delegate;
- (void)cb_removeAll;
//call this setup tableView's style and delegate dataSource.
- (void)cb_setupWithTable:(UITableView *)tableView;
//for subclass override.
- (void)cb_registerCellNibWithClasses;
- (void)cb_setupWithCell:(UITableViewCell *)cell;
@end


@interface CBDelegateDataSource (__0xcb__)
@property (nonatomic, retain, readonly) NSMutableArray *cb_dataArray;
- (NSMutableDictionary *)cb_getFormParams;
@end
