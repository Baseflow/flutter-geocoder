//
//  CLPlacemarkExtensions.m
//  geocoding
//
//  Created by Maurits van Beusekom on 07/06/2020.
//

#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "CLPlacemarkExtensions.h"

@implementation CLPlacemark (CLPlacemarkExtensions)

- (NSDictionary *)toPlacemarkDictionary {
    NSString* street = @"";
    
    if (self.postalAddress != nil) {
        street = self.postalAddress.street;
    }
    
    NSMutableDictionary<NSString *, NSObject *> *dict = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"name": self.name == nil ? @"" : self.name,
        @"street": street == nil ? @"" : street,
        @"isoCountryCode": self.ISOcountryCode == nil ? @"" : self.ISOcountryCode,
        @"country": self.country == nil ? @"" : self.country,
        @"thoroughfare": self.thoroughfare == nil ? @"" : self.thoroughfare,
        @"subThoroughfare": self.subThoroughfare == nil ? @"" : self.subThoroughfare,
        @"postalCode": self.postalCode == nil ? @"" : self.postalCode,
        @"administrativeArea": self.administrativeArea == nil ? @"" : self.administrativeArea,
        @"subAdministrativeArea": self.subAdministrativeArea == nil ? @"" : self.subAdministrativeArea,
        @"locality": self.locality == nil ? @"" : self.locality,
        @"subLocality": self.subLocality == nil ? @"" : self.subLocality,
    }];
    
    return dict;
}

- (NSDictionary *)toLocationDictionary {
    if (self.location == nil) {
        return nil;
    }
    
    NSMutableDictionary<NSString *, NSObject*> *dict = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"latitude": @(self.location.coordinate.latitude),
        @"longitude": @(self.location.coordinate.longitude),
        @"timestamp": @([CLPlacemark currentTimeInMilliSeconds: self.location.timestamp]),
    }];
    
    return dict;
}

+ (double)currentTimeInMilliSeconds:(NSDate *)dateToConvert {
    NSTimeInterval since1970 = [dateToConvert timeIntervalSince1970];
    return since1970 * 1000;
}

@end
