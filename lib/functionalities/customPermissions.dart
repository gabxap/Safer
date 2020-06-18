import 'package:permission_handler/permission_handler.dart';

void requestPermission(String permission) async {
  switch (permission) {
    case 'location':
      await PermissionHandler().requestPermissions([PermissionGroup.location]);
      break;
  }
}
