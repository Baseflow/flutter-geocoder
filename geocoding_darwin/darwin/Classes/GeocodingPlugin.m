//
//  GeocodingPlugin.m
//  geocoding
//
//  Created by Maurits van Beusekom on 07/06/2020.
//

#import "CLPlacemarkExtensions.h"
#import "GeocodingHandler.h"
#import "GeocodingPlugin.h"

@implementation GeocodingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"flutter.baseflow.com/geocoding"
                                     binaryMessenger:[registrar messenger]];
    GeocodingPlugin* instance = [[GeocodingPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"locationFromAddress" isEqualToString:call.method]) {
        NSString* address = call.arguments[@"address"];
        
        GeocodingHandler* handler = [[GeocodingHandler alloc] init];
        [handler geocodeFromAddress:address
                             locale:[GeocodingPlugin parseLocale: call.arguments]
                            success:^(NSArray<CLPlacemark *> * placemarks) {
            result([GeocodingPlugin toLocationResult: placemarks]);
        }
                            failure:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
            result([FlutterError errorWithCode:errorCode
                                       message:errorDescription
                                       details:nil]);
        }];
    } else if ([@"placemarkFromCoordinates" isEqualToString:call.method]) {
        CLLocationDegrees latitude = ((NSNumber *) call.arguments[@"latitude"]).doubleValue;
        CLLocationDegrees longitude = ((NSNumber *) call.arguments[@"longitude"]).doubleValue;
        CLLocation* location = [[CLLocation alloc] initWithLatitude:latitude
                                                          longitude:longitude];
        
        GeocodingHandler* handler = [[GeocodingHandler alloc] init];
        [handler geocodeToAddress:location
                           locale:[GeocodingPlugin parseLocale: call.arguments]
                          success:^(NSArray<CLPlacemark *> * placemarks) {
            result([GeocodingPlugin toPlacemarkResult: placemarks]);
        }
                          failure:^(NSString * _Nonnull errorCode, NSString * _Nonnull errorDescription) {
            result([FlutterError errorWithCode:errorCode
                                       message:errorDescription
                                       details:nil]);
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (NSLocale*) parseLocale:(NSDictionary*)arguments {
    if (arguments[@"localeIdentifier"] == nil) {
        return nil;
    }
    
    return [[NSLocale alloc] initWithLocaleIdentifier:(NSString*) arguments[@"localeIdentifier"]];
}

+ (NSArray<NSDictionary *> *) toLocationResult:(NSArray<CLPlacemark *> *)placemarks {
    NSMutableArray<NSDictionary *> *result = [[NSMutableArray alloc] init];
    
    for (CLPlacemark *placemark in  placemarks) {
        [result addObject:[placemark toLocationDictionary]];
    }
    
    return result;
}

+ (NSArray<NSDictionary *> *) toPlacemarkResult:(NSArray<CLPlacemark *> *)placemarks {
    NSMutableArray<NSDictionary *> *result = [[NSMutableArray alloc] init];
    
    for (CLPlacemark *placemark in  placemarks) {
        [result addObject:[placemark toPlacemarkDictionary]];
    }
    
    return result;
}

@end
