//
//  PCH_FLD12_OutputData.m
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-24.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_OutputData.h"
#import "PCH_Logging.h"

@interface PCH_FLD12_OutputData ()

+ (NSArray *)nonNullComponentsOfString:(NSString *)srcString;

@end

@implementation PCH_FLD12_OutputData

- (id)initWithOutputFile:(NSString *)fileString
{
    if (self = [super init])
    {
        NSArray *fileLines = [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        // The first line MUST have the string PROGRAM FLD12 in the first line
        if (![fileLines[0] containsString:@"PROGRAM FLD12"])
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        
        int lineIndex = 2; // first couple of lines are useless
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        
        PCH_FLD12_TxfoDetails *txfo = [[PCH_FLD12_TxfoDetails alloc] init];
        
        txfo.identification = fileLines[lineIndex];
        
        // advance to the first data line
        while (![fileLines[lineIndex] containsString:@"NUMBER OF PHASES"])
        {
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        NSArray *lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        NSCharacterSet *floatingPointSet = [NSCharacterSet characterSetWithCharactersInString:@"-+.0123456789"];
        NSCharacterSet *nonNumber = [floatingPointSet invertedSet];
        
        int count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            // DLog(@"Next component: %@", nextComponent);
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.numPhases = (int)[nextComponent doubleValue];
                    count++;
                }
                else
                {
                    txfo.sysSCgva = [nextComponent doubleValue];
                    break;
                }
            }
        }
        
        lineIndex++;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.frequency = [nextComponent doubleValue];
                    count++;
                }
                else
                {
                    txfo.puImpedance = [nextComponent doubleValue];
                    break;
                }
            }
        }
        
        lineIndex++;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.numberOfWoundLimbs = (int)[nextComponent doubleValue];
                    count++;
                }
                else
                {
                    txfo.peakFactor = [nextComponent doubleValue];
                    break;
                }
            }
        }
        
        lineIndex += 2;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // we need to save this becuase of a fucking stupid Andersen issue
        double lowerZ = 0.0;
        
        count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            // That fuckin' Andersen put in a single dash in this line so we need to skip it.
            if ([nextComponent isEqualToString:@"-"])
            {
                continue;
            }
            
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.lowerZ = [nextComponent doubleValue];
                    lowerZ = txfo.lowerZ;
                    count++;
                }
                else
                {
                    txfo.tankFactor = [nextComponent doubleValue];
                    break;
                }
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            // That fuckin' Andersen put in a single dash in this line so we need to skip it.
            if ([nextComponent isEqualToString:@"-"])
            {
                continue;
            }
            
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.upperZ = [nextComponent doubleValue];
                    count++;
                }
                else
                {
                    txfo.legFactor = [nextComponent doubleValue];
                    break;
                }
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.coreDiameter = [nextComponent doubleValue];
                    count++;
                }
                else
                {
                    txfo.yokeFactor = [nextComponent doubleValue];
                    break;
                }
            }
        }
        
        // The output file doesn't indicate the units of the file itself, so we use some obvious logic. If the core diameter is greater than 50.0 we assume that the file is in metric.
        txfo.inputUnits = (txfo.coreDiameter > 50.0 ? 1 : 2);
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.distanceToTank = [nextComponent doubleValue];
                    count++;
                }
                else
                {
                    txfo.scale = [nextComponent doubleValue];
                    break;
                }
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        count = 0;
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                if (count == 0)
                {
                    txfo.alcuShield = (int)[nextComponent doubleValue];
                    count++;
                }
                else
                {
                    txfo.numFluxLines = (int)[nextComponent doubleValue];
                    break;
                }
            }
        }
        
        // advance to the terminal data line
        while (![fileLines[lineIndex] containsString:@"TERMINAL NUMBER"])
        {
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        int numTerminals = (int)lineComponents.count - 2;
        int termNums[numTerminals];
        int termConnections[numTerminals];
        double termMVAs[numTerminals];
        double termKVs[numTerminals];
        
        for (int i=0; i<numTerminals; i++)
        {
            termNums[i] = (int)[(NSString *)lineComponents[2 + i] doubleValue];
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        for (int i=0; i<numTerminals; i++)
        {
            NSString *theConnection = (NSString *)(lineComponents[1 + i]);
            if ([theConnection isEqualToString:@"Y"])
            {
                termConnections[i] = 1;
            }
            else if ([theConnection isEqualToString:@"D"])
            {
                termConnections[i] = 2;
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        for (int i=0; i<numTerminals; i++)
        {
            termMVAs[i] = [(NSString *)lineComponents[1 + i] doubleValue];
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        for (int i=0; i<numTerminals; i++)
        {
            termKVs[i] = [(NSString *)lineComponents[1 + i] doubleValue];
        }
        
        NSMutableArray *termArray = [NSMutableArray arrayWithCapacity:numTerminals];
        for (int i=0; i<numTerminals; i++)
        {
            [termArray addObject:[PCH_FLD12_Terminal terminalWithNumber:termNums[i] connection:termConnections[i]  mva:termMVAs[i] kv:termKVs[i]]];
        }
        
        txfo.terminals = [NSArray arrayWithArray:termArray];
        
        // advance to the LAYER data line
        while (![fileLines[lineIndex] containsString:@"NUMBER"])
        {
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        int maxSegNum = 0;
        NSMutableArray *layerArray = [NSMutableArray array];
        
        while (lineComponents.count == 10)
        {
            PCH_FLD12_Layer *newLayer = [[PCH_FLD12_Layer alloc] init];
            
            newLayer.number = (int)[(NSString *)lineComponents[0] doubleValue];
            newLayer.lastSegment = (int)[(NSString *)lineComponents[1] doubleValue];
            maxSegNum = MAX(maxSegNum, newLayer.lastSegment);
            newLayer.innerRadius = [(NSString *)lineComponents[2] doubleValue];
            newLayer.radialBuild = [(NSString *)lineComponents[3] doubleValue];
            newLayer.terminal = (int)[(NSString *)lineComponents[4] doubleValue];
            newLayer.numParGroups = (int)[(NSString *)lineComponents[5] doubleValue];
            newLayer.currentDirection = (int)[(NSString *)lineComponents[6] doubleValue];
            NSString *conductor = (NSString *)lineComponents[7];
            if ([conductor isEqualToString:@"CU"])
            {
                newLayer.cuOrAl = 1;
            }
            else
            {
                newLayer.cuOrAl = 2;
            }
            newLayer.numSpacerBlocks = (int)[(NSString *)lineComponents[8] doubleValue];
            newLayer.spBlkWidth = [(NSString *)lineComponents[9] doubleValue];
            
            [layerArray addObject:newLayer];
            
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        }
        
        txfo.layers = [NSArray arrayWithArray:layerArray];
        
        
        
        while (![fileLines[lineIndex] containsString:@"AXIALLY"])
        {
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        
        NSMutableArray *segmentArray = [NSMutableArray arrayWithCapacity:maxSegNum];
        int firstSegLine = lineIndex;
        for (; lineIndex < firstSegLine + maxSegNum; lineIndex++)
        {
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            
            PCH_FLD12_Segment *newSegment = [[PCH_FLD12_Segment alloc] init];
            
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            ZAssert(lineComponents.count == 10, @"Illegal number of segment components!");
            
            newSegment.segmentNumber = (int)[(NSString *)lineComponents[0] doubleValue];
            newSegment.zMin = [(NSString *)lineComponents[2] doubleValue] + lowerZ;
            newSegment.zMax = [(NSString *)lineComponents[3] doubleValue] + lowerZ;
            newSegment.turns = [(NSString *)lineComponents[4] doubleValue];
            newSegment.activeTurns = [(NSString *)lineComponents[5] doubleValue];
            newSegment.strandsPerTurn = (int)[(NSString *)lineComponents[6] doubleValue];
            newSegment.strandsPerLayer = (int)[(NSString *)lineComponents[7] doubleValue];
            newSegment.strandR = [(NSString *)lineComponents[8] doubleValue];
            newSegment.strandA = [(NSString *)lineComponents[9] doubleValue];
            
            [segmentArray addObject:newSegment];
        }
        
        // add the segments to their respective layers
        NSRange segmentRange = NSMakeRange(0, 0);
        for (PCH_FLD12_Layer *nextLayer in layerArray)
        {
            // first time in, location = 0
            segmentRange.length = nextLayer.lastSegment - segmentRange.location;
            nextLayer.segments = [segmentArray subarrayWithRange:segmentRange];
            segmentRange.location = nextLayer.lastSegment;
        }
        
        self.inputData = txfo;
        
        // advance to the first segment data line
        while (![fileLines[lineIndex] containsString:@"SEGMENT NUMBER"])
        {
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        NSMutableArray *newSegmentData = [NSMutableArray array];
       
        while ([fileLines[lineIndex] containsString:@"SEGMENT NUMBER"])
        {
            struct SegmentData nextSegment;
            
            // parse the segment data
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextSegment.number = (int)[nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 1
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextSegment.ampTurns = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 2
            int count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        nextSegment.kVA = [nextComponent doubleValue];
                        count++;
                    }
                    else
                    {
                        nextSegment.scForceTotalRadial = [nextComponent doubleValue];
                        break;
                    }
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 3
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextSegment.scForceTotalAxial = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 4
            count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        // ignore the kw/gross volume
                        count++;
                    }
                    else
                    {
                        nextSegment.scMinRadially = [nextComponent doubleValue];
                        break;
                    }
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 5
            count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        nextSegment.dcLoss = [nextComponent doubleValue];
                        count++;
                    }
                    else
                    {
                        nextSegment.scMaxRadially = [nextComponent doubleValue];
                        break;
                    }
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 6
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextSegment.scMaxAccumAxially = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 7
            count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        nextSegment.eddyLossAxialFlux = [nextComponent doubleValue];
                        count++;
                    }
                    else
                    {
                        nextSegment.scAxially = [nextComponent doubleValue];
                        break;
                    }
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 8
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextSegment.eddyLossRadialFlux = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 9
            count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        // ignore the total eddy loss
                        count++;
                    }
                    else
                    {
                        nextSegment.scMaxTensionCompression = [nextComponent doubleValue];
                        break;
                    }
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 10
            count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        nextSegment.eddyPUaverage = [nextComponent doubleValue];
                        count++;
                    }
                    else
                    {
                        nextSegment.scMinSpacerBars = [nextComponent doubleValue];
                        break;
                    }
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 11
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextSegment.eddyPUmax = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 12
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextSegment.scForceInSpacerBlocks = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            // Line 13 has nothing
            lineIndex += 2;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // Line 14
            count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        nextSegment.eddyMaxRect.origin.x = [nextComponent doubleValue];
                        count++;
                    }
                    else if (count == 1)
                    {
                        nextSegment.eddyMaxRect.size.width = [nextComponent doubleValue] - nextSegment.eddyMaxRect.origin.x;
                        count++;
                    }
                    else if (count == 2)
                    {
                        nextSegment.eddyMaxRect.origin.y = [nextComponent doubleValue];
                        count++;
                    }
                    else if (count == 3)
                    {
                        nextSegment.eddyMaxRect.size.height = [nextComponent doubleValue] - nextSegment.eddyMaxRect.origin.y;
                        count++;
                    }
                    else
                    {
                        nextSegment.scCombinedForce = [nextComponent doubleValue];
                        break;
                    }
                }
            }
            
            [newSegmentData addObject:[NSData dataWithBytes:&nextSegment length:sizeof(struct SegmentData)]];
            lineIndex += 2;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        self.segmentData = [NSArray arrayWithArray:newSegmentData];
        
        // We ignore the whole "critical stresses" part (we can find them in the segment details already parsed)
        lineIndex += 11;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line VOLTS PER TURN
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.VperN = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line FLUX DENSITY AT TANK
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.BmaxAtTank = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line FLUX DENSITY AT CORE LEG
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.BmaxAtLeg = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line BASE MVA
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.baseMVA = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line REACTANCE
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.transformerPuReactance = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line RESISTANCE
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.transformerPuResistance = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line IMPEDANCE
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.transformerPuImpedance = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line SYSTEM IMPEDANCE
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.systemPuImpedance = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line TOTAL IMPEDANCE
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.totalPuImpedance = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line FORCE IMPEDANCE
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.scForcePuImpedance = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        while (![fileLines[lineIndex] containsString:@"LAYER NUMBER"])
        {
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        
        
        NSMutableArray *newLayerArray = [NSMutableArray array];
        
        // Get the layer data (which has Terminal data interleaved in it...sigh)
        while ([fileLines[lineIndex] containsString:@"LAYER NUMBER"] || [fileLines[lineIndex] containsString:@"TERMINAL NUMBER"])
        {
            // ignore terminal data
            if ([fileLines[lineIndex] containsString:@"TERMINAL NUMBER"])
            {
                lineIndex += 6;
                if (lineIndex >= fileLines.count)
                {
                    DLog(@"This is not a valid FLD12 output file");
                    return nil;
                }
                
                continue;
            }
            
            struct LayerData nextLayer;
            
            // parse the layer data
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextLayer.number = (int)[nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // DC Loss
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextLayer.dcLoss = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex += 2;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // eddy loss due to axial flux
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextLayer.eddyLossAxialFlux = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex++;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // eddy loss due to radial flux
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextLayer.eddyLossRadialFlux = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex += 2;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // eddy loss average (pu)
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextLayer.eddyPUaverage = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            // eddy loss max (pu)
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    nextLayer.eddyPUmax = [nextComponent doubleValue];
                    break; // this is the only number in this line
                }
            }
            
            lineIndex += 3;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
            lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
            
            count = 0;
            for (NSString *nextComponent in lineComponents)
            {
                if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
                {
                    if (count == 0)
                    {
                        nextLayer.eddyMaxRect.origin.x = [nextComponent doubleValue];
                        count++;
                    }
                    else if (count == 1)
                    {
                        nextLayer.eddyMaxRect.size.width = [nextComponent doubleValue] - nextLayer.eddyMaxRect.origin.x;
                        count++;
                    }
                    else if (count == 2)
                    {
                        nextLayer.eddyMaxRect.origin.y = [nextComponent doubleValue];
                        count++;
                    }
                    else
                    {
                        nextLayer.eddyMaxRect.size.height = [nextComponent doubleValue] - nextLayer.eddyMaxRect.origin.y;
                    }
                }
            }
            
            [newLayerArray addObject:[NSData dataWithBytes:&nextLayer length:sizeof(struct LayerData)]];
            lineIndex += 8;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        self.layerData = [NSArray arrayWithArray:newLayerArray];
        
        while (![fileLines[lineIndex] containsString:@"UPPER SUPPORT"])
        {
            lineIndex += 1;
            if (lineIndex >= fileLines.count)
            {
                DLog(@"This is not a valid FLD12 output file");
                return nil;
            }
        }
        
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line UPPER SUPPORT thrust
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.totalThrustUpper = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        lineIndex += 1;
        if (lineIndex >= fileLines.count)
        {
            DLog(@"This is not a valid FLD12 output file");
            return nil;
        }
        lineComponents = [PCH_FLD12_OutputData nonNullComponentsOfString:fileLines[lineIndex]];
        
        // Line LOWER SUPPORT thrust
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.totalThrustLower = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
    }
    
    return self;
}


+ (id)dataWithOutputFile:(NSString *)fileString
{
    return [[PCH_FLD12_OutputData alloc] initWithOutputFile:fileString];
}


// Helper function
+ (NSArray *)nonNullComponentsOfString:(NSString *)srcString
{
    NSArray *lineComponents = [srcString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSIndexSet *nonNullIndices = [lineComponents indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isEqualToString:@""])
            return YES;
        else
            return NO;
    }];
    
    // DLog(@"Array Count:%lu", (unsigned long)lineComponents.count);
    
    return [lineComponents objectsAtIndexes:nonNullIndices];
}

@end
