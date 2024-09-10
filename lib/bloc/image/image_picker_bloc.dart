import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:partner_admin_portal/constants/manage_settings/manage_settings_variables.dart';
import 'dart:typed_data';
import 'image_picker_state.dart';
import 'dart:io' as iFile;

class ImagePickerBloc extends Bloc<ImagePickerEvent, ImagePickerState> {
  ImagePickerBloc() : super(ImageNotPickedState());

  @override
  Stream<ImagePickerState> mapEventToState(ImagePickerEvent event) async* {
    if (event is PickImageEvent) {
      yield* _mapPickImageToState();
    }
    else if(event is PickPanImageEvent) {
      yield* _mapPickPanImageToState();
    }
    else if(event is PickGstImageEvent){
      yield* _mapPickGstToState();
    } else if(event is PickRestaurantImageEvent) {
      yield* _mapPickRestaurantToState();
    }
  }



  Stream<ImagePickerState> _mapPickImageToState() async* {
    try {
      print("Coming here");
      final ImagePicker _picker = ImagePicker();
      print(_picker);
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var imageData = await image.readAsBytes();
        print("Coming here after reading image bytes");
        print(imageData);
        ManageSettingsVariables.passbookImage = imageData;
        ManageSettingsVariables.pickedPassbookImage = iFile.File("a");
        yield ImagePickedState(imageData: Uint8List.fromList(imageData));
      } else {
        yield ImageNotPickedState();
      }
    } catch (e) {
      print("Error: $e");
      yield ImageNotPickedState();
    }
  }


  Stream<ImagePickerState> _mapPickPanImageToState() async* {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var imageData = await image.readAsBytes();
      print(imageData);
      ManageSettingsVariables.panImage = imageData;
      ManageSettingsVariables.pickedPankImage = iFile.File("a");
      yield ImagePickedState(imageData: Uint8List.fromList(imageData));
    } else {
      yield ImageNotPickedState();
    }
  }

  Stream<ImagePickerState> _mapPickGstToState() async* {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var imageData = await image.readAsBytes();
      ManageSettingsVariables.gstImage = imageData;
      ManageSettingsVariables.pickedGstImage = iFile.File("a");
      yield ImagePickedState(imageData: Uint8List.fromList(imageData));
    } else {
      yield ImageNotPickedState();
    }
  }

  Stream<ImagePickerState> _mapPickRestaurantToState() async* {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var imageData = await image.readAsBytes();
      ManageSettingsVariables.webImage = imageData;
      ManageSettingsVariables.pickedImage = iFile.File("a");
      yield ImagePickedState(imageData: Uint8List.fromList(imageData));
    } else {
      yield ImageNotPickedState();
    }
  }
}
