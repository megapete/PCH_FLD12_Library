//
//  PCH_FLD12_Layer.h
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCH_FLD12_Segment.h"

@interface PCH_FLD12_Layer : NSObject

@property int number;
@property int lastSegment;
@property double innerRadius;
@property double radialBuild;
@property int terminal;
@property int numParGroups;
@property int currentDirection;
@property int cuOrAl;
@property int numSpacerBlocks;
@property double spBlkWidth;

@property NSArray *_Nullable segments;

- (id _Nonnull)initWithNumber:(int)number lastSegment:(int)lastSegment innerRadius:(double)innerRadius radialBuild:(double)radialBuild terminal:(int)terminal numParGroups:(int)numParGroups currentDirection:(int)currentDirection cuOrAl:(int)cuOrAl numSpacerBlocks:(int)numSpacerBlocks spBlkWidth:(double)spBlkWidth segments:(NSArray*_Nullable)segments;

+ (id _Nonnull)layerWithNumber:(int)number lastSegment:(int)lastSegment innerRadius:(double)innerRadius radialBuild:(double)radialBuild terminal:(int)terminal numParGroups:(int)numParGroups currentDirection:(int)currentDirection cuOrAl:(int)cuOrAl numSpacerBlocks:(int)numSpacerBlocks spBlkWidth:(double)spBlkWidth;

+ (id _Nonnull)layerWithNumber:(int)number innerRadius:(double)innerRadius radialBuild:(double)radialBuild terminal:(int)terminal numParGroups:(int)numParGroups currentDirection:(int)currentDirection numSpacerBlocks:(int)numSpacerBlocks spBlkWidth:(double)spBlkWidth segments:(NSArray*_Nullable)segments;

- (BOOL)isEqualToLayer:(PCH_FLD12_Layer *_Nonnull)layer;

@end
