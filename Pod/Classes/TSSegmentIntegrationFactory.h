//
//  TSSegmentIntegrationFactory.h
//  Pods
//
//  Created by Adam Bard on 2016-04-22.
//
//

#ifndef TSSegmentIntegrationFactory_h
#define TSSegmentIntegrationFactory_h
#include "TSTapstream.h"

#import <Analytics/SEGIntegrationFactory.h>

@interface TSSegmentIntegrationFactory : NSObject <SEGIntegrationFactory>

-(id<SEGIntegration>) createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics;
-(NSString *)key;

@end

#endif /* TSSegmentIntegrationFactory_h */
