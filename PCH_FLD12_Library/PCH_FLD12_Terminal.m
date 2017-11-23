//
//  PCH_FLD12_Terminal.m
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_Terminal.h"

@implementation PCH_FLD12_Terminal

- (id)initWithNumber:(int)number connection:(int)connection mva:(double)mva kv:(double)kv
{
    if (self == [super init])
    {
        self.number = number;
        self.connection = connection;
        self.mva = mva;
        self.kv = kv;
    }
    
    return self;
}

+ (id)terminalWithNumber:(int)number connection:(int)connection mva:(double)mva kv:(double)kv
{
    return [[PCH_FLD12_Terminal alloc] initWithNumber:number connection:connection mva:mva kv:kv];
}

@end
