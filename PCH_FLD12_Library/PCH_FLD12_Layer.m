//
//  PCH_FLD12_Layer.m
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_Layer.h"

@implementation PCH_FLD12_Layer

- (id)initWithNumber:(int)number lastSegment:(int)lastSegment innerRadius:(double)innerRadius radialBuild:(double)radialBuild terminal:(int)terminal numParGroups:(int)numParGroups currentDirection:(int)currentDirection cuOrAl:(int)cuOrAl numSpacerBlocks:(int)numSpacerBlocks spBlkWidth:(double)spBlkWidth segments:(NSArray*)segments
{
    if (self = [super init])
    {
        self.number = number;
        self.lastSegment = lastSegment;
        self.innerRadius = innerRadius;
        self.radialBuild = radialBuild;
        self.terminal = terminal;
        self.numParGroups = numParGroups;
        self.currentDirection = currentDirection;
        self.cuOrAl = cuOrAl;
        self.numSpacerBlocks = numSpacerBlocks;
        self.spBlkWidth = spBlkWidth;
        self.segments = segments;
    }
    
    return self;
}

- (BOOL)isEqualToLayer:(PCH_FLD12_Layer *)layer
{
    if ((self.segments == NULL) || (layer.segments == NULL))
    {
        return false;
    }
    
    if (self.segments.count != layer.segments.count)
    {
        return false;
    }
    
    for (int i=0; i<self.segments.count; i++)
    {
        if (![(PCH_FLD12_Segment *)self.segments[i] isEqualToSegment:layer.segments[i]])
        {
            return false;
        }
    }
    
    return self.number == layer.number &&
           self.lastSegment == layer.lastSegment &&
           self.innerRadius == layer.innerRadius &&
           self.radialBuild == layer.radialBuild &&
           self.terminal == layer.terminal &&
           self.numParGroups == layer.numParGroups &&
           self.currentDirection == layer.currentDirection &&
           self.cuOrAl == layer.cuOrAl &&
           self.numSpacerBlocks == layer.numSpacerBlocks &&
           self.spBlkWidth == layer.spBlkWidth;
}

+ (id)layerWithNumber:(int)number lastSegment:(int)lastSegment innerRadius:(double)innerRadius radialBuild:(double)radialBuild terminal:(int)terminal numParGroups:(int)numParGroups currentDirection:(int)currentDirection cuOrAl:(int)cuOrAl numSpacerBlocks:(int)numSpacerBlocks spBlkWidth:(double)spBlkWidth
{
    return [[PCH_FLD12_Layer alloc] initWithNumber:number lastSegment:lastSegment innerRadius:innerRadius radialBuild:radialBuild terminal:terminal numParGroups:numParGroups currentDirection:currentDirection cuOrAl:cuOrAl numSpacerBlocks:numSpacerBlocks spBlkWidth:spBlkWidth segments:NULL];
}

+ (id)layerWithNumber:(int)number innerRadius:(double)innerRadius radialBuild:(double)radialBuild terminal:(int)terminal numParGroups:(int)numParGroups currentDirection:(int)currentDirection numSpacerBlocks:(int)numSpacerBlocks spBlkWidth:(double)spBlkWidth segments:(NSArray *)segments
{
    int lastSegment = -1;
    if (segments != NULL)
    {
        PCH_FLD12_Segment *lastSeg = segments.lastObject;
        lastSegment = lastSeg.segmentNumber;
    }
    
    return [[PCH_FLD12_Layer alloc] initWithNumber:number lastSegment:lastSegment innerRadius:innerRadius radialBuild:radialBuild terminal:terminal numParGroups:numParGroups currentDirection:currentDirection cuOrAl:1 numSpacerBlocks:numSpacerBlocks spBlkWidth:spBlkWidth segments:segments];
}

@end
