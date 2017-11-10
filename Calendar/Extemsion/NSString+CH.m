//
//  NSString+CH.m
//  Calendar
//
//  Created by huangcanhui on 2017/11/6.
//  Copyright © 2017年 HuangCanHui. All rights reserved.
//

#import "NSString+CH.h"

@implementation NSString (CH)

- (BOOL)isBlank
{
    if (!self||self.length==0) {
        return YES ;
    }
    
    if ([self isEqualToString:@"(null)"]) {
        return YES ;
    }
    
    BOOL flag = YES ;
    if (self.length >= 1) {
        for (int i = 0 ;i<self.length ;i++) {
            unichar c = [self characterAtIndex:i];
            if (!(c == ' ')) {
                flag = NO ;
                break;
            }
        }
    }
    return flag ;
}

+ (BOOL)isBlank:(NSString *)str
{
    if (!str) {
        return YES ;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES ;
    }
    return [str isBlank];
    
}

- (BOOL)validPhone
{
    if ([self isBlank]) {
        return NO ;
    }
    if (!(self.length==11)) {
        return NO ;
    }
    //正则匹配
    NSString *reg = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    return [predicate evaluateWithObject:self] ;
}

- (BOOL)validMail
{
    if ([self isBlank]) {
        return NO ;
    }
    NSString *reg = @"^\\w+@\\w+\\.((com(\\.cn)?)|(cn)|(net)|(org))$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    return [predicate evaluateWithObject:self] ;
}

- (BOOL)vaildCardNo
{
    if ([self isBlank]) {
        return NO ;
    }
    NSString *reg = @"^\\d{17}[a-zA-Z0-9]$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    return [predicate evaluateWithObject:self] ;
}

- (BOOL)vailCharacterAndNum
{
    if ([self isBlank]) {
        return NO;
    }
    NSString *reg = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",reg];
    return [predicate evaluateWithObject:self];
    
}

- (BOOL)isNumberWithLength:(int) count
{
    if (count < 1) {
        return NO ;
    }
    if (![self isKindOfClass:[NSString class]]) {
        return NO ;
    }
    NSString *regX = [NSString stringWithFormat:@"^\\d{%d}$",count];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regX];
    return [predicate evaluateWithObject:self];
}

//- (CGSize)sizeOfFont:(UIFont *)font maxWidth:(CGFloat)max_width maxHeight:(CGFloat)max_height
//{
//    if (IOS_7_OR_LATER) {
//        //ios_7之后的
//        NSDictionary *dic = @{
//                              NSFontAttributeName:font,
//                              NSForegroundColorAttributeName:[UIColor blackColor]
//                              };
//        return [self boundingRectWithSize:CGSizeMake(max_width, max_height) options:1 attributes:dic context:nil].size;
//    }else{
//        //ios_7之前的
//        return [self sizeWithFont:font constrainedToSize:CGSizeMake(max_width, max_height) lineBreakMode:NSLineBreakByTruncatingTail];
//    }
//}

+ (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length > 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)verifyString:(NSString *)str isNumberWithLength:(int)count
{
    if ([self isBlank:str]) {
        return NO ;
    }
    return [str isNumberWithLength:count];
}
@end
