import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import '../backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/auth_util.dart';

String getModelMeasuresStr(UsersRecord userRecord) {
  // concatenate bust waist hips
  final modelMeasureBust = userRecord.modelMeasureBust;
  final modelMeasureWaist = userRecord.modelMeasureWaist;
  final modelMeasureHips = userRecord.modelMeasureHips;
  final modelHeightcm = userRecord.modelHeightCm;
  final modelHeightft = cm2ftStr(userRecord.modelHeightCm);
  return '$modelHeightft B: $modelMeasureBust W: $modelMeasureWaist H: $modelMeasureHips';
}

double validateRangeDbl(
  double min,
  double max,
  double def,
  double value,
) {
  // check value is between min and max, if not, return default value
  return max >= value && value >= min ? value : def;
}

String cm2ftStr(double cm) {
  // centimeters to feet and inches
  double cms = 0;
  if (cm == null) {
    return '0\' 0"';
  } else {
    cms = cm;
  }
  double feet = cms / 30.48;
  double inches = feet % 1;
  feet = feet - inches;

  inches = inches * 12;
  return '${feet.toStringAsFixed(0)}" ${inches.toStringAsFixed(0)}`';
}

List<String> getCountries() {
  var countries = [
    "id,name,latitude,longitude,emoji",
    "1,Afghanistan,33.00000000,65.00000000,🇦🇫",
    "2,Aland Islands,60.11666700,19.90000000,🇦🇽",
    "3,Albania,41.00000000,20.00000000,🇦🇱",
    "4,Algeria,28.00000000,3.00000000,🇩🇿",
    "5,American Samoa,-14.33333333,-170.00000000,🇦🇸",
    "6,Andorra,42.50000000,1.50000000,🇦🇩",
    "7,Angola,-12.50000000,18.50000000,🇦🇴",
    "8,Anguilla,18.25000000,-63.16666666,🇦🇮",
    "9,Antarctica,-74.65000000,4.48000000,🇦🇶",
    "10,Antigua And Barbuda,17.05000000,-61.80000000,🇦🇬",
    "11,Argentina,-34.00000000,-64.00000000,🇦🇷",
    "12,Armenia,40.00000000,45.00000000,🇦🇲",
    "13,Aruba,12.50000000,-69.96666666,🇦🇼",
    "14,Australia,-27.00000000,133.00000000,🇦🇺",
    "15,Austria,47.33333333,13.33333333,🇦🇹",
    "16,Azerbaijan,40.50000000,47.50000000,🇦🇿",
    "17,Bahamas The,24.25000000,-76.00000000,🇧🇸",
    "18,Bahrain,26.00000000,50.55000000,🇧🇭",
    "19,Bangladesh,24.00000000,90.00000000,🇧🇩",
    "20,Barbados,13.16666666,-59.53333333,🇧🇧",
    "21,Belarus,53.00000000,28.00000000,🇧🇾",
    "22,Belgium,50.83333333,4.00000000,🇧🇪",
    "23,Belize,17.25000000,-88.75000000,🇧🇿",
    "24,Benin,9.50000000,2.25000000,🇧🇯",
    "25,Bermuda,32.33333333,-64.75000000,🇧🇲",
    "26,Bhutan,27.50000000,90.50000000,🇧🇹",
    "27,Bolivia,-17.00000000,-65.00000000,🇧🇴",
    "155,Bonaire, Sint Eustatius and Saba,12.15000000,-68.26666700,🇧🇶",
    "28,Bosnia and Herzegovina,44.00000000,18.00000000,🇧🇦",
    "29,Botswana,-22.00000000,24.00000000,🇧🇼",
    "30,Bouvet Island,-54.43333333,3.40000000,🇧🇻",
    "31,Brazil,-10.00000000,-55.00000000,🇧🇷",
    "32,British Indian Ocean Territory,-6.00000000,71.50000000,🇮🇴",
    "33,Brunei,4.50000000,114.66666666,🇧🇳",
    "34,Bulgaria,43.00000000,25.00000000,🇧🇬",
    "35,Burkina Faso,13.00000000,-2.00000000,🇧🇫",
    "36,Burundi,-3.50000000,30.00000000,🇧🇮",
    "37,Cambodia,13.00000000,105.00000000,🇰🇭",
    "38,Cameroon,6.00000000,12.00000000,🇨🇲",
    "39,Canada,60.00000000,-95.00000000,🇨🇦",
    "40,Cape Verde,16.00000000,-24.00000000,🇨🇻",
    "41,Cayman Islands,19.50000000,-80.50000000,🇰🇾",
    "42,Central African Republic,7.00000000,21.00000000,🇨🇫",
    "43,Chad,15.00000000,19.00000000,🇹🇩",
    "44,Chile,-30.00000000,-71.00000000,🇨🇱",
    "45,China,35.00000000,105.00000000,🇨🇳",
    "46,Christmas Island,-10.50000000,105.66666666,🇨🇽",
    "47,Cocos (Keeling) Islands,-12.50000000,96.83333333,🇨🇨",
    "48,Colombia,4.00000000,-72.00000000,🇨🇴",
    "49,Comoros,-12.16666666,44.25000000,🇰🇲",
    "50,Congo,-1.00000000,15.00000000,🇨🇬",
    "52,Cook Islands,-21.23333333,-159.76666666,🇨🇰",
    "53,Costa Rica,10.00000000,-84.00000000,🇨🇷",
    "54,Cote D'Ivoire (Ivory Coast),8.00000000,-5.00000000,🇨🇮",
    "55,Croatia,45.16666666,15.50000000,🇭🇷",
    "56,Cuba,21.50000000,-80.00000000,🇨🇺",
    "249,Curaçao,12.11666700,-68.93333300,🇨🇼",
    "57,Cyprus,35.00000000,33.00000000,🇨🇾",
    "58,Czech Republic,49.75000000,15.50000000,🇨🇿",
    "51,Democratic Republic of the Congo,0.00000000,25.00000000,🇨🇩",
    "59,Denmark,56.00000000,10.00000000,🇩🇰",
    "60,Djibouti,11.50000000,43.00000000,🇩🇯",
    "61,Dominica,15.41666666,-61.33333333,🇩🇲",
    "62,Dominican Republic,19.00000000,-70.66666666,🇩🇴",
    "63,East Timor,-8.83333333,125.91666666,🇹🇱",
    "64,Ecuador,-2.00000000,-77.50000000,🇪🇨",
    "65,Egypt,27.00000000,30.00000000,🇪🇬",
    "66,El Salvador,13.83333333,-88.91666666,🇸🇻",
    "67,Equatorial Guinea,2.00000000,10.00000000,🇬🇶",
    "68,Eritrea,15.00000000,39.00000000,🇪🇷",
    "69,Estonia,59.00000000,26.00000000,🇪🇪",
    "70,Ethiopia,8.00000000,38.00000000,🇪🇹",
    "71,Falkland Islands,-51.75000000,-59.00000000,🇫🇰",
    "72,Faroe Islands,62.00000000,-7.00000000,🇫🇴",
    "73,Fiji Islands,-18.00000000,175.00000000,🇫🇯",
    "74,Finland,64.00000000,26.00000000,🇫🇮",
    "75,France,46.00000000,2.00000000,🇫🇷",
    "76,French Guiana,4.00000000,-53.00000000,🇬🇫",
    "77,French Polynesia,-15.00000000,-140.00000000,🇵🇫",
    "78,French Southern Territories,-49.25000000,69.16700000,🇹🇫",
    "79,Gabon,-1.00000000,11.75000000,🇬🇦",
    "80,Gambia The,13.46666666,-16.56666666,🇬🇲",
    "81,Georgia,42.00000000,43.50000000,🇬🇪",
    "82,Germany,51.00000000,9.00000000,🇩🇪",
    "83,Ghana,8.00000000,-2.00000000,🇬🇭",
    "84,Gibraltar,36.13333333,-5.35000000,🇬🇮",
    "85,Greece,39.00000000,22.00000000,🇬🇷",
    "86,Greenland,72.00000000,-40.00000000,🇬🇱",
    "87,Grenada,12.11666666,-61.66666666,🇬🇩",
    "88,Guadeloupe,16.25000000,-61.58333300,🇬🇵",
    "89,Guam,13.46666666,144.78333333,🇬🇺",
    "90,Guatemala,15.50000000,-90.25000000,🇬🇹",
    "91,Guernsey and Alderney,49.46666666,-2.58333333,🇬🇬",
    "92,Guinea,11.00000000,-10.00000000,🇬🇳",
    "93,Guinea-Bissau,12.00000000,-15.00000000,🇬🇼",
    "94,Guyana,5.00000000,-59.00000000,🇬🇾",
    "95,Haiti,19.00000000,-72.41666666,🇭🇹",
    "96,Heard Island and McDonald Islands,-53.10000000,72.51666666,🇭🇲",
    "97,Honduras,15.00000000,-86.50000000,🇭🇳",
    "98,Hong Kong S.A.R.,22.25000000,114.16666666,🇭🇰",
    "99,Hungary,47.00000000,20.00000000,🇭🇺",
    "100,Iceland,65.00000000,-18.00000000,🇮🇸",
    "101,India,20.00000000,77.00000000,🇮🇳",
    "102,Indonesia,-5.00000000,120.00000000,🇮🇩",
    "103,Iran,32.00000000,53.00000000,🇮🇷",
    "104,Iraq,33.00000000,44.00000000,🇮🇶",
    "105,Ireland,53.00000000,-8.00000000,🇮🇪",
    "106,Israel,31.50000000,34.75000000,🇮🇱",
    "107,Italy,42.83333333,12.83333333,🇮🇹",
    "108,Jamaica,18.25000000,-77.50000000,🇯🇲",
    "109,Japan,36.00000000,138.00000000,🇯🇵",
    "110,Jersey,49.25000000,-2.16666666,🇯🇪",
    "111,Jordan,31.00000000,36.00000000,🇯🇴",
    "112,Kazakhstan,48.00000000,68.00000000,🇰🇿",
    "113,Kenya,1.00000000,38.00000000,🇰🇪",
    "114,Kiribati,1.41666666,173.00000000,🇰🇮",
    "248,Kosovo,42.56129090,20.34030350,🇽🇰",
    "117,Kuwait,29.50000000,45.75000000,🇰🇼",
    "118,Kyrgyzstan,41.00000000,75.00000000,🇰🇬",
    "119,Laos,18.00000000,105.00000000,🇱🇦",
    "120,Latvia,57.00000000,25.00000000,🇱🇻",
    "121,Lebanon,33.83333333,35.83333333,🇱🇧",
    "122,Lesotho,-29.50000000,28.50000000,🇱🇸",
    "123,Liberia,6.50000000,-9.50000000,🇱🇷",
    "124,Libya,25.00000000,17.00000000,🇱🇾",
    "125,Liechtenstein,47.26666666,9.53333333,🇱🇮",
    "126,Lithuania,56.00000000,24.00000000,🇱🇹",
    "127,Luxembourg,49.75000000,6.16666666,🇱🇺",
    "128,Macau S.A.R.,22.16666666,113.55000000,🇲🇴",
    "129,Macedonia,41.83333333,22.00000000,🇲🇰",
    "130,Madagascar,-20.00000000,47.00000000,🇲🇬",
    "131,Malawi,-13.50000000,34.00000000,🇲🇼",
    "132,Malaysia,2.50000000,112.50000000,🇲🇾",
    "133,Maldives,3.25000000,73.00000000,🇲🇻",
    "134,Mali,17.00000000,-4.00000000,🇲🇱",
    "135,Malta,35.83333333,14.58333333,🇲🇹",
    "136,Man (Isle of),54.25000000,-4.50000000,🇮🇲",
    "137,Marshall Islands,9.00000000,168.00000000,🇲🇭",
    "138,Martinique,14.66666700,-61.00000000,🇲🇶",
    "139,Mauritania,20.00000000,-12.00000000,🇲🇷",
    "140,Mauritius,-20.28333333,57.55000000,🇲🇺",
    "141,Mayotte,-12.83333333,45.16666666,🇾🇹",
    "142,Mexico,23.00000000,-102.00000000,🇲🇽",
    "143,Micronesia,6.91666666,158.25000000,🇫🇲",
    "144,Moldova,47.00000000,29.00000000,🇲🇩",
    "145,Monaco,43.73333333,7.40000000,🇲🇨",
    "146,Mongolia,46.00000000,105.00000000,🇲🇳",
    "147,Montenegro,42.50000000,19.30000000,🇲🇪",
    "148,Montserrat,16.75000000,-62.20000000,🇲🇸",
    "149,Morocco,32.00000000,-5.00000000,🇲🇦",
    "150,Mozambique,-18.25000000,35.00000000,🇲🇿",
    "151,Myanmar,22.00000000,98.00000000,🇲🇲",
    "152,Namibia,-22.00000000,17.00000000,🇳🇦",
    "153,Nauru,-0.53333333,166.91666666,🇳🇷",
    "154,Nepal,28.00000000,84.00000000,🇳🇵",
    "156,Netherlands,52.50000000,5.75000000,🇳🇱",
    "157,New Caledonia,-21.50000000,165.50000000,🇳🇨",
    "158,New Zealand,-41.00000000,174.00000000,🇳🇿",
    "159,Nicaragua,13.00000000,-85.00000000,🇳🇮",
    "160,Niger,16.00000000,8.00000000,🇳🇪",
    "161,Nigeria,10.00000000,8.00000000,🇳🇬",
    "162,Niue,-19.03333333,-169.86666666,🇳🇺",
    "163,Norfolk Island,-29.03333333,167.95000000,🇳🇫",
    "115,North Korea,40.00000000,127.00000000,🇰🇵",
    "164,Northern Mariana Islands,15.20000000,145.75000000,🇲🇵",
    "165,Norway,62.00000000,10.00000000,🇳🇴",
    "166,Oman,21.00000000,57.00000000,🇴🇲",
    "167,Pakistan,30.00000000,70.00000000,🇵🇰",
    "168,Palau,7.50000000,134.50000000,🇵🇼",
    "169,Palestinian Territory Occupied,31.90000000,35.20000000,🇵🇸",
    "170,Panama,9.00000000,-80.00000000,🇵🇦",
    "171,Papua new Guinea,-6.00000000,147.00000000,🇵🇬",
    "172,Paraguay,-23.00000000,-58.00000000,🇵🇾",
    "173,Peru,-10.00000000,-76.00000000,🇵🇪",
    "174,Philippines,13.00000000,122.00000000,🇵🇭",
    "175,Pitcairn Island,-25.06666666,-130.10000000,🇵🇳",
    "176,Poland,52.00000000,20.00000000,🇵🇱",
    "177,Portugal,39.50000000,-8.00000000,🇵🇹",
    "178,Puerto Rico,18.25000000,-66.50000000,🇵🇷",
    "179,Qatar,25.50000000,51.25000000,🇶🇦",
    "180,Reunion,-21.15000000,55.50000000,🇷🇪",
    "181,Romania,46.00000000,25.00000000,🇷🇴",
    "182,Russia,60.00000000,100.00000000,🇷🇺",
    "183,Rwanda,-2.00000000,30.00000000,🇷🇼",
    "184,Saint Helena,-15.95000000,-5.70000000,🇸🇭",
    "185,Saint Kitts And Nevis,17.33333333,-62.75000000,🇰🇳",
    "186,Saint Lucia,13.88333333,-60.96666666,🇱🇨",
    "187,Saint Pierre and Miquelon,46.83333333,-56.33333333,🇵🇲",
    "188,Saint Vincent And The Grenadines,13.25000000,-61.20000000,🇻🇨",
    "189,Saint-Barthelemy,18.50000000,-63.41666666,🇧🇱",
    "190,Saint-Martin (French part),18.08333333,-63.95000000,🇲🇫",
    "191,Samoa,-13.58333333,-172.33333333,🇼🇸",
    "192,San Marino,43.76666666,12.41666666,🇸🇲",
    "193,Sao Tome and Principe,1.00000000,7.00000000,🇸🇹",
    "194,Saudi Arabia,25.00000000,45.00000000,🇸🇦",
    "195,Senegal,14.00000000,-14.00000000,🇸🇳",
    "196,Serbia,44.00000000,21.00000000,🇷🇸",
    "197,Seychelles,-4.58333333,55.66666666,🇸🇨",
    "198,Sierra Leone,8.50000000,-11.50000000,🇸🇱",
    "199,Singapore,1.36666666,103.80000000,🇸🇬",
    "250,Sint Maarten (Dutch part),18.03333300,-63.05000000,🇸🇽",
    "200,Slovakia,48.66666666,19.50000000,🇸🇰",
    "201,Slovenia,46.11666666,14.81666666,🇸🇮",
    "202,Solomon Islands,-8.00000000,159.00000000,🇸🇧",
    "203,Somalia,10.00000000,49.00000000,🇸🇴",
    "204,South Africa,-29.00000000,24.00000000,🇿🇦",
    "205,South Georgia,-54.50000000,-37.00000000,🇬🇸",
    "116,South Korea,37.00000000,127.50000000,🇰🇷",
    "206,South Sudan,7.00000000,30.00000000,🇸🇸",
    "207,Spain,40.00000000,-4.00000000,🇪🇸",
    "208,Sri Lanka,7.00000000,81.00000000,🇱🇰",
    "209,Sudan,15.00000000,30.00000000,🇸🇩",
    "210,Suriname,4.00000000,-56.00000000,🇸🇷",
    "211,Svalbard And Jan Mayen Islands,78.00000000,20.00000000,🇸🇯",
    "212,Swaziland,-26.50000000,31.50000000,🇸🇿",
    "213,Sweden,62.00000000,15.00000000,🇸🇪",
    "214,Switzerland,47.00000000,8.00000000,🇨🇭",
    "215,Syria,35.00000000,38.00000000,🇸🇾",
    "216,Taiwan,23.50000000,121.00000000,🇹🇼",
    "217,Tajikistan,39.00000000,71.00000000,🇹🇯",
    "218,Tanzania,-6.00000000,35.00000000,🇹🇿",
    "219,Thailand,15.00000000,100.00000000,🇹🇭",
    "220,Togo,8.00000000,1.16666666,🇹🇬",
    "221,Tokelau,-9.00000000,-172.00000000,🇹🇰",
    "222,Tonga,-20.00000000,-175.00000000,🇹🇴",
    "223,Trinidad And Tobago,11.00000000,-61.00000000,🇹🇹",
    "224,Tunisia,34.00000000,9.00000000,🇹🇳",
    "225,Turkey,39.00000000,35.00000000,🇹🇷",
    "226,Turkmenistan,40.00000000,60.00000000,🇹🇲",
    "227,Turks And Caicos Islands,21.75000000,-71.58333333,🇹🇨",
    "228,Tuvalu,-8.00000000,178.00000000,🇹🇻",
    "229,Uganda,1.00000000,32.00000000,🇺🇬",
    "230,Ukraine,49.00000000,32.00000000,🇺🇦",
    "231,United Arab Emirates,24.00000000,54.00000000,🇦🇪",
    "232,United Kingdom,54.00000000,-2.00000000,🇬🇧",
    "233,United States,38.00000000,-97.00000000,🇺🇸",
    "234,United States Minor Outlying Islands,0.00000000,0.00000000,🇺🇲",
    "235,Uruguay,-33.00000000,-56.00000000,🇺🇾",
    "236,Uzbekistan,41.00000000,64.00000000,🇺🇿",
    "237,Vanuatu,-16.00000000,167.00000000,🇻🇺",
    "238,Vatican City State (Holy See),41.90000000,12.45000000,🇻🇦",
    "239,Venezuela,8.00000000,-66.00000000,🇻🇪",
    "240,Vietnam,16.16666666,107.83333333,🇻🇳",
    "241,Virgin Islands (British),18.43138300,-64.62305000,🇻🇬",
    "242,Virgin Islands (US),18.34000000,-64.93000000,🇻🇮",
    "243,Wallis And Futuna Islands,-13.30000000,-176.20000000,🇼🇫",
    "244,Western Sahara,24.50000000,-13.00000000,🇪🇭",
    "245,Yemen,15.00000000,48.00000000,🇾🇪",
    "246,Zambia,-15.00000000,30.00000000,🇿🇲",
    "247,Zimbabwe,-20.00000000,30.00000000,🇿🇼",
  ];
  countries.removeAt(0); //remove column heading

  /*
  * you can use any parser for csv file,
  *
  * a csv package is available
  * or simple file reading will also get the job done main logic is coded here
  * */

  var list = <String>[];
  for (var line in countries) {
    list.add(line.split(',')[1] + " " + line.split(',')[4]);
  }
  return list;
}

List<String> getStates(String country) {
  var states = [
    'id,name,country_name,latitude,longitude',
    '3901,Badakhshan,Afghanistan,36.73477250,70.81199530',
    '3871,Badghis,Afghanistan,35.16713390,63.76953840',
    '3875,Baghlan,Afghanistan,36.17890260,68.74530640',
    '3884,Balkh,Afghanistan,36.75506030,66.89753720',
    '603,Berat County,Albania,40.69530120,20.04496620',
    '629,Berat District,Albania,40.70863770,19.94373140',
    '607,Bulqizë District,Albania,41.49425870,20.21471570',
  ];
  states.removeAt(0); //remove column heading

  /*
  * you can use any parser for csv file,
  *
  * a csv package is available
  * or simple file reading will also get the job done main logic is coded here
  * */

  var list = <String>[];
  for (var line in states) {
    var state = <String>[];
    state = line.split(',');
    if (state[3] == country) {
      list.add(state[1]);
    }
  }
  return list;
}

int countListItems(List<DocumentReference> list) {
  // Add your function code here!
  return list.length;
}
