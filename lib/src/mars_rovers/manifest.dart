// Copyright (C) 2023 by Voidari LLC or its subsidiaries.
library nasa_apis;

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:nasa_apis/src/mars_rovers/cameras.dart';
import 'package:nasa_apis/src/mars_rovers/day_info_item.dart';
import 'package:nasa_apis/src/mars_rovers/manifest_model.dart';

/// The mission status options.
enum MarsRoverStatus {
  active,
  unknown,
}

/// The container for the rover manifest data, providing the parsed information.
class MarsRoverManifest {
  /// The name of the rover.
  final String name;

  /// The rover's landing date on Mars.
  final DateTime landingDate;

  /// The rover's launch date from Earth.
  final DateTime launchDate;

  /// The rover's mission status.
  final MarsRoverStatus status;

  /// The most recent Martian sol from which photos exist.
  final int maxSol;

  /// The most recent Earth date from which photos exist.
  final DateTime maxDate;

  /// The number of photos taken by the rover.
  final int totalPhotos;

  /// The manifest list of photos for all time.
  final List<MarsRoverDayInfoItem>? photos;

  /// The expiration time of the cache. Set to null to keep the cache persistent
  /// and avoid deletion. Set to the current time or less to force deletion. The
  /// expiration date should be a future date and time.
  DateTime? expiration;

  /// The constructor of the MarsRoverManifest item.
  MarsRoverManifest(
    this.name,
    this.landingDate,
    this.launchDate,
    this.status,
    this.maxSol,
    this.maxDate,
    this.totalPhotos, {
    this.photos,
    this.expiration,
  });

  /// Determines if the mission status is ongoing.
  bool isActive() {
    return status == MarsRoverStatus.active;
  }

  /// Creates an item from the provided [map] object.
  static MarsRoverManifest fromMap(Map<String, dynamic> map) {
    String name = map[MarsRoverManifestModel.keyName];
    DateTime landingDate = DateTime.fromMillisecondsSinceEpoch(
        map[MarsRoverManifestModel.keyLandingDate]);
    DateTime launchDate = DateTime.fromMillisecondsSinceEpoch(
        map[MarsRoverManifestModel.keyLaunchDate]);
    MarsRoverStatus status =
        MarsRoverStatus.values.byName(map[MarsRoverManifestModel.keyStatus]);
    int maxSol = map[MarsRoverManifestModel.keyMaxSol];
    DateTime maxDate = DateTime.fromMillisecondsSinceEpoch(
        map[MarsRoverManifestModel.keyMaxDate]);
    int totalPhotos = map[MarsRoverManifestModel.keyTotalPhotos];
    DateTime? expiration = map.containsKey(MarsRoverManifestModel.keyExpiration)
        ? DateTime.fromMillisecondsSinceEpoch(
            map[MarsRoverManifestModel.keyExpiration])
        : null;

    return MarsRoverManifest(
      name,
      landingDate,
      launchDate,
      status,
      maxSol,
      maxDate,
      totalPhotos,
      expiration: expiration,
    );
  }

  /// Creates a map given the current manifest data.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map[MarsRoverManifestModel.keyName] = name;
    map[MarsRoverManifestModel.keyLandingDate] =
        landingDate.millisecondsSinceEpoch;
    map[MarsRoverManifestModel.keyLaunchDate] =
        launchDate.millisecondsSinceEpoch;
    map[MarsRoverManifestModel.keyStatus] = status.name;
    map[MarsRoverManifestModel.keyMaxSol] = maxSol;
    map[MarsRoverManifestModel.keyMaxDate] = maxDate.millisecondsSinceEpoch;
    map[MarsRoverManifestModel.keyTotalPhotos] = totalPhotos;
    map.putIfAbsent(MarsRoverManifestModel.keyExpiration,
        () => expiration != null ? expiration?.millisecondsSinceEpoch : 0);
    return map;
  }

  /// Provides an override for a detailed MarsRoverManifest string.
  @override
  String toString() {
    return "MarsRoverManifest("
        "${MarsRoverManifestModel.keyName}: $name, "
        "${MarsRoverManifestModel.keyLandingDate}: ${landingDate.toUtc()}, "
        "${MarsRoverManifestModel.keyLaunchDate}: ${launchDate.toUtc()}, "
        "${MarsRoverManifestModel.keyStatus}: ${status.name}, "
        "${MarsRoverManifestModel.keyMaxSol}: $maxSol, "
        "${MarsRoverManifestModel.keyMaxDate}: ${maxDate.toUtc()}, "
        "${MarsRoverManifestModel.keyTotalPhotos}: ${totalPhotos.toString()} "
        ")";
  }

  /// Comparison operator for the item. Used to perform a deep comparison.
  @override
  bool operator ==(Object other) {
    if (other is! MarsRoverManifest) {
      return false;
    }
    MarsRoverManifest otherItem = other;
    return name == otherItem.name &&
        landingDate == otherItem.landingDate &&
        launchDate == otherItem.launchDate &&
        status == otherItem.status &&
        maxSol == otherItem.maxSol &&
        maxDate == otherItem.maxDate &&
        totalPhotos == otherItem.totalPhotos;
  }

  /// The hash code override.
  @override
  int get hashCode => jsonEncode(toMap()).hashCode;
}
