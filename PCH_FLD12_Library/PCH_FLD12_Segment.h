//
//  PCH_FLD12_Segment.h
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-23.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCH_FLD12_Segment : NSObject

@property int segmentNumber;
@property double zMin;
@property double zMax;
@property double turns;
@property double activeTurns;
@property int strandsPerTurn;
@property int strandsPerLayer;
@property double strandR;
@property double strandA;

- (id _Nonnull)initWithNumber:(int)segmentNumber zMin:(double)zMin zMax:(double)zMax turns:(double)turns activeTurns:(double)activeTurns strandsPerTurn:(int)strandsPerTurn strandsPerLayer:(int)strandsPerLayer strandR:(double)strandR strandA:(double)strandA;

+ (id _Nonnull)segmentWithNumber:(int)segmentNumber zMin:(double)zMin zMax:(double)zMax turns:(double)turns activeTurns:(double)activeTurns strandsPerTurn:(int)strandsPerTurn strandsPerLayer:(int)strandsPerLayer strandR:(double)strandR strandA:(double)strandA;

@end
