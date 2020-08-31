//
//  PCH_FLD12_Library.h
//  PCH_FLD12_Library
//
//  Created by PeterCoolAssHuber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "PCH_FLD12_TxfoDetails.h"
#import "PCH_FLD12_OutputData.h"

// Apparently using NS_ENUM will make the enum usable in Swift code
typedef NS_ENUM(NSUInteger, PCH_FLD12_OutputType) {
    metric,
    imperial
};

@interface PCH_FLD12_Library : NSObject

+ (NSString * _Nonnull)RunFLD12withTxfo:(PCH_FLD12_TxfoDetails *_Nonnull)txfo outputType:(PCH_FLD12_OutputType)outputType withFluxLines:(BOOL)withFluxLines;

+ (NSString * _Nonnull)RunFLD12withString:(NSString *_Nonnull)fileString outputType:(PCH_FLD12_OutputType)outputType withFluxLines:(BOOL)withFluxLines;

+ (PCH_FLD12_OutputData * _Nullable)RunFLD12withTxfo:(PCH_FLD12_TxfoDetails *_Nonnull)txfo outputType:(PCH_FLD12_OutputType)outputType;

+ (NSString * _Nonnull)CreateFLD12InputFileWithTxfo:(PCH_FLD12_TxfoDetails *_Nonnull)txfo;

@end
