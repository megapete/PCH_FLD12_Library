//
//  PCH_FLD12_Library.m
//  PCH_FLD12_Library
//
//  Created by PeterCoolAssHuber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import "PCH_FLD12_Library.h"
#import "PCH_Logging.h"
#include "f2c.h"
#import "PCH_FLD12_Layer.h"
#import "PCH_FLD12_Segment.h"

// Declarations for FLD12 functions
int INP12MAIN__(char *baseDirectory);
int FLD8MAIN__(char *baseDirectory);
int OUTENGMAIN__(char *baseDirectory);
int OUTMETMAIN__(char *baseDirectory);
int FIELDPRPMAIN__(char *baseDirectory);

@implementation PCH_FLD12_Library

+ (NSString * _Nonnull)RunFLD12withString:(NSString *_Nonnull)fileString outputType:(PCH_FLD12_OutputType)outputType fluxLineString:(NSString *_Nonnull*_Nullable)fluxLinePtr fld8String:(NSString *_Nonnull*_Nullable)fld8Ptr
{
    // NSString *userTempDir = NSTemporaryDirectory();
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    // We need to make sure that the ATPCM file exists in the temporary directory. If it doesn't, we will assume that the file exists in the user's Documents folder and copy it to the temp folder.
    
    NSArray *urlArray = [fileMgr URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    NSURL *appSupportUrl = [urlArray[0] URLByAppendingPathComponent:@"com.huberistech.fld12library" isDirectory:true];
    if (![fileMgr fileExistsAtPath:appSupportUrl.path])
    {
        NSError *wError;
        if (![fileMgr createDirectoryAtURL:appSupportUrl withIntermediateDirectories:false attributes:nil error:&wError])
        {
            NSAlert *errPanel = [NSAlert alertWithError:wError];
            [errPanel runModal];
            
            return @"ERROR - Could not create Application Support Directory";
        }
    }
    
    NSURL *atpcmUrl = [appSupportUrl URLByAppendingPathComponent:@"ATPCM.FIL" isDirectory:false];
    NSString *userTempDir = [NSString stringWithFormat:@"%@/", appSupportUrl.path];
    
    NSString *tempATPCM = atpcmUrl.path;
    DLog(@"Temp directory: %@", tempATPCM);
    
    if (![fileMgr fileExistsAtPath:tempATPCM])
    {
        NSArray *docDirUrlArray = [fileMgr URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *docDirUrl = docDirUrlArray[0];
        NSString *srcATPCM = [NSString stringWithFormat:@"%@/ATPCM.FIL", docDirUrl.path];
        
        NSError *wError;
        
        if (![fileMgr fileExistsAtPath:srcATPCM])
        {
            NSOpenPanel *openPanel = [NSOpenPanel openPanel];
            [openPanel setTitle:@"Find ATPCM.FIL"];
            [openPanel setMessage:@"Select the file ATPCM"];
            
            if ([openPanel runModal] == NSModalResponseOK)
            {
                srcATPCM = [NSString stringWithString:[[openPanel URL] path]];
            }
        }
        
        if (![fileMgr copyItemAtPath:srcATPCM toPath:tempATPCM error:&wError])
        {
            DLog(@"Error copying ATPCM.FIL. %@", wError.localizedDescription);
            
            NSAlert *errPanel = [NSAlert alertWithError:wError];
            [errPanel runModal];
            
            return @"ERROR - NO ATCPM.FIL file available";
        }
    }
    
    NSString *inp1Fil = [NSString stringWithFormat:@"%@INP1.FIL", userTempDir];
    NSError *wError;
    [fileMgr removeItemAtPath:inp1Fil error:&wError];
    
    // Remove the BAS.FIL file if it exists
    [fileMgr removeItemAtPath:[NSString stringWithFormat:@"%@BAS.FIL", userTempDir] error:&wError];
    
    if (![fileString writeToFile:inp1Fil atomically:NO encoding:NSUTF8StringEncoding error:&wError])
    {
        DLog(@"Error creating INP1.FIL. %@", wError.localizedDescription);
        
        NSAlert *errPanel = [NSAlert alertWithError:wError];
        [errPanel runModal];
        
        return @"ERROR - Could not create INP1.FIL";
    }
    
    if (INP12MAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
    {
        DLog(@"Error in Inp12. %@", wError.localizedDescription);
        
        NSAlert *errPanel = [[NSAlert alloc] init];
        [errPanel setMessageText:@"ANDERSEN ERROR"];
        [errPanel setAlertStyle:NSAlertStyleCritical];
        [errPanel setInformativeText:@"INP12 Failed"];
        [errPanel runModal];
        
        return @"ERROR - Error in INP12";
    }
    
    if (FLD8MAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
    {
        DLog(@"Error in Fld8. %@", wError.localizedDescription);
        
        NSAlert *errPanel = [[NSAlert alloc] init];
        [errPanel setMessageText:@"ANDERSEN ERROR"];
        [errPanel setAlertStyle:NSAlertStyleCritical];
        [errPanel setInformativeText:@"FLD8 Failed"];
        [errPanel runModal];
        
        return @"ERROR - Error in FLD8";
    }
    
    // save a copy of the FLD8 output file for subsequent analysis (this can be commented out if it's never used)
    NSString *outputFileName = [NSString stringWithFormat:@"%@OUTPUT", userTempDir];
    NSString *fld8OutputName = [NSString stringWithFormat:@"%@OUTPUT.fld8", userTempDir];
    [fileMgr removeItemAtPath:fld8OutputName error:&wError];
    if (![fileMgr copyItemAtPath:outputFileName toPath:fld8OutputName error:&wError])
    {
        DLog(@"Error copying OUTPUT.fld8. %@", wError.localizedDescription);
        return @"ERROR - FLD8 did not create OUTPUT file";
    }
    
    if (fld8Ptr != NULL)
    {
        *fld8Ptr = [NSString stringWithContentsOfFile:outputFileName encoding:NSUTF8StringEncoding error:NULL];
    }
    
    if (outputType == metric)
    {
        if (OUTMETMAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
        {
            DLog(@"Error in OutEng. %@", wError.localizedDescription);
            
            NSAlert *errPanel = [[NSAlert alloc] init];
            [errPanel setMessageText:@"ANDERSEN ERROR"];
            [errPanel setAlertStyle:NSAlertStyleCritical];
            [errPanel setInformativeText:@"OUTMET Failed"];
            [errPanel runModal];
            
            return @"ERROR - Error in OUTMET";
        }
    }
    else
    {
        if (OUTENGMAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
        {
            DLog(@"Error in OutEng. %@", wError.localizedDescription);
            
            NSAlert *errPanel = [[NSAlert alloc] init];
            [errPanel setMessageText:@"ANDERSEN ERROR"];
            [errPanel setAlertStyle:NSAlertStyleCritical];
            [errPanel setInformativeText:@"OUTENG Failed"];
            [errPanel runModal];
            
            return @"ERROR - Error in OUTENG";
        }
    }
    
    if (fluxLinePtr != NULL)
    {
        // Create the "BAS.FIL" file with the flux lines in it
        if (FIELDPRPMAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
        {
            DLog(@"Error in FieldPrep. %@", wError.localizedDescription);
            
            NSAlert *errPanel = [[NSAlert alloc] init];
            [errPanel setMessageText:@"ANDERSEN ERROR"];
            [errPanel setAlertStyle:NSAlertStyleCritical];
            [errPanel setInformativeText:@"FIELDPREP Failed"];
            [errPanel runModal];
            
            return @"ERROR - Error in FIELDPREP";
        }
        
        *fluxLinePtr = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@BAS.FIL", userTempDir] encoding:NSUTF8StringEncoding error:NULL];
    }
    
    // The current file named "OUTPUT" is from either OUTMET or OUTENG
    NSString *result = [NSString stringWithContentsOfFile:outputFileName encoding:NSUTF8StringEncoding error:&wError];
    
    return result;
}

+ (NSString*)RunFLD12withString:(NSString *)fileString outputType:(PCH_FLD12_OutputType)outputType withFluxLines:(BOOL)withFluxLines
{
    NSString *fluxLines = @"";
    
    return [PCH_FLD12_Library RunFLD12withString:fileString outputType:outputType fluxLineString:(withFluxLines ? &fluxLines : NULL) fld8String:NULL];
}

+ (NSString * _Nonnull)RunFLD12withTxfo:(PCH_FLD12_TxfoDetails *_Nonnull)txfo outputType:(PCH_FLD12_OutputType)outputType fluxLineString:(NSString *_Nonnull*_Nullable)fluxLinePtr fld8String:(NSString *_Nonnull*_Nullable)fld8Ptr;
{
    NSMutableString *result = [NSMutableString string];
    NSString *nextLine;
    
    // Line 1
    [result appendFormat:@"%@\n", txfo.identification];
    
    // Line 2
    nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.1f%-10.1d%-10.1d%-10.3f%-10.3f%-10.3f\n",
                txfo.inputUnits, 
                txfo.numPhases,
                txfo.frequency,
                txfo.numberOfWoundLimbs,
                1,
                txfo.lowerZ,
                txfo.upperZ,
                txfo.coreDiameter
                ];
    [result appendString:nextLine];
    
    // Line 3
    nextLine = [NSString stringWithFormat:@"%-10.3f%-10.1d%-10.3f%-10.4f%-10.3f%-10.1d%-10.1d\n",
                txfo.distanceToTank,
                txfo.alcuShield,
                txfo.sysSCgva,
                txfo.puImpedance,
                txfo.peakFactor,
                txfo.numTerminals,
                txfo.numLayers
                ];
    [result appendString:nextLine];
    
    // Line 4
    nextLine = [NSString stringWithFormat:@"%-10.1d%-10.3f%-10.3f%-10.3f%-10.3f%-10.1f%-10.1d\n",
                txfo.dispElon,
                txfo.deAmount,
                txfo.tankFactor,
                txfo.legFactor,
                txfo.yokeFactor,
                txfo.scale,
                txfo.numFluxLines
                ];
    [result appendString:nextLine];
    
    
    // Terminals
    for (PCH_FLD12_Terminal *nextTerminal in txfo.terminals)
    {
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.3f%-10.3f\n",
                    nextTerminal.number,
                    nextTerminal.connection,
                    nextTerminal.mva,
                    nextTerminal.kv
                    ];
        [result appendString:nextLine];
    }
    
    NSMutableArray *segments = [NSMutableArray array];
    
    // Layers
    for (PCH_FLD12_Layer *nextLayer in txfo.layers)
    {
        [segments addObjectsFromArray:nextLayer.segments];
        
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.3f%-10.3f\n",
                    nextLayer.number,
                    nextLayer.lastSegment,
                    nextLayer.innerRadius,
                    nextLayer.radialBuild
                    ];
        [result appendString:nextLine];
        
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.1d%-10.1d%-10.1d%-10.3f\n",
                    nextLayer.terminal,
                    nextLayer.numParGroups,
                    nextLayer.currentDirection,
                    nextLayer.cuOrAl,
                    nextLayer.numSpacerBlocks,
                    nextLayer.spBlkWidth
                    ];
        [result appendString:nextLine];
    }
    
    // Segments
    for (PCH_FLD12_Segment *nextSegment in segments)
    {
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.3f%-10.3f%-10.3f%-10.3f\n",
                    nextSegment.segmentNumber,
                    nextSegment.zMin,
                    nextSegment.zMax,
                    nextSegment.turns,
                    nextSegment.activeTurns
                    ];
        [result appendString:nextLine];
        
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.3f%-10.3f\n",
                    nextSegment.strandsPerTurn,
                    nextSegment.strandsPerLayer,
                    nextSegment.strandR,
                    nextSegment.strandA
                    ];
        [result appendString:nextLine];
    }
    
    NSString *userTempDir = [NSString stringWithFormat:@"%@RESULT", NSTemporaryDirectory()];
    
    NSURL *resultURL = [NSURL fileURLWithPath:userTempDir];
    
    NSError *wError;
    if (![result writeToURL:resultURL atomically:false encoding:NSUTF8StringEncoding error:&wError])
    {
        NSAlert *errPanel = [NSAlert alertWithError:wError];
        [errPanel runModal];
    }
    
    return [PCH_FLD12_Library RunFLD12withString:result outputType:outputType fluxLineString:fluxLinePtr fld8String:fld8Ptr];
}

+ (NSString *)RunFLD12withTxfo:(PCH_FLD12_TxfoDetails *)txfo outputType:(PCH_FLD12_OutputType)outputType withFluxLines:(BOOL)withFluxLines
{
    NSString *dummyFlux = @"";
    
    return [PCH_FLD12_Library RunFLD12withTxfo:txfo outputType:outputType fluxLineString:(withFluxLines ? &dummyFlux : NULL) fld8String:NULL];
}


+ (PCH_FLD12_OutputData *)RunFLD12withTxfo:(PCH_FLD12_TxfoDetails *)txfo outputType:(PCH_FLD12_OutputType)outputType
{
    NSString *fluxLines = @"";
    NSString *fld8File = @"";
    
    NSString *outputString = [PCH_FLD12_Library RunFLD12withTxfo:txfo outputType:outputType fluxLineString:&fluxLines fld8String:&fld8File];
    
    if ([outputString hasPrefix:@"ERROR"])
    {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"ANDERSEN ERROR"];
        [alert setInformativeText:outputString];
        [alert runModal];
    }
    
    return [PCH_FLD12_OutputData dataWithOutputFile:outputString fluxLines:fluxLines fld8File:fld8File];
}


+ (NSString * _Nonnull)CreateFLD12InputFileWithTxfo:(PCH_FLD12_TxfoDetails *_Nonnull)txfo
{
    NSMutableString *result = [NSMutableString string];
    NSString *nextLine;
    
    // Line 1
    [result appendFormat:@"%@\n", txfo.identification];
    
    // Line 2
    nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.1f%-10.1d%-10.1d%-10.3f%-10.3f%-10.3f\n",
                txfo.inputUnits,
                txfo.numPhases,
                txfo.frequency,
                txfo.numberOfWoundLimbs,
                1,
                txfo.lowerZ,
                txfo.upperZ,
                txfo.coreDiameter
                ];
    [result appendString:nextLine];
    
    // Line 3
    nextLine = [NSString stringWithFormat:@"%-10.3f%-10.1d%-10.3f%-10.4f%-10.3f%-10.1d%-10.1d\n",
                txfo.distanceToTank,
                txfo.alcuShield,
                txfo.sysSCgva,
                txfo.puImpedance,
                txfo.peakFactor,
                txfo.numTerminals,
                txfo.numLayers
                ];
    [result appendString:nextLine];
    
    // Line 4
    nextLine = [NSString stringWithFormat:@"%-10.1d%-10.3f%-10.3f%-10.3f%-10.3f%-10.1f%-10.1d\n",
                txfo.dispElon,
                txfo.deAmount,
                txfo.tankFactor,
                txfo.legFactor,
                txfo.yokeFactor,
                txfo.scale,
                txfo.numFluxLines
                ];
    [result appendString:nextLine];
    
    
    // Terminals
    for (PCH_FLD12_Terminal *nextTerminal in txfo.terminals)
    {
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.3f%-10.3f\n",
                    nextTerminal.number,
                    nextTerminal.connection,
                    nextTerminal.mva,
                    nextTerminal.kv
                    ];
        [result appendString:nextLine];
    }
    
    NSMutableArray *segments = [NSMutableArray array];
    
    // Layers
    for (PCH_FLD12_Layer *nextLayer in txfo.layers)
    {
        [segments addObjectsFromArray:nextLayer.segments];
        
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.3f%-10.3f\n",
                    nextLayer.number,
                    nextLayer.lastSegment,
                    nextLayer.innerRadius,
                    nextLayer.radialBuild
                    ];
        [result appendString:nextLine];
        
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.1d%-10.1d%-10.1d%-10.3f\n",
                    nextLayer.terminal,
                    nextLayer.numParGroups,
                    nextLayer.currentDirection,
                    nextLayer.cuOrAl,
                    nextLayer.numSpacerBlocks,
                    nextLayer.spBlkWidth
                    ];
        [result appendString:nextLine];
    }
    
    // Segments
    for (PCH_FLD12_Segment *nextSegment in segments)
    {
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.3f%-10.3f%-10.3f%-10.3f\n",
                    nextSegment.segmentNumber,
                    nextSegment.zMin,
                    nextSegment.zMax,
                    nextSegment.turns,
                    nextSegment.activeTurns
                    ];
        [result appendString:nextLine];
        
        nextLine = [NSString stringWithFormat:@"%-10.1d%-10.1d%-10.3f%-10.3f\n",
                    nextSegment.strandsPerTurn,
                    nextSegment.strandsPerLayer,
                    nextSegment.strandR,
                    nextSegment.strandA
                    ];
        [result appendString:nextLine];
    }
    
    return result;
}

@end
