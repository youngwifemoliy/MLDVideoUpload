//
//  MLDLog.m
//
//  Created by MoliySDev on 2019/1/18.
//  Copyright © 2019 gouuse. All rights reserved.
//  

#import <Foundation/Foundation.h>

#ifndef Release

@implementation NSSet(MLDLog)

 - (NSString *)descriptionWithLocale:(id)locale
                              indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    NSString *tab = (level > 0) ? tabString : @"\t";
    [desc appendString:@"{(\n"];
    NSArray *tempArray = [self allObjects];
    for (int i = 0; i < tempArray.count; i++) {
        id obj = tempArray[i];
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, obj] : [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        }
        else if ([obj isKindOfClass:[NSData class]]) {
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
                }
                else if ([obj isKindOfClass:[NSString class]]) {
                    (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, result] : [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            }
            else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, str] : [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    }
                    else {
                        (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        }
        else {
            (i == (tempArray.count-1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    [desc appendFormat:@"%@)}", tab];
    return desc;
}

@end

@implementation NSArray (MLDLog)

- (NSString *)descriptionWithLocale:(id)locale
                             indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    NSString *tab = (level > 0) ? tabString : @"";
    [desc appendString:@"(\n"];
    for (int i = 0; i < self.count; i++) {
        id obj = self[i];
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            (i == (self.count - 1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, obj] : [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        }
        else if ([obj isKindOfClass:[NSData class]]) {
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            if (error == nil && result != nil)
            {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, str] : [desc appendFormat:@"%@\t%@,\n", tab, str];
                    
                }
                else if ([obj isKindOfClass:[NSString class]]) {
                    (i == (self.count - 1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, result] : [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            }
            else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        (i == (self.count - 1)) ? [desc appendFormat:@"%@\t\"%@\"\n", tab, str] : [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    }
                    else {
                        (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        }
        else {
            (i == (self.count - 1)) ? [desc appendFormat:@"%@\t%@\n", tab, obj] : [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    [desc appendFormat:@"%@)", tab];
    return desc;
}

@end

@implementation NSDictionary (MLDLog)

- (NSString *)descriptionWithLocale:(id)locale
                             indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; ++i) {
        [tabString appendString:@"\t"];
    }
    NSString *tab = (level > 0) ? tabString : @"";
    [desc appendString:@"{\n"];
    NSArray *allKeys = [self allKeys];
    for (int i = 0; i < allKeys.count; i++)
    {
        id key = allKeys[i];
        id obj = [self objectForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = \"%@\"\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, obj];
        }
        else if ([obj isKindOfClass:[NSArray class]]
                 || [obj isKindOfClass:[NSDictionary class]]
                 || [obj isKindOfClass:[NSSet class]]) {
            (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]] :  [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
        }
        else if ([obj isKindOfClass:[NSData class]]) {
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            if (error == nil &&
                result != nil)
            {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, str] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, str];
                }
                else if ([obj isKindOfClass:[NSString class]]) {
                    (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = \"%@\"\n", tab, key, result] : [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, result];
                }
            }
            else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = \"%@\"\n", tab, key, str] : [desc appendFormat:@"%@\t%@ = \"%@\",\n", tab, key, str];
                    }
                    else {
                        (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                    }
                }
                @catch (NSException *exception) {
                    (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
                }
            }
        }
        else {
            (i == (allKeys.count-1)) ? [desc appendFormat:@"%@\t%@ = %@\n", tab, key, obj] : [desc appendFormat:@"%@\t%@ = %@,\n", tab, key, obj];
        }
    }
    [desc appendFormat:@"%@}", tab];
    return desc;
}

@end

#endif

