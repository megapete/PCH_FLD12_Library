//
//  PCH_FLD12_OutputData.m
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-24.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_OutputData.h"

@implementation PCH_FLD12_OutputData

- (id)initWithTransformer:(PCH_FLD12_TxfoDetails *)txfo usingOutputFile:(NSString *)fileString
{
    if (self = [super init])
    {
        NSArray *fileLines = [fileString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        int lineIndex = 0;
        // advance to the first segment data line
        while (![fileLines[lineIndex] containsString:@"SEGMENT NUMBER"])
        {
            lineIndex += 1;
        }
        
        NSCharacterSet *floatingPointSet = [NSCharacterSet characterSetWithCharactersInString:@"-+.0123456789"];
        NSCharacterSet *nonNumber = [floatingPointSet invertedSet];
        
        NSMutableArray *newSegmentData = [NSMutableArray array];
        NSArray *lineComponents;
        
        while ([fileLines[lineIndex] containsString:@"SEGMENT NUMBER"])
        {
            struct SegmentData nextSegment;
            
            // parse the segment data
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            // NSMutableArray *numericalComponents = [NSMutableArray array];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
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
            
            lineIndex += 2;
        }
        
        // We ignore the whole "critical stresses" part (we can find them in the segment details already parsed)
        lineIndex += 11;
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        // Line FORCE IMPEDANCE
        for (NSString *nextComponent in lineComponents)
        {
            if ([nextComponent rangeOfCharacterFromSet:nonNumber].location == NSNotFound)
            {
                self.scForcePuImpedance = [nextComponent doubleValue];
                break; // this is the only number in this line
            }
        }
        
        while (![fileLines[lineIndex] containsString:@"UPPER SUPPORT"])
        {
            lineIndex += 1;
        }
        
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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
        lineComponents = [fileLines[lineIndex] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
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

@end
