//
//  GitDateFormatter.h
//  GGITCommon iOS
//
//  Created by Kelvin Leong on 04/09/2018.
//  Copyright © 2018 Grace Generation Information Technology. All Rights Reserved. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Records the given message in the system log.
 
 ```objc
 import KLDateFormatter
 ...
 
 KLDateFormatter.converToDate(from: "20/09/2018", withFormat: "dd/MM/yyyy")
 ```
 
 - Parameter text: The message to record.
 */

@interface GitDateFormatter : NSObject

#pragma mark Date Formatter Methods

/**
 *  Convert date from 1 format to another.
 *  ```Objc
 *
 *  @param date      The NSDate Object to be converted.
 *  @param oldFormat The current format of the NSDate.
 *  @param newFormat The new format to be converted into.
 *
 *  @return NSDate object with new format.
 */
+ (NSDate *)convertToDateFrom:(NSDate *)date fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat;

/**
 *  Convert to NSDate object from NSString.
 *
 *  @param dateString NSString to be converted.
 *  @param dateFormat The format of the NSDate.
 *
 *  @return NSDate object converted from string.
 */
+ (NSDate *)converToDateFromString:(NSString *)dateString withFormat:(NSString *)dateFormat;

/**
 *  Convert a date in NSString to another date format and return as NSString.
 *
 *  @param dateString Date in NSString.
 *  @param oldFormat  Current format of the date.
 *  @param newFormat  Format to be converted.
 *
 *  @return The date with new format in NSString.
 */
+ (NSString *)convertToStringFromString:(NSString *)dateString fromFormat:(NSString *)oldFormat toFormat:(NSString *)newFormat;

/**
 *  Convert a NSDate object to NSString.
 *
 *  @param date       The NSDate object to be co nverted.
 *  @param dateFormat The date format of the NSDate.
 *
 *  @return NSString value of the date.
 */
+ (NSString *)convertToStringFromDate:(NSDate *)date withFormat:(NSString *)dateFormat;

/**
 *  Calculate the days between 2 NSDate.
 *
 *  @param fromDateTime The start date.
 *  @param toDateTime   The end date.
 *
 *  @return NSInteger value of days between the start date and end date.
 */
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate *)toDateTime;

/**
 *  This method is to convert the server datetime to device datetime based on the device timezone
 *
 *  @param serverDateTime  server datetime in yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ" format, e.g. 2015-06-09T09:09:28.918+08:00
 *  @param localTimeFormat datetime format to be converted
 *
 *  @return NSString of the converted datetime
 */
+ (NSString *) convertServerTimeToLocalTime: (NSString *) serverDateTime localTimeFormat: (NSString *) localTimeFormat;

@end
