//
//  PCH_FLD12_Terminal.h
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCH_FLD12_Terminal : NSObject

@property int number;
@property int connection;
@property double mva;
@property double kv;

- (id _Nonnull)initWithNumber:(int)number connection:(int)connection mva:(double)mva kv:(double)kv;
+ (id _Nonnull)terminalWithNumber:(int)number connection:(int)connection mva:(double)mva kv:(double)kv;

- (BOOL)isEqualToTerminal:(PCH_FLD12_Terminal *_Nonnull)terminal;

@end
