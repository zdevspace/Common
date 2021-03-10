//
//  GitDateFormatter.m
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import "GitDateFormatter.h"

@implementation GitDateFormatter

#pragma mark Date Formatter Methods

+ (NSDate *)convertToDateFrom:(NSDate *)date
                   fromFormat:(NSString *)oldFormat
                     toFormat:(NSString *)newFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateNSString = [[NSString alloc]init];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setDateFormat:oldFormat];
    dateNSString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:newFormat];
    date = [dateFormatter dateFromString:dateNSString];
    
    
    return date;
}

+ (NSDate *)converToDateFromString:(NSString *)dateString
                        withFormat:(NSString *)dateFormat {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [[NSDate alloc]init];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];  //bug for DDO
    [dateFormatter setDateFormat:dateFormat];
    
    date = [dateFormatter dateFromString:dateString];
    
    return date;
}

+ (NSString *)convertToStringFromString:(NSString *)dateString
                             fromFormat:(NSString *)oldFormat
                               toFormat:(NSString *)newFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [[NSDate alloc]init];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setDateFormat:oldFormat];
    date = [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:newFormat];
    dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *)convertToStringFromDate:(NSDate *)date
                           withFormat:(NSString *)dateFormat {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateNSString = [[NSString alloc]init];
    
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setDateFormat:dateFormat];
    
    dateNSString = [dateFormatter stringFromDate:date];
    
    return dateNSString;
}

+(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    return [difference day];
}

+ (NSString *) convertServerTimeToLocalTime: (NSString *) serverDateTime localTimeFormat: (NSString *) localTimeFormat{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    
    NSDate* utcTime = [dateFormatter dateFromString:serverDateTime];
    
    if (utcTime == nil) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        utcTime = [dateFormatter dateFromString:serverDateTime];
    }
    
    if (utcTime == nil) {
        return @"";
    }else{
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:localTimeFormat];
        NSString* localTime = [dateFormatter stringFromDate:utcTime];
        
        return localTime;
    }
}


@end

