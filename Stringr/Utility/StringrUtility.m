//
//  StringrUtility.m
//  Stringr
//
//  Created by Jonathan Howard on 11/21/13.
//  Copyright (c) 2013 GalaTech LLC. All rights reserved.
//

#import "StringrUtility.h"

@implementation StringrUtility

+ (void)showMenu:(REFrostedViewController *)menuViewController
{
    [menuViewController presentMenuViewController];
}

static float const secondsRemovedFromDate = 240;

+ (NSString *)timeAgoFromDate:(NSDate *)date
{
    if (date) {
        // I add 4 mintues to the time so that it compensates for the off-time from parse
        NSDate *newDate = [date dateByAddingTimeInterval:secondsRemovedFromDate];
        
        NSCalendarUnit units =  NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSWeekOfYearCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                       fromDate:newDate
                                                                         toDate:[NSDate date]
                                                                        options:0];
        
        if (components.year >= 1) {
            NSString *yearLabel = @"Years";
            
            if (components.year == 1) {
                yearLabel = @"Year";
            }
            
            return [NSString stringWithFormat:@"%d %@ Ago", components.year, yearLabel];
            //NSLog(@"%@", yearsAgoText);
        } else if (components.month >= 1) {
            NSString *monthLabel = @"Months";
            
            if (components.month == 1) {
                monthLabel = @"Month";
            }
            
            return [NSString stringWithFormat:@"%d %@ Ago", components.month, monthLabel];
            //NSLog(@"%@", monthsAgoText);
        } else if (components.weekOfYear >= 1) {
            NSString *weekLabel = @"Weeks";
            
            if (components.weekOfYear == 1) {
                weekLabel = @"Week";
            }
            
            return [NSString stringWithFormat:@"%d %@ Ago", components.weekOfYear, weekLabel];
            //NSLog(@"%@", weeksAgoText);
        } else if (components.day >= 1) {
            NSString *dayLabel = @"Days";
            
            if (components.day == 1) {
                dayLabel = @"Day";
            }
            
            return [NSString stringWithFormat:@"%d %@ Ago", components.day, dayLabel];
            //NSLog(@"%@", daysAgoText);
        } else if (components.hour >= 1) {
            NSString *hourLabel = @"Hours";
            
            if (components.hour == 1) {
                hourLabel = @"Hour";
            }
            
            return [NSString stringWithFormat:@"%d %@ Ago", components.hour, hourLabel];
            //NSLog(@"%@", hoursAgoText);
        } else if (components.minute >= 1) {
            NSString *minuteLabel = @"Minutes";
            
            if (components.minute == 1) {
                minuteLabel = @"Minute";
            }
            
            return [NSString stringWithFormat:@"%d %@ Ago", components.minute, minuteLabel];
            //NSLog(@"%@", minutesAgoText);
        } else if (components.second <= 60) {
            NSString *secondLabel = @"Seconds";
            
            if (components.second == 1) {
                secondLabel = @"Second";
            }
            
            return [NSString stringWithFormat:@"%d %@ Ago", components.second, secondLabel];
            //NSLog(@"%@", secondsAgoText);
        } else {
            return @"Uploaded in the Past!";
        }
    } else {
        return @"No Date";
    }
}

@end
