//
//  WhatColourView.m
//  WhatColourIsIt?
//
//  Created by Tom Sterritt on 15/12/2014.
//  Copyright (c) 2014 tomsterritt. All rights reserved.
//

#import "WhatColourView.h"

@implementation WhatColourView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    // Get time
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:(kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:[NSDate date]];
    
    NSString *hours = [NSString stringWithFormat:@"0%ld", (long)comp.hour];
    hours = [hours substringFromIndex:hours.length - 2];
    
    NSString *mins = [NSString stringWithFormat:@"0%ld", (long)comp.minute];
    mins = [mins substringFromIndex:mins.length - 2];
    
    NSString *secs = [NSString stringWithFormat:@"0%ld", (long)comp.second];
    secs = [secs substringFromIndex:secs.length - 2];
    
    NSString *time = [NSString stringWithFormat:@"%@ : %@ : %@", hours, mins, secs];
    NSString *hex = [NSString stringWithFormat:@"%@%@%@", hours, mins, secs];
    
    // Background
    [[self colorWithHexString:hex] set];
    [NSBezierPath fillRect:rect];
    
    // Also draw the time
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:time
                                                                     attributes:@{
                                                                                  NSForegroundColorAttributeName: [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                                                                  NSFontAttributeName: [NSFont fontWithName:@"HelveticaNeue-UltraLight" size:self.frame.size.height / 10.0]
                                                                                  }];
    
    CGRect timeRect = CGRectMake(center.x - (timeString.size.width / 2), center.y, timeString.size.width, timeString.size.height);
    [timeString drawInRect:timeRect];
    
    // And draw the hex code
    NSAttributedString *hexString = [[NSAttributedString alloc] initWithString:[@"#" stringByAppendingString:hex]
                                                                    attributes:@{
                                                                                 NSForegroundColorAttributeName: [NSColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
                                                                                 NSFontAttributeName: [NSFont fontWithName:@"HelveticaNeue-UltraLight" size:self.frame.size.height / 25.0]
                                                                                 }];
    
    CGRect hexRect = CGRectMake(center.x - (hexString.size.width / 2), (self.frame.size.height  * 0.25) - (hexString.size.height / 2), hexString.size.width, hexString.size.height);
    [hexString drawInRect:hexRect];
}

- (void)animateOneFrame
{
    [self setNeedsDisplay:YES];
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}


- (NSColor *)colorWithHexString:(NSString *)hexString {
    
    CGFloat alpha, red, blue, green;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch (colorString.length) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            alpha = 1.0f;
            red = 0.0f;
            green = 0.0f;
            blue = 0.0f;
            break;
    }
    return [NSColor colorWithRed:red green:green blue:blue alpha:alpha];
}
- (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
