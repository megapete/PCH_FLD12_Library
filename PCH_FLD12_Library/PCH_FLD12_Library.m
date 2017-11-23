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

+ (NSString*)RunFLD12withString:(NSString *)fileString outputType:(PCH_FLD12_OutputType)outputType withFluxLines:(BOOL)withFluxLines
{
    NSString *userTempDir = NSTemporaryDirectory();
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    // We need to make sure that the ATPCM file exists in the temporary directory. If it doesn't, we will assume that the file exists in the user's Documents folder and copy it to the temp folder.
    
    NSString *tempATPCM = [NSString stringWithFormat:@"%@ATPCM.FIL", userTempDir];
    if (![fileMgr fileExistsAtPath:tempATPCM])
    {
        NSArray *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *srcATPCM = [NSString stringWithFormat:@"%@/ATPCM.FIL", docDir[0]];
        
        NSError *wError;
        
        if (![fileMgr copyItemAtPath:srcATPCM toPath:tempATPCM error:&wError])
        {
            DLog(@"Error copying ATPCM.FIL. %@", wError.localizedDescription);
            return @"ERROR - NO ATCPM.FIL file available";
        }
    }
    
    NSString *inp1Fil = [NSString stringWithFormat:@"%@INP1.FIL", userTempDir];
    NSError *wError;
    [fileMgr removeItemAtPath:inp1Fil error:&wError];
    
    if (![fileString writeToFile:inp1Fil atomically:NO encoding:NSUTF8StringEncoding error:&wError])
    {
        DLog(@"Error creating INP1.FIL. %@", wError.localizedDescription);
        return @"ERROR - Could not create INP1.FIL";
    }
    
    if (INP12MAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
    {
        DLog(@"Error in Inp12. %@", wError.localizedDescription);
        return @"ERROR - Error in INP12";
    }
    
    if (FLD8MAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
    {
        DLog(@"Error in Fld8. %@", wError.localizedDescription);
        return @"ERROR - Error in FLD8";
    }
    
    if (outputType == metric)
    {
        if (OUTMETMAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
        {
            DLog(@"Error in OutEng. %@", wError.localizedDescription);
            return @"ERROR - Error in OUTMET";
        }
    }
    else
    {
        if (OUTENGMAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
        {
            DLog(@"Error in OutEng. %@", wError.localizedDescription);
            return @"ERROR - Error in OUTENG";
        }
    }
    
    if (withFluxLines)
    {
        if (FIELDPRPMAIN__((char *)[userTempDir cStringUsingEncoding:NSUTF8StringEncoding]) != 0)
        {
            DLog(@"Error in FieldPrep. %@", wError.localizedDescription);
            return @"ERROR - Error in FIELDPREP";
        }
    }
    
    NSString *outputFileName = [NSString stringWithFormat:@"%@OUTPUT", userTempDir];
    
    NSString *result = [NSString stringWithContentsOfFile:outputFileName encoding:NSUTF8StringEncoding error:&wError];
    
    return result;
}

@end
