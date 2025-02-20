import 'package:momona_healthcare/model/doctor_dashboard_model.dart';
import 'package:momona_healthcare/model/encounter_dashboard_model.dart';
import 'package:momona_healthcare/model/patient_dashboard_model.dart';
import 'package:momona_healthcare/model/static_data_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';
import 'package:momona_healthcare/screens/patient/models/patient_encounter_dashboard_model.dart';

//Get APis

Future<DoctorDashboardModel> getDoctorDashBoard() async {
  return DoctorDashboardModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/user/get-dashboard?page=1&limit=5'))));
}

Future<PatientDashboardModel> getPatientDashBoard() async {
  return PatientDashboardModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/user/get-dashboard?page=1&limit=5'))));
}

Future<EncounterDashboardModel> getEncounterDetailsDashBoard(int id) async {
  return EncounterDashboardModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/get-encounter-detail?id=$id'))));
}

Future<PatientEncounterDashboardModel> getPatientEncounterDetailsDashBoard(int id) async {
  return PatientEncounterDashboardModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/encounter/get-encounter-detail?id=$id'))));
}

Future<StaticDataModel> getStaticDataResponse(String req) async {
  return StaticDataModel.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/staticdata/get-list?type=$req'))));
}
