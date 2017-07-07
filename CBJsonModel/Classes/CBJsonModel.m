//
//  CBJsonModel.m
//  CBJsonModel
//
//  Created by 0xcb on 2017/5/8.
//  Copyright © 2017年 changbiao. All rights reserved.
//

#import "CBJsonModel.h"
#import <objc/runtime.h>


#define CBJsomModelWeakSelf __weak typeof(self) ws = self;

const static void *CBJsonModelCellClassKey = &CBJsonModelCellClassKey;
NSString *CBImageCDNURL = @"0xcb";
UIColor *CBTableViewBgColor = nil;


@interface CBJsonModel ()
{
    NSMutableDictionary *_cb_params;
}
@end

@implementation CBJsonModel

- (instancetype)init
{
    if (self = [super init]) {
        self.cb_cellClass([UITableViewCell class]);
    }
    return self;
}

+ (instancetype)modelFromJson:(NSString *)jsonString
{
    NSError *error = nil;
    CBJsonModel *mod = [[[self class] alloc] initWithString:jsonString usingEncoding:NSUTF8StringEncoding error:&error];
    if (error) {
        CBLog(@"#注意! json对象转换错误 %@", error);
    }
    return mod;
}

+ (instancetype)modelFromDict:(NSDictionary *)jsonDict
{
    NSError *error = nil;
    CBJsonModel *mod = [[[self class] alloc] initWithDictionary:jsonDict error:&error];
    if (error) {
        CBLog(@"#注意! json对象转换错误 %@", error);
    }
    return mod;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    CBLog(@"注意设置未定义的kv =====  {%@:%@}", key, value);
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName
{
    if ([@[@"cb_cellClass",
           @"cb_onUpdate", @"cb_onSelected", @"cb_canEdit", @"cb_editStyle", @"cb_onEditor", @"cb_onDelConfirm",
           @"cb_updateListener", @"cb_eventListener", @"cb_canEditListener", @"cb_editStyleListener", @"cb_editorListener", @"cb_delConfirmListener"
           ]
         containsObject:propertyName]) {
        return YES;
    }
    return [super propertyIsIgnored:propertyName];
}

- (NSMutableDictionary *)cb_params
{
    if (!_cb_params) {
        _cb_params = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _cb_params;
}

@end



@implementation CBJsonModel (__0xcb_wrapper__)

+ (BOOL)cb_isDrivableCell:(UITableViewCell *)cell
{
    if (cell == nil) {
        return NO;
    }
    if (![cell isKindOfClass:[UITableViewCell class]]) {
        JMLog(@" %@ is not a UITableViewCell type !", cell);
        return NO;
    }
    if (![cell conformsToProtocol:@protocol(CBCellProtocol)]) {
        JMLog(@" %@ is not conforms to CBCellProtocol !", cell);
        return NO;
    }
    return YES;
}

- (BOOL)cb_isSelfDriveCell:(UITableViewCell *)cell
{
    if (![CBJsonModel cb_isDrivableCell:cell]) {
        return NO;
    }
    if (![cell isKindOfClass:self.cb_cellClass(nil)]) {
        JMLog(@" %@ can't drive by model whitch can drive %@ !", cell, NSStringFromClass(self.cb_cellClass(nil)));
        return NO;
    }
    return YES;
}

- (CBClassProperty)cb_cellClass
{
    CBJsomModelWeakSelf;
    return ^Class(Class cls) {
        if (cls != nil) {
            ws.cb_onUpdate = nil;
            ws.cb_onSelected = nil;
            ws.cb_canEdit = nil;
            ws.cb_editStyle = nil;
            ws.cb_onEditor = nil;
            ws.cb_onDelConfirm = nil;
            objc_setAssociatedObject(ws, CBJsonModelCellClassKey, cls, OBJC_ASSOCIATION_ASSIGN);
        }
        return objc_getAssociatedObject(ws, CBJsonModelCellClassKey);
    };
}

- (CBItemListener)cb_updateListener
{
    CBJsomModelWeakSelf;
    return ^(UITableViewCell *cell) {
        if ([ws cb_isSelfDriveCell:cell]) {
            if (ws.cb_onUpdate) {
                ws.cb_onUpdate((CBDrivableCell)cell, (CBDriverModel)ws);
            }
        }
    };
}

- (CBItemListener)cb_eventListener
{
    CBJsomModelWeakSelf;
    return ^(UITableViewCell *cell) {
        if ([ws cb_isSelfDriveCell:cell]) {
            if (ws.cb_onSelected) {
                ws.cb_onSelected((CBDrivableCell)cell, (CBDriverModel)ws);
            }
        }
    };
}

- (CBItemCanEditListener)cb_canEditListener
{
    CBJsomModelWeakSelf;
    return ^(UITableViewCell *cell) {
        if ([ws cb_isSelfDriveCell:cell]) {
            if (ws.cb_canEdit) {
                return ws.cb_canEdit((CBDrivableCell)cell, (CBDriverModel)ws);
            }
        }
        return cell.isEditing;
    };
}

- (CBItemEditStyleListener)cb_editStyleListener
{
    CBJsomModelWeakSelf;
    return ^(UITableViewCell *cell) {
        if ([ws cb_isSelfDriveCell:cell]) {
            if (ws.cb_editStyle) {
                return ws.cb_editStyle((CBDrivableCell)cell, (CBDriverModel)ws);
            }
        }
        return cell.editingStyle;
    };
}

- (CBItemEditorListener)cb_editorListener
{
    CBJsomModelWeakSelf;
    return ^(UITableViewCell *cell, UITableViewCellEditingStyle editStyle) {
        if ([ws cb_isSelfDriveCell:cell]) {
            if (ws.cb_onEditor) {
                ws.cb_onEditor((CBDrivableCell)cell, (CBDriverModel)ws, editStyle);
            }
        }
    };
}

- (CBItemDelComfirmListener)cb_delConfirmListener
{
    CBJsomModelWeakSelf;
    return ^(UITableViewCell *cell) {
        if ([ws cb_isSelfDriveCell:cell]) {
            if (ws.cb_onDelConfirm) {
                return ws.cb_onDelConfirm((CBDrivableCell)cell, (CBDriverModel)ws);
            }
        }
        return @"Delete";
    };
}

@end


@implementation NSString (__0xcb__)
- (NSURL *)cbURL
{
    NSString *trimStr = self.cbTrim;
    if ([trimStr hasPrefix:@"http"]) {
        return [NSURL URLWithString:trimStr];
    }else if ([trimStr hasPrefix:@"/"] && trimStr.length){
        if ([CBImageCDNURL isEqualToString:@"0xcb"]) {
            CBLog(@"图片地址需要先指定CDN拼接地址");
        }
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", CBImageCDNURL, trimStr]];
    }else {
        if ([CBImageCDNURL isEqualToString:@"0xcb"]) {
            CBLog(@"图片地址需要先指定CDN拼接地址");
        }
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", CBImageCDNURL, trimStr]];
    }
}

- (NSNumber *)cbIntNumber
{
    return [NSNumber numberWithInteger:[self integerValue]];
}

- (NSString *)cbAppend:(NSString *)aString
{
    return [self stringByAppendingString:aString];
}

- (NSString *)cbReplace:(NSString *)aString with:(NSString *)repString
{
    repString = repString ?: @"";
    return [self stringByReplacingOccurrencesOfString:aString withString:repString];
}

+ (NSString *)cbFormatSize:(NSUInteger)size
{
    CGFloat M = 1024 * 1024;
    NSString *str = @"0MB";
    if (size > M) {
        CGFloat sizef = size / M;
        str = [NSString stringWithFormat:@"%.1fMB", sizef];
    }else if (size > 1024) {
        CGFloat sizef = size / 1024.0f;
        str = [NSString stringWithFormat:@"%.1fKB", sizef];
    }else if (size > 0) {
        str = [NSString stringWithFormat:@"%ldB", size];
    }
    return [str stringByReplacingOccurrencesOfString:@".0" withString:@""];
}

- (NSString *)cbTrim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)cbIsEmpty:(NSString *)str
{
    return !(str && [str isKindOfClass:[NSString class]] && str.length);
}

- (BOOL)cbRegex:(NSString *)regex
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)cbIsEmail
{
    return [self cbRegex:@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"];
}

- (BOOL)cbIsMobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    //return [self cbRegex:@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"];
    return [self cbRegex:@"^1(3|4|5|7|8)\\d{9}$"];
}

//车牌号验证
- (BOOL)cbIsCarNo
{
    return [self cbRegex:@"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$"];
}

//车型
- (BOOL)cbIsCarType
{
    return [self cbRegex:@"^[\u4E00-\u9FFF]+$"];
}

//用户名
- (BOOL)cbIsUserName
{
    return [self cbRegex:@"^[A-Za-z0-9]{6,20}+$"];
}

//密码
- (BOOL)cbIsPassword
{
    return [self cbRegex:@"^[a-zA-Z0-9]{6,20}+$"];
}

//昵称
- (BOOL)cbIsNickname
{
    return [self cbRegex:@"^[\u4e00-\u9fa5]{4,8}$"];
}

//身份证号
- (BOOL)cbIsIdentityCard
{
    return [self cbRegex:@"^(\\d{14}|\\d{17})(\\d|[xX])$"];
}

@end


@implementation NSNumber (__0xcb__)

- (BOOL)cbBool
{
    return [self boolValue];
}

- (int)cbInt
{
    return [self intValue];
}

- (long)cbLong
{
    return [self longValue];
}

- (float)cbFloat
{
    return [self floatValue];
}

- (double)cbDouble
{
    return [self doubleValue];
}

- (NSTimeInterval)cb_timestamp
{
    NSTimeInterval time = self.cbDouble;
    //1491545845483
    //1491545845
    if (time > 9999999999) {
        //from java
        time = time / 1000.0f;
    }
    return time;
}

- (NSDate *)cbDate
{
    NSTimeInterval time = [self cb_timestamp];
    return [NSDate dateWithTimeIntervalSince1970:time];
}

- (NSString *)cbTimestamp
{
    NSTimeInterval time = self.cbDouble;
    //1491545845483
    //1491545845
    if (time < 9999999999) {
        //from oc
        time = time * 1000.0f;
    }
    return [NSString stringWithFormat:@"%.0f", time];
}

- (NSString *)cbPriceString
{
    return [NSString stringWithFormat:@"¥%.2f", [self floatValue]];
}

- (NSString *)cbString
{
    return [NSString stringWithFormat:@"%@", self];
}

- (NSString *)cbDateStringWithFmt:(NSString *)fmtStr
{
    //hh与HH的区别:分别表示12小时制,24小时制
    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    fmt.dateFormat = fmtStr;
    NSString* dateString = [fmt stringFromDate:self.cbDate];
    return dateString;
}

- (NSString *)cbDateYYYYMMDD_DOT
{
    return [self cbDateStringWithFmt:@"yyyy.MM.dd"];
}

- (NSString *)cbDateYYYY_MM_DD
{
    return [self cbDateStringWithFmt:@"yyyy-MM-dd"];
}

- (NSString *)cbDateYYYY_MM_DD_HH_mm
{
    return [self cbDateStringWithFmt:@"yyyy-MM-dd HH:mm"];
}

- (NSString *)cbDateMM_DD_HH_mm
{
    return [self cbDateStringWithFmt:@"MM-dd HH:mm"];
}

@end


@implementation UITableView (__0xcb__)

- (void)cb_registerNibClass:(Class)nibClass
{
    NSString *nibName = NSStringFromClass(nibClass);
    [self registerNib:[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]] forCellReuseIdentifier:nibName];
}

@end


@implementation NSMutableArray (__0xcb__)

- (CBAddItemBlock)cb_addModel
{
    return ^NSMutableArray *(CBAddItemWrapper wrapper) {
        id model = [CBJsonModel new];
        id wModel = model;
        if (wrapper) {
           wModel = wrapper(model);
        }
        if (wModel) {
            [self addObject:wModel];
        }
        return self;
    };
}

- (CBGetItemWrapper)cb_atIndex
{
    CBJsomModelWeakSelf;
    return ^CBJsonModel *(NSUInteger idx) {
        if (idx >= ws.count) {
            return nil;
        }
        return [ws objectAtIndex:idx];
    };
}

@end



@interface CBDelegateDataSource ()
@property (nonatomic, retain) NSMutableArray *cb_dataArray;
@end

@implementation CBDelegateDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.cb_dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)cb_removeAll
{
    [self.cb_dataArray removeAllObjects];
}

- (CBAddItemBlock)cb_addModel
{
    return self.cb_dataArray.cb_addModel;
}

- (CBGetItemWrapper)cb_atIndex
{
    CBJsomModelWeakSelf;
    return ^CBJsonModel *(NSUInteger idx) {
        return ws.cb_dataArray.count>idx ? ws.cb_dataArray[idx] : nil;
    };
}

- (void)cb_registerCellNibWithClasses{}

- (NSMutableDictionary *)cb_getFormParams
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    for (id jm in self.cb_dataArray) {
        CBJsonModel *cbjm = jm;
        if ([cbjm isKindOfClass:[CBJsonModel class]]) {
            [params addEntriesFromDictionary:cbjm.cb_params];
        }
    }
    return params;
}

- (void)cb_setupWithTable:(UITableView *)tableView
{
    self.cb_tableView = tableView;
    //simple style
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (CBTableViewBgColor) {
        tableView.backgroundColor = CBTableViewBgColor;
    }
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = [UIView new];
    //register cells
    [self cb_registerCellNibWithClasses];
    //then set delegate, datasource
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cb_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJsonModel *model = self.cb_dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(model.cb_cellClass(nil)) forIndexPath:indexPath];
    model.cb_updateListener(cell);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJsonModel *model = self.cb_dataArray[indexPath.row];
    return [model.cb_cellClass(nil) cbHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJsonModel *model = self.cb_dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    model.cb_eventListener(cell);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJsonModel *model = self.cb_dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return model.cb_canEditListener(cell);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJsonModel *model = self.cb_dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return model.cb_editStyleListener(cell);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJsonModel *model = self.cb_dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    model.cb_editorListener(cell, editingStyle);
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBJsonModel *model = self.cb_dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    return model.cb_delConfirmListener(cell);
}

@end


