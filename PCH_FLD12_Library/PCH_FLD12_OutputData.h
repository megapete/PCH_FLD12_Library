//
//  PCH_FLD12_OutputData.h
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-24.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCH_FLD12_TxfoDetails.h"

@interface PCH_FLD12_OutputData : NSObject

struct SegmentData {
    
    int number;
    double ampTurns;
    double kVA;
    double dcLoss;
    double eddyLossAxialFlux;
    double eddyLossRadialFlux;
    double eddyPUaverage;
    double eddyPUmax;
    NSRect eddyMaxRect;
    double scForceTotalRadial;
    double scForceTotalAxial;
    double scMinRadially;
    double scMaxRadially;
    double scMaxAccumAxially;
    double scAxially;
    double scMaxTensionCompression;
    double scMinSpacerBars;
    double scForceInSpacerBlocks;
    double scCombinedForce;
};

@property PCH_FLD12_TxfoDetails *inputData;
@property NSArray *segmentData;

@property double VperN;
@property double BmaxAtTank;
@property double BmaxAtLeg;
@property double baseMVA;
@property double transformerPuReactance;
@property double transformerPuResistance;
@property double transformerPuImpedance;

@property double systemPuImpedance;
@property double totalPuImpedance;
@property double scForcePuImpedance;

@property double totalThrustUpper;
@property double totalThrustLower;

- (id)initWithOutputFile:(NSString *)fileString;
+ (id)dataWithOutputFile:(NSString *)fileString;

@end
