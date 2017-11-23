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

@implementation PCH_FLD12_Library

+ (NSString*)FLD12:(NSString *)fileString outputType:(PCH_FLD12_OutputType)outputType
{
    NSString *result = [NSString stringWithFormat:@"%@\n\nGotcha!", fileString];
    
    return result;
}

@end
