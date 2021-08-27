package com.baseflow.geocoding.utils;

import android.location.Address;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

public class AddressMapper {

    public static List<Map<String, Object>> toAddressHashMapList(List<Address> addresses) {
        List<Map<String, Object>> hashMaps = new ArrayList<>(addresses.size());

        for (Address address : addresses) {
            Map<String, Object> hashMap = AddressMapper.toAddressHashMap(address);
            hashMaps.add(hashMap);
        }

        return hashMaps;
    }

    private static Map<String, Object> toAddressHashMap(Address address) {
        Map<String, Object> placemark = new HashMap<>();
        final String street = AddressLineParser.getStreet(address.getAddressLine(0));

        placemark.put("name", address.getFeatureName());
        placemark.put("street", street);
        placemark.put("isoCountryCode", address.getCountryCode());
        placemark.put("country", address.getCountryName());
        placemark.put("thoroughfare", address.getThoroughfare());
        placemark.put("subThoroughfare", address.getSubThoroughfare());
        placemark.put("postalCode", address.getPostalCode());
        placemark.put("administrativeArea", address.getAdminArea());
        placemark.put("subAdministrativeArea", address.getSubAdminArea());
        placemark.put("locality", address.getLocality());
        placemark.put("subLocality", address.getSubLocality());
        placemark.put("locale", address.getLocale().toString());
        placemark.put("phone", address.getPhone());
        placemark.put("url", address.getUrl());
        placemark.put("premises", address.getPremises());

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i <= address.getMaxAddressLineIndex(); i++) {
            if (i > 0) {
                sb.append("\n");
            }
            sb.append(address.getAddressLine(i));
        }
        placemark.put("formattedAddress", sb.toString());

        if (address.hasLatitude() && address.hasLongitude()) {
            Map<String, Double> locationMap = new HashMap<>();
            locationMap.put("latitude", address.getLatitude());
            locationMap.put("longitude", address.getLongitude());
            placemark.put("location", locationMap);
          }

        return placemark;
    }

    public static List<Map<String, Object>> toLocationHashMapList(List<Address> addresses) {
        List<Map<String, Object>> hashMaps = new ArrayList<>(addresses.size());

        for (Address address : addresses) {
            Map<String, Object> hashMap = AddressMapper.toLocationHashmap(address);
            hashMaps.add(hashMap);
        }

        return hashMaps;
    }

    private static Map<String, Object> toLocationHashmap(Address address) {
        Map<String, Object> location = new HashMap<>();

        location.put("latitude", address.getLatitude());
        location.put("longitude", address.getLongitude());
        location.put("timestamp", Calendar.getInstance(TimeZone.getTimeZone("UTC")).getTimeInMillis());

        return location;
     }
}
