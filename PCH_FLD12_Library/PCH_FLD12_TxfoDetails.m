//
//  PCH_FLD12_TxfoDetails.m
//  PCH_FLD12_Library
//
//  Created by Peter Huber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_TxfoDetails.h"
#import "PCH_Logging.h"

@interface PCH_FLD12_TxfoDetails ()

+ (NSArray *)nonNullComponentsOfString:(NSString *)srcString;

@end

@implementation PCH_FLD12_TxfoDetails

- (int)numTerminals
{
    return (int)self.terminals.count;
}

- (int)numLayers
{
    return (int)self.layers.count;
}

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
        // self.numTerminals = numTerminals;
        // self.numLayers = numLayers;
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

- (BOOL)isEqualToTransformer:(PCH_FLD12_TxfoDetails *)txfo
{
    if (self.terminals == NULL || self.layers == NULL || txfo.terminals == NULL || txfo.layers == NULL)
    {
        return false;
    }
    
    if ((self.terminals.count != txfo.terminals.count) || (self.layers.count != txfo.layers.count))
    {
        return false;
    }
    
    if (self.dispElon != txfo.dispElon)
    {
        return false;
    }
    else if (self.dispElon != 0)
    {
        if (self.deAmount != txfo.deAmount)
        {
            return false;
        }
    }
    
    return [self.identification isEqualToString:txfo.identification] &&
            self.inputUnits == txfo.inputUnits &&
            self.numPhases == txfo.numPhases &&
            self.frequency == txfo.frequency &&
            self.numberOfWoundLimbs == txfo.numberOfWoundLimbs &&
            self.lowerZ == txfo.lowerZ &&
            self.upperZ == txfo.upperZ &&
            self.coreDiameter == txfo.coreDiameter &&
            self.distanceToTank == txfo.distanceToTank &&
            self.alcuShield == txfo.alcuShield &&
            self.sysSCgva == txfo.sysSCgva &&
            self.puImpedance == txfo.puImpedance &&
            self.peakFactor == txfo.peakFactor &&
            // self.dispElon == txfo.dispElon &&
            // self.deAmount == txfo.deAmount &&
            self.tankFactor == txfo.tankFactor &&
            self.legFactor == txfo.legFactor &&
            self.yokeFactor == txfo.yokeFactor &&
            self.scale == txfo.scale &&
            self.numFluxLines == txfo.numFluxLines;
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

- (id)initWithURL:(NSURL *)url
{
    // This function will return NULL if the file is not a valid FLD12 input file
    NSError *wError;
    NSString *file;
    
    if (!(file = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&wError]))
    {
        DLog(@"ERROR - %@", wError.description);
        return NULL;
    }
    
    // strip out any '\r's in the string to avoid blank strings
    NSArray *fileLines = [[file stringByReplacingOccurrencesOfString:@"\r" withString:@""] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    int lineIndex = 0;
    
    if (fileLines.count < 14)
    {
        return NULL;
    }
    
    // Line 1 is ID
    NSString *identification = fileLines[lineIndex];
    lineIndex += 1;
    
    NSArray *lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
    lineIndex += 1;
    
    // Line 2
    if (lineComponents.count < 8)
    {
        return NULL;
    }
    int inputUnits = [(NSString *)lineComponents[0] intValue];
    int numPhases = [(NSString *)lineComponents[1] intValue];
    double frequency = [(NSString *)lineComponents[2] doubleValue];
    int numWoundLimbs = [(NSString *)lineComponents[3] intValue];
    // double fractionOfWindHt = [(NSString *)lineComponents[4] doubleValue]; // this value isn't used
    double zLowerBoundary = [(NSString *)lineComponents[5] doubleValue];
    double zUpperBoundary = [(NSString *)lineComponents[6] doubleValue];
    double coreDiameter = [(NSString *)lineComponents[7] doubleValue];
    
    lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
    lineIndex += 1;
    
    // Line 3
    if (lineComponents.count < 7)
    {
        return NULL;
    }
    double distanceToTank = [(NSString *)lineComponents[0] doubleValue];
    int alcuShield = [(NSString *)lineComponents[1] intValue];
    double sysScGVA = [(NSString *)lineComponents[2] doubleValue];
    double optionalPUImp = [(NSString *)lineComponents[3] doubleValue];
    double peakFactpr = [(NSString *)lineComponents[4] doubleValue];
    int numTerminals = [(NSString *)lineComponents[5] intValue];
    int numLayers = [(NSString *)lineComponents[6] doubleValue];
    
    lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
    lineIndex += 1;
    
    // Line 4
    if (lineComponents.count < 7)
    {
        return NULL;
    }
    int dispElon = [(NSString *)lineComponents[0] intValue];
    double deAmount = [(NSString *)lineComponents[1] doubleValue];
    double tankFactor = [(NSString *)lineComponents[2] doubleValue];
    double legFactor = [(NSString *)lineComponents[3] doubleValue];
    double yokeFactor = [(NSString *)lineComponents[4] doubleValue];
    double scale = [(NSString *)lineComponents[5] doubleValue];
    int numFluxLines = [(NSString *)lineComponents[6] intValue];
    
    NSMutableArray *terminals = [NSMutableArray array];
    
    lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
    lineIndex += 1;
    
    for (int i=0; i<numTerminals; i++)
    {
        if (lineComponents.count < 4)
        {
            return NULL;
        }
        int terminalNum = [(NSString *)lineComponents[0] intValue];
        int connection = [(NSString *)lineComponents[1] intValue];
        double mva = [(NSString *)lineComponents[2] doubleValue];
        double kv = [(NSString *)lineComponents[3] doubleValue];
        
        [terminals addObject:[PCH_FLD12_Terminal terminalWithNumber:terminalNum connection:connection mva:mva kv:kv]];
        
        lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
        lineIndex += 1;
    }
    
    NSMutableArray *layers = [NSMutableArray array];
    int maxSegment = 0;
    
    for (int i=0; i<numLayers; i++)
    {
        if (lineComponents.count < 4)
        {
            return NULL;
        }
        int layerNumber = [(NSString *)lineComponents[0] intValue];
        int lastSegment = [(NSString *)lineComponents[1] intValue];
        maxSegment = (lastSegment > maxSegment ? lastSegment : maxSegment);
        double innerRadius = [(NSString *)lineComponents[2] doubleValue];
        double radialBuild = [(NSString *)lineComponents[3] doubleValue];
        
        lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
        lineIndex += 1;
        
        if (lineComponents.count < 6)
        {
            return NULL;
        }
        int terminalNum = [(NSString *)lineComponents[0] intValue];
        int numParGroups = [(NSString *)lineComponents[1] intValue];
        int currentDirection = [(NSString *)lineComponents[2] intValue];
        int cuOrAl = [(NSString *)lineComponents[3] intValue];
        int numSpBlks = [(NSString *)lineComponents[4] intValue];
        double spacerBlockWidth = [(NSString *)lineComponents[5] doubleValue];
        
        [layers addObject:[PCH_FLD12_Layer layerWithNumber:layerNumber lastSegment:lastSegment innerRadius:innerRadius radialBuild:radialBuild terminal:terminalNum numParGroups:numParGroups currentDirection:currentDirection cuOrAl:cuOrAl numSpacerBlocks:numSpBlks spBlkWidth:spacerBlockWidth]];
        
        lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
        lineIndex += 1;
    }
    
    NSMutableArray *segments = [NSMutableArray array];
    
    for (int i=0; i<maxSegment; i++)
    {
        if (lineComponents.count < 5)
        {
            return NULL;
        }
        int segmentNumber = [(NSString *)lineComponents[0] intValue];
        double zMin = [(NSString *)lineComponents[1] doubleValue];
        double zMax = [(NSString *)lineComponents[2] doubleValue];
        double turns = [(NSString *)lineComponents[3] doubleValue];
        double activeTurns = [(NSString *)lineComponents[4] doubleValue];
        
        lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
        lineIndex += 1;
        
        if (lineComponents.count < 4)
        {
            return NULL;
        }
        int strandsPerTurn = [(NSString *)lineComponents[0] intValue];
        int strandsPerLayer = [(NSString *)lineComponents[1] intValue];
        double strandR = [(NSString *)lineComponents[2] doubleValue];
        double strandA = [(NSString *)lineComponents[3] doubleValue];
        
        [segments addObject:[PCH_FLD12_Segment segmentWithNumber:segmentNumber zMin:zMin zMax:zMax turns:turns activeTurns:activeTurns strandsPerTurn:strandsPerTurn strandsPerLayer:strandsPerLayer strandR:strandR strandA:strandA]];
        
        lineComponents = [PCH_FLD12_TxfoDetails nonNullComponentsOfString:fileLines[lineIndex]];
        lineIndex += 1;
    }
    
    NSRange segmentRange = NSMakeRange(0, 0);
    for (PCH_FLD12_Layer *nextLayer in layers)
    {
        segmentRange.length = nextLayer.lastSegment - segmentRange.location;
        nextLayer.segments = [segments subarrayWithRange:segmentRange];
        segmentRange.location = nextLayer.lastSegment;
    }
    
    return [self initWithId:identification inputUnits:inputUnits numPhases:numPhases frequency:frequency numberOfWoundLimbs:numWoundLimbs lowerZ:zLowerBoundary upperZ:zUpperBoundary coreDiameter:coreDiameter distanceToTank:distanceToTank alcuShield:alcuShield sysSCgva:sysScGVA puImpedance:optionalPUImp peakFactor:peakFactpr numTerminals:numTerminals numLayers:numLayers dispElon:dispElon deAmount:deAmount tankFactor:tankFactor legFactor:legFactor yokeFactor:yokeFactor scale:scale numFluxLines:numFluxLines terminals:terminals layers:layers];
}

+ (id _Nullable)txfoDetailsWithURL:(NSURL *_Nonnull)url
{
    return [[PCH_FLD12_TxfoDetails alloc] initWithURL:url];
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
