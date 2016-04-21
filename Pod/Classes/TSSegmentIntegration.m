#include "TSSegmentIntegration.h"


@implementation TSSegmentIntegration

+ (BOOL)booleanFrom:(NSDictionary*)d forKey:(NSString*)k withDefault:(BOOL)def
{
	NSNumber* v = [d valueForKey:k];
	if (v == nil){
		return def;
	}
	return [v boolValue];
}

+ (void)updateConfig:(TSConfig*)conf withSettings:(NSDictionary*)settings
{
	[conf setInstallEventName:[settings valueForKey:@"installEventName"]];
	[conf setOpenEventName:[settings valueForKey:@"openEventName"]];
	[conf setHardcodedBundleId:[settings valueForKey:@"hardcodedBundleId"]];
	[conf setHardcodedBundleShortVersionString:[settings valueForKey:@"hardcodedBundleShortVersionString"]];

	[conf setOdin1:[settings valueForKey:@"odin1"]];
	[conf setOpenUdid:[settings valueForKey:@"openUdid"]];
	[conf setIdfa:[settings valueForKey:@"idfa"]];
	[conf setSecureUdid:[settings valueForKey:@"secureUdid"]];


	[conf setFireAutomaticInstallEvent:[self booleanFrom:settings
												  forKey:@"fireAutomaticInstallEvent"
											 withDefault:true]];
	[conf setFireAutomaticOpenEvent:[self booleanFrom:settings
												  forKey:@"fireAutomaticOpenEvent"
											 withDefault:true]];
	[conf setAutoCollectIdfa:[self booleanFrom:settings
										forKey:@"autoCollectIdfa"
								   withDefault:true]];
	[conf setCollectWifiMac:[self booleanFrom:settings
										forKey:@"collectWifiMac"
								   withDefault:true]];

	[conf setFireAutomaticIAPEvents:[self booleanFrom:settings
											   forKey:@"fireAutomaticIAPEvents"
										  withDefault:true]];
	[conf setAttemptCookieMatch:[self booleanFrom:settings
										   forKey:@"attemptCookieMatch"
									  withDefault:false]];

	NSSet* topLevelKeys = [[NSSet alloc] initWithArray:@[
														 @"installEventName",
														 @"openEventName",
														 @"hardcodedBundleId",
														 @"hardcodedBundleShortVersionString",
														 @"odin1",
														 @"openUdid",
														 @"idfa",
														 @"secureUdid",
														 @"fireAutomaticInstallEvent",
														 @"fireAutomaticOpenEvent",
														 @"autoCollectIdfa",
														 @"collectWifiMac",
														 @"fireAutomaticIAPEvents",
														 @"attemptCookieMatch"
														 ]];

	for(NSString* k in settings){
		if (![topLevelKeys containsObject:k]){
			[conf.globalEventParams setValue:[settings valueForKey:k] forKey:k];
		}
	}
}

- (instancetype)initWithSettings:(NSDictionary *)settings
{
	if (self = [super init]) {
		self.settings = settings;
		NSString *accountName = [self.settings objectForKey:@"accountName"];
		NSString *sdkSecret = [self.settings objectForKey:@"sdkSecret"];
		TSConfig *config = [TSConfig configWithDefaults];

		[TSSegmentIntegration updateConfig:config withSettings:settings];
		[TSTapstream createWithAccountName:accountName developerSecret:sdkSecret config:config];
		self.tapstream = [TSTapstream instance];
	}
	return self;
}

- (instancetype)initWithSettings:(NSDictionary *)settings andTapstream:(TSTapstream *)tapstream
{
	if (self = [super init]) {
		self.settings = settings;
		self.tapstream = tapstream;
	}
	return self;
}

- (void) track:(SEGTrackPayload*)payload
{
	TSEvent* event = [TSEvent eventWithName:payload.event oneTimeOnly:false];

	for(NSString* key in payload.properties){
		[event addValue:[payload.properties valueForKey:key] forKey:key];
	}

	[self.tapstream fireEvent:event];
}
@end
