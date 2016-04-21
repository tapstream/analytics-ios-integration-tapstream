//
//  TSSegmentIntegration.h
//  Pods
//
//  Created by Adam Bard on 2016-04-19.
//
//



#ifndef TSSegmentIntegration_h
#define TSSegmentIntegration_h

#include "TSTapstream.h"
#import <Analytics/SEGIntegration.h>

@interface TSSegmentIntegration : NSObject <SEGIntegration>

@property (nonatomic, strong) NSDictionary *settings;
@property (nonatomic, strong) TSTapstream *tapstream;

+ (void)updateConfig:(TSConfig*)conf withSettings:(NSDictionary*)settings;
- (instancetype)initWithSettings:(NSDictionary *)settings;
- (instancetype)initWithSettings:(NSDictionary *)settings andTapstream:(TSTapstream *)tapstream;


@end

#endif /* TSSegmentIntegration_h */
