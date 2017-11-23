//
//  PCH_FLD12_TxfoDetails.h
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCH_FLD12_Library.h"

@interface PCH_FLD12_TxfoDetails : NSObject

@property NSString *identification;
@property int inputUnits;
@property int numPhases;
@property double frequency;
@property int numberOfWoundLimbs;
@property double lowerZ;
@property double upperZ;
@property double coreDiameter;
@property double distanceToTank;
@property int alcuShield;
@property double sysSCgva;
@property double puImpedance;
@property double peakFactor;
@property int numTerminals;
@property int numLayers;
@property int dispElon;
@property double deAmount;
@property double tankFactor;
@property double legFactor;
@property double yokeFactor;
@property double scale;
@property int numFluxLines;

- (id)initWithId:(NSString *)identification inputUnits:(int)inputUnits numPhases:(int)numPhases frequency:(double)frequency numberOfWoundLimbs:(int)numberOfWoundLimbs lowerZ:(double)lowerZ upperZ:(double)upperZ coreDiameter:(double)coreDiameter distanceToTank:(double)distanceToTank alcuShield:(int)alcuShield sysSCgva:(double)sysSCgva puImpedance:(double)puImpedance peakFactor:(double)peakFactor numTerminals:(int)numTerminals numLayers:(int)numLayers dispElon:(int)dispElon deAmount:(double)deAmount tankFactor:(double)tankFactor legFactor:(double)legFactor yokeFactor:(double)yokeFactor scale:(double)scale numFluxLines:(int)numFluxLines;

+ (id)txfoDetailsWithId:(NSString *)identification inputUnits:(int)inputUnits numPhases:(int)numPhases frequency:(double)frequency numberOfWoundLimbs:(int)numberOfWoundLimbs lowerZ:(double)lowerZ upperZ:(double)upperZ coreDiameter:(double)coreDiameter distanceToTank:(double)distanceToTank sysSCgva:(double)sysSCgva puImpedance:(double)puImpedance peakFactor:(double)peakFactor numTerminals:(int)numTerminals numLayers:(int)numLayers dispElon:(int)dispElon deAmount:(double)deAmount;

+ (id)txfoDetailsWithId:(NSString *)identification inputUnits:(int)inputUnits numPhases:(int)numPhases frequency:(double)frequency numberOfWoundLimbs:(int)numberOfWoundLimbs lowerZ:(double)lowerZ upperZ:(double)upperZ coreDiameter:(double)coreDiameter distanceToTank:(double)distanceToTank numTerminals:(int)numTerminals numLayers:(int)numLayers;

@end
