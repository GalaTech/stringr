//
//  NSDate+StringrAdditions.m
//  Stringr
//
//  Created by Jonathan Howard on 10/23/14.
//  Copyright (c) 2014 GalaTech LLC. All rights reserved.
//

#import "NSDate+StringrAdditions.h"

@implementation NSDate (StringrAdditions)

- (NSString *)timeAgoFromDate
{
    if (self) {
        // I add 4 mintues to the time so that it compensates for the off-time from parse
        //NSDate *newDate = [date dateByAddingTimeInterval:secondsRemovedFromDate];
        
        NSCalendarUnit units =  NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                       fromDate:self
                                                                         toDate:[NSDate date]
                                                                        options:0];
        
        if (components.year >= 1) {
            NSString *yearLabel = @"Years";
            
            if (components.year == 1) {
                yearLabel = @"Year";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.year, yearLabel];
            //NSLog(@"%@", yearsAgoText);
        } else if (components.month >= 1) {
            NSString *monthLabel = @"Months";
            
            if (components.month == 1) {
                monthLabel = @"Month";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.month, monthLabel];
            //NSLog(@"%@", monthsAgoText);
        } else if (components.weekOfYear >= 1) {
            NSString *weekLabel = @"Weeks";
            
            if (components.weekOfYear == 1) {
                weekLabel = @"Week";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.weekOfYear, weekLabel];
            //NSLog(@"%@", weeksAgoText);
        } else if (components.day >= 1) {
            NSString *dayLabel = @"Days";
            
            if (components.day == 1) {
                dayLabel = @"Day";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.day, dayLabel];
            //NSLog(@"%@", daysAgoText);
        } else if (components.hour >= 1) {
            NSString *hourLabel = @"Hours";
            
            if (components.hour == 1) {
                hourLabel = @"Hour";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.hour, hourLabel];
            //NSLog(@"%@", hoursAgoText);
        } else if (components.minute >= 1) {
            NSString *minuteLabel = @"Minutes";
            
            if (components.minute == 1) {
                minuteLabel = @"Minute";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.minute, minuteLabel];
            //NSLog(@"%@", minutesAgoText);
        } else if (components.second <= 60) {
            NSString *secondLabel = @"Seconds";
            
            if (components.second == 1) {
                secondLabel = @"Second";
            }
            
            return [NSString stringWithFormat:@"%ld %@ Ago", (long)components.second, secondLabel];
            //NSLog(@"%@", secondsAgoText);
        } else {
            return @"Uploaded in the Past!";
        }
    } else {
        return @"No Date";
    }
}

@end
