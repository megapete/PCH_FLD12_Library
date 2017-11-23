//
//  PCH_FLD12_Library.h
//  PCH_FLD12_Library
//
//  Created by PeterCoolAssHuber on 2017-11-22.
//  Copyright © 2017 Peter Huber. All rights reserved.
//

#import <Foundation/Foundation.h>

// Apparently using NS_ENUM will make the enum usable in Swift code
typedef NS_ENUM(NSUInteger, PCH_FLD12_OutputType) {
    metric,
    imperial
};



@interface PCH_FLD12_Library : NSObject

+ (NSString*)FLD12:(NSString *)fileString outputType:(PCH_FLD12_OutputType)outputType;

@end
