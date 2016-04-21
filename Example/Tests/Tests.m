//
//  Tapstream-SegmentTests.m
//  Tapstream-SegmentTests
//
//  Created by Adam Bard on 04/19/2016.
//  Copyright (c) 2016 Adam Bard. All rights reserved.
//

// https://github.com/Specta/Specta

#include "TSTapstream.h"
#include "TSSegmentIntegration.h"

SpecBegin(InitialSpecs);

describe(@"Mixpanel Integration", ^{
	__block TSTapstream *tapstream;
	__block TSSegmentIntegration *integration;

	beforeEach(^{
		tapstream = mock([TSTapstream class]);
		integration = [[TSSegmentIntegration alloc] initWithSettings:@{
																		 @"trackAllPages" : @1,
																		 @"setAllTraitsByDefault" : @1
																		} andTapstream:tapstream];

	});

	it(@"track", ^{

		SEGTrackPayload* pl = [[SEGTrackPayload alloc] initWithEvent:@"test-event" properties:@{} context:@{} integrations:@{}];
		[integration track:pl];

		HCArgumentCaptor *argument = [[HCArgumentCaptor alloc] init];
		[verify(tapstream) fireEvent:(id)argument];
		TSEvent* e = (id)argument.value;

		assertThat(e.name, is(@"test-event"));
		NSLog(@"\n\n\n---\n\nVAL: %lu\n\n\n", ((unsigned long) [e.customFields count]));
		assertThatUnsignedLong([e.customFields count], equalToLong(0));

	});

	it(@"tracks_with_props", ^{
		NSDictionary* props = @{
								@"testkey1": @"testval1",
								@"testkey2": @"testval2"
								};

		SEGTrackPayload* pl = [[SEGTrackPayload alloc] initWithEvent:@"test-event2" properties:props context:@{} integrations:@{}];
		[integration track:pl];

		HCArgumentCaptor *argument = [[HCArgumentCaptor alloc] init];
		[verify(tapstream) fireEvent:(id)argument];
		TSEvent* e = (id)argument.value;

		assertThat(e.name, is(@"test-event2"));
		assertThatUnsignedLong([e.customFields count], equalToLong(2));

		assertThat([e.customFields valueForKey:@"testkey1"], is(@"testval1"));
		assertThat([e.customFields valueForKey:@"testkey2"], is(@"testval2"));
	});

	it(@"stores string settings correctly", ^{
		TSConfig* conf = [TSConfig configWithDefaults];
		NSDictionary* settings = @{
								   @"accountName": @"sdktest",
								   @"installEventName": @"my-install-event",
								   @"openEventName": @"my-open-event",
								   @"hardcodedBundleId": @"my-bundle-id",
								   @"hardcodedBundleShortVersionString": @"2.1.0",
								   @"odin1": @"my-odin1",
								   @"openUdid": @"my-openudid",
								   @"idfa": @"my-idfa",
								   @"secureUdid": @"my-secureudid"
								   };

		assertThat(conf.installEventName, nilValue());
		assertThat(conf.openEventName, nilValue());
		assertThat(conf.hardcodedBundleId, nilValue());
		assertThat(conf.hardcodedBundleShortVersionString, nilValue());
		assertThat(conf.odin1, nilValue());
		assertThat(conf.openUdid, nilValue());
		assertThat(conf.idfa, nilValue());
		assertThat(conf.secureUdid, nilValue());

		[TSSegmentIntegration updateConfig:conf withSettings:settings];

		assertThat(conf.installEventName, is(@"my-install-event"));
		assertThat(conf.openEventName, is(@"my-open-event"));
		assertThat(conf.hardcodedBundleId, is(@"my-bundle-id"));
		assertThat(conf.hardcodedBundleShortVersionString, is(@"2.1.0"));
		assertThat(conf.odin1, is(@"my-odin1"));
		assertThat(conf.openUdid, is(@"my-openudid"));
		assertThat(conf.idfa, is(@"my-idfa"));
		assertThat(conf.secureUdid, is(@"my-secureudid"));
	});

	it(@"Stores boolean settings correctly", ^{
		TSConfig* conf = [TSConfig configWithDefaults];
		NSDictionary* settings = @{
								   @"fireAutomaticInstallEvent": @false,
								   @"fireAutomaticOpenEvent": @false,
								   @"autoCollectIdfa": @false,
								   @"collectWifiMac": @false,
								   @"fireAutomaticIAPEvents": @false,
								   @"attemptCookieMatch": @true
								   };

		assertThatInt(conf.fireAutomaticInstallEvent, equalToInt(true));
		assertThatInt(conf.fireAutomaticOpenEvent, equalToInt(true));
		assertThatInt(conf.autoCollectIdfa, equalToInt(true));
		assertThatInt(conf.collectWifiMac, equalToInt(true));
		assertThatInt(conf.fireAutomaticIAPEvents, equalToInt(true));
		assertThatInt(conf.attemptCookieMatch, equalToInt(false));

		[TSSegmentIntegration updateConfig:conf withSettings:settings];

		assertThatInt(conf.fireAutomaticInstallEvent, equalToInt(false));
		assertThatInt(conf.fireAutomaticOpenEvent, equalToInt(false));
		assertThatInt(conf.autoCollectIdfa, equalToInt(false));
		assertThatInt(conf.collectWifiMac, equalToInt(false));
		assertThatInt(conf.fireAutomaticIAPEvents, equalToInt(false));
		assertThatInt(conf.attemptCookieMatch, equalToInt(true));

		settings = @{
					 @"fireAutomaticInstallEvent": @true,
					 @"fireAutomaticOpenEvent":@true,
					 @"autoCollectIdfa":@true,
					 @"collectWifiMac": @true,
					 @"fireAutomaticIAPEvents": @true,
					 @"attemptCookieMatch": @false
					};

		[TSSegmentIntegration updateConfig:conf withSettings:settings];

		assertThatInt(conf.fireAutomaticInstallEvent, equalToInt(true));
		assertThatInt(conf.fireAutomaticOpenEvent, equalToInt(true));
		assertThatInt(conf.autoCollectIdfa, equalToInt(true));
		assertThatInt(conf.collectWifiMac, equalToInt(true));
		assertThatInt(conf.fireAutomaticIAPEvents, equalToInt(true));
		assertThatInt(conf.attemptCookieMatch, equalToInt(false));

	});

});

SpecEnd