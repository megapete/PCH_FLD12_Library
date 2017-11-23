//
//  PCH_FLD12_TxfoDetails.m
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_TxfoDetails.h"

@implementation PCH_FLD12_TxfoDetails

- (id)initWithId:(NSString *)identification inputUnits:(int)inputUnits numPhases:(int)numPhases frequency:(double)frequency numberOfWoundLimbs:(int)numberOfWoundLimbs lowerZ:(double)lowerZ upperZ:(double)upperZ coreDiameter:(double)coreDiameter distanceToTank:(double)distanceToTank alcuShield:(int)alcuShield sysSCgva:(double)sysSCgva puImpedance:(double)puImpedance peakFactor:(double)peakFactor numTerminals:(int)numTerminals numLayers:(int)numLayers dispElon:(int)dispElon deAmount:(double)deAmount tankFactor:(double)tankFactor legFactor:(double)legFactor yokeFactor:(double)yokeFactor scale:(double)scale numFluxLines:(int)numFluxLines terminals:(NSArray *)terminals layers:(NSArray*)layers
{
    if (self = [super init])
    {
        self.identification = identification;
        self.inputUnits = inputUnits;
        self.numPhases = numPhases;
        self.frequency = frequency;
        self.numberOfWoundLimbs = numberOfWoundLimbs;
        self.lowerZ = lowerZ;
        self.upperZ = upperZ;
        self.coreDiameter = coreDiameter;
        self.distanceToTank = distanceToTank;
        self.alcuShield = alcuShield;
        self.sysSCgva = sysSCgva;
        self.puImpedance = puImpedance;
        self.peakFactor = peakFactor;
        self.numTerminals = numTerminals;
        self.numLayers = numLayers;
        self.dispElon = dispElon;
        self.deAmount = deAmount;
        self.tankFactor = tankFactor;
        self.legFactor = legFactor;
        self.yokeFactor = yokeFactor;
        self.scale = scale;
        self.numFluxLines = numFluxLines;
        self.terminals = terminals;
        self.layers = layers;
    }
    
    return self;
}

+ (id)txfoDetailsWithId:(NSString *)identification inputUnits:(int)inputUnits numPhases:(int)numPhases frequency:(double)frequency numberOfWoundLimbs:(int)numberOfWoundLimbs lowerZ:(double)lowerZ upperZ:(double)upperZ coreDiameter:(double)coreDiameter distanceToTank:(double)distanceToTank sysSCgva:(double)sysSCgva puImpedance:(double)puImpedance peakFactor:(double)peakFactor numTerminals:(int)numTerminals numLayers:(int)numLayers dispElon:(int)dispElon deAmount:(double)deAmount
{
    return [[PCH_FLD12_TxfoDetails alloc] initWithId:identification inputUnits:inputUnits numPhases:numPhases frequency:frequency numberOfWoundLimbs:numberOfWoundLimbs lowerZ:lowerZ upperZ:upperZ coreDiameter:coreDiameter distanceToTank:distanceToTank alcuShield:0 sysSCgva:sysSCgva puImpedance:puImpedance peakFactor:peakFactor numTerminals:numTerminals numLayers:numLayers dispElon:dispElon deAmount:deAmount tankFactor:0.0 legFactor:0.0 yokeFactor:0.0 scale:1.0 numFluxLines:25 terminals:NULL layers:NULL];
}

+ (id)txfoDetailsWithId:(NSString *)identification inputUnits:(int)inputUnits numPhases:(int)numPhases frequency:(double)frequency numberOfWoundLimbs:(int)numberOfWoundLimbs lowerZ:(double)lowerZ upperZ:(double)upperZ coreDiameter:(double)coreDiameter distanceToTank:(double)distanceToTank numTerminals:(int)numTerminals numLayers:(int)numLayers
{
    return [[PCH_FLD12_TxfoDetails alloc] initWithId:identification inputUnits:inputUnits numPhases:numPhases frequency:frequency numberOfWoundLimbs:numberOfWoundLimbs lowerZ:lowerZ upperZ:upperZ coreDiameter:coreDiameter distanceToTank:distanceToTank alcuShield:0 sysSCgva:0.0 puImpedance:0.0 peakFactor:1.8 numTerminals:numTerminals numLayers:numLayers dispElon:0 deAmount:0.0 tankFactor:0.0 legFactor:0.0 yokeFactor:0.0 scale:1.0 numFluxLines:25 terminals:NULL layers:NULL];
}

+ (id)txfoDetailsWithId:(NSString *)identification inputUnits:(int)inputUnits numPhases:(int)numPhases frequency:(double)frequency numberOfWoundLimbs:(int)numberOfWoundLimbs lowerZ:(double)lowerZ upperZ:(double)upperZ coreDiameter:(double)coreDiameter distanceToTank:(double)distanceToTank terminals:(NSArray *)terminals layers:(NSArray *)layers
{
    return [[PCH_FLD12_TxfoDetails alloc] initWithId:identification inputUnits:inputUnits numPhases:numPhases frequency:frequency numberOfWoundLimbs:numberOfWoundLimbs lowerZ:lowerZ upperZ:upperZ coreDiameter:coreDiameter distanceToTank:distanceToTank alcuShield:0 sysSCgva:0.0 puImpedance:0.0 peakFactor:1.8 numTerminals:(int)terminals.count numLayers:(int)layers.count dispElon:0 deAmount:0.0 tankFactor:0.0 legFactor:0.0 yokeFactor:0.0 scale:1.0 numFluxLines:25 terminals:terminals layers:layers];
}

@end
