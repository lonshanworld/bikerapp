import 'dart:ui';

import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import "../constants/txtconstants.dart";

class LanguageService{
  final box = GetStorage();

  bool loadLanguageisMyanmar(){
    bool value = box.read(TxtConstant.language) ?? false;
    return value;
  }

  Locale get locale => loadLanguageisMyanmar() ? Locale("my","MM") : Locale("en","US");

  changeLanguage(){
    if(box.read(TxtConstant.language) == null || box.read(TxtConstant.language) == false){
      box.write(TxtConstant.language, true);
      Get.updateLocale(locale);
    }else{
      box.write(TxtConstant.language, false);
      Get.updateLocale(locale);
    }
  }

}


class LanguageKeyStrings extends Translations{


  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    "en_US": {
      "dashboard": "Dashboard",
      "currentorder": "Current Order",
      "schedule": "Schedule",
      "checkin": "Check In",
      "checkout": "Check Out",
      'cashcollected': "Cash Collected",
      "mmk": "MMK",
      "profile": "Profile",
      "credit": "Credit",
      "misc": "MISC",
      "punishment": "Punishment",
      "order": "Order",
      "history": "History",
      "clearance": "Clearance",
      "statement": "Statement",
      "rules" : "Rules",
      "promotion" : "Promotion",
      "notifications" : "Notifications",
      "capturepaymentdocument": "Capture Payment Document",
      "phone": "Phone",
      "level" : "Level",
      "zone": "Zone",
      "area": "Area",
      "enteryourname" : "Enter your name",
      "enteryournrc": "Enter your NRC",
      "enteryourgmail": "Enter your gmail",
      "upload" : "Upload",
      "update" : "Update",
      "next" : "Next",
      "available" : "Available",
      "settings" : "Settings",
      "changetodarkmode" : "Change to Dark Mode",
      "changetomyanmarlanguage" : "Change to Myanmar Language",
      "ok": "OK",
      "success" : "Success",
      "checkinsuccess" : "Check-In successfully",
      "fail" : "Failed",
      "checkinfail": "There is no item to Check-In",
      "checkoutsuccess": "Check-Out successfully",
      "checkoutfail": "Check-Out is denied",
      "orderaccept": "Order accept",
      "thankforacceptorder": "Thanks for accept Orders",
      "orderacceptfail": "Order Accept Failed",
      "ordercannotaccept": "Order cannot be accepted",
      "bikerupdatesuccess": "Biker update Success",
      "bikerupdatefail": "Biker update Failed. Please try again later.",
      "image" : "Image",
      "imagerequireprocess" : 'Image is required to processed',
      "invalid" : "Invalid",
      "checkinput" : "Please check input value again.",
      "otpcodewrong" : "Wrong OTP code",
      "checksmsagain" : "Your OTP code is incorrected. Please check the SMS again.",
      "earn": "Earn",
      "youearn" : 'You Earn',
      "neworder": "New Order",
      "accept" : "Accept",
      "ruleandregulation": "Rules and Regulations",
      "qrscan": "QR Scan",
      "shops" : "Shops",
      "confirm" : "Confirm",
      "nopunishment": "There is no punishment for this biker.",
      "noorderhistory": "There is no item in order history.",
      "dropoffsummary" : "Drop-off Summary",
      "dropoff" : "Drop-off",
      "ordersummary" : "Order Summary",
      "ordertotal" : "Order Total",
      "deliverycharges" : "Delivery Charges",
      "vat" : "VAT",
      // "paymentoptions" : "Payment Options",
      "useEsignandconfirmorder": "Please use E-sign and confirm order",
      "cancel": "Cancel",
      "transfertoother" : "Transfer to Others",
      "ref": "Ref-No",
      "viewmap": "View Map",
      "logout" : "Logout",
      "wanttologout": "Are you sure want to Logout?",
      "no" : "No",
      "yes": "Yes",
      "checkoutschedule": "Check-Out Schedule?",
      "bothcheckoutandlogout": "If you Logout, Check-In schedules will automatically be checked out.",
      "detail": "Detail",
      "date" : "Date",
      "totalorderqty": "Total Order Qty",
      "totaldistance" : "Total Distance",
      "total" : "Total",
      "usage" : "Usage",
      "payment" : "Payment",
      "noclearanceitem" : "There is no Item in clearance",
      "cashondelivery": "Cash-on Delivery",
      "km" :"Km",
      "clearsign" : "Clear Sign",
      "cusinfo" : "Customer Info",
      "note" : "Note",
      "pickup" : "Pick Up",
      "nonoti" : "There is no Notifications",
      "wanttocheckout" : "Are you sure to check out",
      "nocuritem" : "There is no Current Item",
      "nocheckinschedule" : "There is no Check-In Schedule",
      "noavailableschedule" : "There is no Available Schedule",
      "cusmap": "Customer Map",
      "askhelp" : "Ask for Help",
      "call": "Call",
      "amount" : "Amount",
      "clicktocheckout": "Please click to Check-out",
      "shopinfo" : "Shop Info",
      "finalconfirmtitle" : "Order Delivery finished!",
      "finalconfirmtext" : "Thank you for your order",
    },
    "my_MM": {
      "dashboard": "အားလုံး",
      "currentorder": "လက်ရှိအော်ဒါ",
      "schedule": "အချိန်ဇယား",
      "checkin": "ရောက်ရှိ",
      "checkout": "ထွက်ခွာ",
      'cashcollected': "စုဆောင်းငွေ",
      "mmk": "ကျပ်",
      "profile": "ကိုယ်ရေး",
      "credit": "အကြွေး",
      "misc": "အသေးသုံး",
      "punishment": "ပြစ်ဒဏ်",
      "order": "အော်ဒါ",
      "history": "ဟောင်း",
      "clearance": "ရှင်းလင်း",
      "statement": "ရှင်းတမ်း",
      "rules" : "စည်းကမ်းများ",
      "promotion" : "Promotion",
      "notifications" : "Notifications",
      "capturepaymentdocument": "ဓာတ်ပုံရိုက်မည်",
      "phone": "ဖုန်း",
      "level" : "အဆင့်",
      "zone": "ဇုန်",
      "area": "ဧရိယာ",
      "enteryourname" : "သင့် အမည်ကို ထည့်ပါ",
      "enteryournrc": "သင့် မှတ်ပုံတင်ကို ထည့်ပါ",
      "enteryourgmail": "သင့် gmail ကိုထည့်ပါ",
      "upload" : "ပုံတင်",
      "update" : "မွမ်းမံမည်",
      "next" : "နောက်",
      "available" : "ရရှိနိုင်သော",
      "settings" : "ကိရိယာများ",
      "changetodarkmode" : "Dark mode သို့ပြောင်းမည်",
      "changetomyanmarlanguage" : "မြန်မာဘာသာ သို့ပြောင်းမည်",
      "ok": "အိုကေ",
      "success" : "အောင်မြင်သည်",
      "checkinsuccess" : "ရောက်ရှိကြောင်းစာရင်းသွင်းခြင်း အောင်မြင်သည်",
      "fail" : "မအောင်မြင်ပါ",
      "checkinfail": "ရောက်ရှိကြောင်းစာရင်းသွင်း၍မရပါ",
      "checkoutsuccess": "ထွက်ခွာကြောင်းစာရင်းသွင်းခြင်း အောင်မြင်သည်",
      "checkoutfail": "ထွက်ခွာကြောင်းစာရင်းသွင်း၍မရပါ",
      "orderaccept": "အော်ဒါ လက်ခံ",
      "thankforacceptorder": "အော်ဒါလက်ခံ၍ အထူးကျေးဇူးတင်ပါသည်",
      "orderacceptfail": "အော်ဒါလက်ခံခြင်း မအောင်မြင်ပါ",
      "ordercannotaccept": "အော်ဒါလက်ခံ၍ မရပါ",
      "bikerupdatesuccess": "Biker မွမ်းမံခြင်းအောင်မြင်သည်",
      "bikerupdatefail": "Biker မွမ်းမံခြင်း မအောင်မြင်ပါ။ နောက်မှ ထပ်မံ၍ကြိုးစားပါ။",
      "image" : "ပုံ",
      "imagerequireprocess" : 'ဆက်လက်လုပ်ဆောင်ရန် ပုံလိုအပ်သည်',
      "invalid" : "မမှန်ကန်ပါ",
      "checkinput" : "သင်ရိုက်ထားသောစာအား ပြန်လည် စစ်ဆေးပါ",
      "otpcodewrong" : "OTP ကုတ် မမှန်ပါ",
      "checksmsagain" : "OTP ကုတ်မှား‌နေပါသည်။ SMS ကိုပြန်လည် စစ်ဆေးပါ",
      "earn": "ရသင့်ငွေ",
      "youearn" : 'သင့်၏ရသင့်ငွေ',
      "neworder": "အော်ဒါအသစ်",
      "accept" : "လက်ခံသည်",
      "ruleandregulation": "စည်းမျဉ်းစည်းကမ်းများ",
      "qrscan": "QR Scan",
      "shops" : "ဆိုင်များ",
      "confirm" : "အတည်ပြု",
      "nopunishment": "ဒီ biker အတွက်ပြစ်ဒဏ် မရှိပါ",
      "noorderhistory": "အော်ဒါအဟောင်းမရှိပါ",
      "dropoffsummary" : "ပစ္စည်းနှင့်ငွေစာရင်း အကျဉ်းချုပ်",
      "dropoff" : "‌ပစ္စည်း ချမည်",
      "ordersummary" : "အော်ဒါအကျဉ်းချုပ်",
      "ordertotal" : "အော်ဒါအားလုံး",
      "deliverycharges" : "ပို့ဆောင်ခ",
      "vat" : "အခွန်",
      // "paymentoptions" : "Payment Options",
      "useEsignandconfirmorder": "လက်မှတ်ထိုး၍ အော်ဒါ အတည်ပြုပါ",
      "cancel": "နောက်ဆုတ်မည်",
      "transfertoother" : "အခြားသူသို့ လွှဲမည်",
      "ref": "Ref-No",
      "viewmap": "မြေပုံကြည့်မည်",
      "logout" : "ထွက်မည်",
      "wanttologout": "သင်ထွက်မှာသေချာပါသလား?",
      "no" : "မဟုတ်ပါ",
      "yes": "ဟုတ်ကဲ့",
      "checkoutschedule": "အချိန်စာရင်း ထွက်မှာလား?",
      "bothcheckoutandlogout": "သင် ယခု ထွက်မည်ဆိုပါက ရောက်ရှိအချိန်စာရင်းများ အလိုအလျောက်ထွက်သွားမည်",
      "detail": "အသေးစိတ်",
      "date" : "နေ့စွဲ",
      "totalorderqty": "အော်ဒါအားလုံးပေါင်း ",
      "totaldistance" : "အကွာအဝေး",
      "total" : "စုစုပေါင်း",
      "usage" : "အသုံးပြုမှု",
      "payment" : "ငွေပေးချေမှု",
      "noclearanceitem" : "စာရင်းရှင်းလင်းမှု မရှိပါ",
      "cashondelivery": "Deli သို့ငွေပေးချေမည်",
      "km": "ကီလိုမီတာ",
      "clearsign" : "လတ်မှတ်ဖျက်မည်",
      "cusinfo" : "ဝယ်သူအချက်အလက်",
      "note" : "မှတ်ချက်",
      "pickup" : "ယူမည်",
      "nonoti" : "Notificaiton မရှိပါ",
      "wanttocheckout" : "သင်အချိန်စာရင်းမှ ထွက်ခွာမှာသေချာပါသလား",
      "nocuritem" : "လက်ရှိပစ္စည်း မရှိပါ",
      "nocheckinschedule" : "ရောက်ရှိအချိန်ဇယား မရှိပါ",
      "noavailableschedule" : "ရရှိနိုင်သောအချိန်ဇယား မရှိပါ",
      "cusmap": "ဝယ်သူ၏ မြေပုံ",
      "askhelp" : "အကူအညီတောင်းမည်",
      "call": "ဖုန်းခေါ်မည်",
      "amount" : "ပမာဏ",
      "clicktocheckout": "ကျေးဇူးပြု၍ ထွက်ခွာရန်နှိပ်ပါ",
      "shopinfo" : "ဆိုင်အချက်အလက်",
      "finalconfirmtitle" : "အော်ဒါပို့ဆောင်ခြင်းပြီးဆုံးသည်!",
      "finalconfirmtext" : "သင်၏အော်ဒါမှာယူခြင်းအတွက်ကျေးဇူးတင်ပါသည်",
    },
  };
}