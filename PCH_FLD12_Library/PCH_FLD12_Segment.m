//
//  PCH_FLD12_Segment.m
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-23.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_Segment.h"

@implementation PCH_FLD12_Segment

- (id)initWithNumber:(int)segmentNumber zMin:(double)zMin zMax:(double)zMax turns:(double)turns activeTurns:(double)activeTurns strandsPerTurn:(int)strandsPerTurn strandsPerLayer:(int)strandsPerLayer strandR:(double)strandR strandA:(double)strandA
{
    if (self = [super init])
    {
        self.segmentNumber = segmentNumber;
        self.zMin = zMin;
        self.zMax = zMax;
        self.turns = turns;
        self.activeTurns = activeTurns;
        self.strandsPerTurn = strandsPerTurn;
        self.strandsPerLayer = strandsPerLayer;
        self.strandR = strandR;
        self.strandA = strandA;
    }
    
    return self;
}

+ (id)segmentWithNumber:(int)segmentNumber zMin:(double)zMin zMax:(double)zMax turns:(double)turns activeTurns:(double)activeTurns strandsPerTurn:(int)strandsPerTurn strandsPerLayer:(int)strandsPerLayer strandR:(double)strandR strandA:(double)strandA
{
    return [[PCH_FLD12_Segment alloc] initWithNumber:segmentNumber zMin:zMin zMax:zMax turns:turns activeTurns:activeTurns strandsPerTurn:strandsPerTurn strandsPerLayer:strandsPerLayer strandR:strandR strandA:strandA];
}

@end
