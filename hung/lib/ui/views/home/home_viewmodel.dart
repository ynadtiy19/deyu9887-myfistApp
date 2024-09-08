import 'package:hung/app/app.bottomsheets.dart';
import 'package:hung/app/app.dialogs.dart';
import 'package:hung/app/app.locator.dart';
import 'package:hung/ui/common/app_strings.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();

  String get counterLabel => 'Counter is: $_counter';
  int _counter = 0;

  int _uuuindex = 0;
  int get uuuindex => _uuuindex;

  void onTabChange(int index) {
    _uuuindex = index; // 将选中的索引值发送到BehaviorSubject中
    print('uuu :$index');
    rebuildUi(); // 通知视图更新,get到上面
  }

  void showDialog() {
    _dialogService.showCustomDialog(
      variant: DialogType.infoAlert,
      title: 'Stacked Rocks!',
      description: 'Give stacked $_counter stars on Github',
    );
  }

  void showBottomSheet() {
    _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
  }
}
