export 'package:flutter/material.dart';
export 'package:expance/core/size_utils.dart';
export 'package:expance/core/widgets/input_simple.dart';
export 'package:expance/core/utils/snack_bar.dart';
export 'package:expance/core/utils/navigator_service.dart';
export 'package:expance/core/utils/date_difference.dart';
export 'package:expance/core/utils/my_colors.dart';
export 'package:expance/core/utils/paginate_list_view.dart';
export 'package:expance/core/utils/bold_text.dart';
export 'package:expance/core/utils/imageView/shimmer_effect.dart';
export 'package:expance/core/utils/string_utils.dart';
export 'package:expance/core/utils/map_utils.dart';
export 'package:expance/core/state-management/state_manage.dart';
export 'package:expance/core/utils/elevatedButton/elevated_button.dart';
export 'package:expance/models/model.paginate.dart';
export 'package:expance/core/utils/date_time_utils.dart';
export 'package:expance/core/utils/flexi_wrap.dart';
export 'package:lucide_icons_flutter/lucide_icons.dart';
export 'package:expance/widgets/container.dart';
export 'package:expance/core/utils/progress_dialog_utils.dart';

import 'dart:developer';

import 'package:expance/presentation/main/web_page.dart';
import 'package:expance/services/local_db/local_db.dart';
import 'package:flutter/foundation.dart';

import 'package:expance/models/index.dart' as m;
import 'package:expance/widgets/text.dart';

import 'common.dart';

const fCollection = (user: "user", iceOffer: 'iceOffers', sessions: "sessions");

// bool get web => kIsWeb;
final webWidht = web ? 465.fem : null;

final txt = MyTextWidget();

final pageWeb = ManageWebPage();

final g = GlobalVariable();

class GlobalVariable {}

class GVar {
  static final db = LocalDb();
  static bool get isWeb => kIsWeb;
}

printf(List d) {
  if (kDebugMode) {
    for (var e in d) {
      log(e.toString());
    }
  }
}

extension EmailAtRemove on String? {
  String? toRemoveAtTheRate() {
    if (this != null) {
      return this!.split("@").first;
    }
    return null;
  }
}
