//
//  TSSegmentIntegrationFactory.m
//  Pods
//
//  Created by Adam Bard on 2016-04-22.
//
//

#import <Foundation/Foundation.h>
#include "TSSegmentIntegration.h"
#include "TSSegmentIntegrationFactory.h"

@implementation TSSegmentIntegrationFactory

-(id<SEGIntegration>) createWithSettings:(NSDictionary *)settings forAnalytics:(SEGAnalytics *)analytics
{
	return [[TSSegmentIntegration alloc] initWithSettings:settings];
}

-(NSString *)key
{
	return @"Tapstream";
}

@end