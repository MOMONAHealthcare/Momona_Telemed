import 'package:momona_healthcare/model/telemed_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';

//Telemed

Future addTelemedServices(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/save-zoom-configuration', request: request, method: HttpMethod.POST));
}

Future<TelemedModel> getTelemedServices() async {
  return TelemedModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/doctor/get-zoom-configuration'))));
}

//End Telemed
