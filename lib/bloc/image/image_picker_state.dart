import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

abstract class ImagePickerEvent {}

abstract class ImagePickerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickImageEvent extends ImagePickerEvent {}

class PickPanImageEvent extends ImagePickerEvent {}

class PickGstImageEvent extends ImagePickerEvent {}

class PickRestaurantImageEvent extends ImagePickerEvent {}


class ImagePickedState extends ImagePickerState {
  final Uint8List? imageData;
  final Uint8List? panImage;
  final Uint8List? gstImage;
  final Uint8List? restaurantImage;
  ImagePickedState({this.imageData,this.panImage,this.gstImage,this.restaurantImage});

  @override
  List<Object?> get props => [imageData,panImage,gstImage,restaurantImage];
}

class ImageNotPickedState extends ImagePickerState {}
