import 'package:momona_healthcare/model/base_response.dart';
import 'package:momona_healthcare/model/holiday_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';

//Start Holidays API

Future<HolidayModel> getHolidayResponse() async {
  return HolidayModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/setting/clinic-schedule-list'))));
}

Future<BaseResponses> addHolidayData(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/save-clinic-schedule', request: request, method: HttpMethod.POST)));
}

Future<BaseResponses> deleteHolidayData(Map request) async {
  return BaseResponses.fromJson(await handleResponse(await buildHttpResponse('kivicare/api/v1/setting/delete-clinic-schedule', request: request, method: HttpMethod.POST)));
}

//End Holidays API
