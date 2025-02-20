import 'package:momona_healthcare/model/patient_bill_model.dart';
import 'package:momona_healthcare/network/network_utils.dart';

Future<PatientBillModule> getBillDetails({int? encounterId}) async {
  return PatientBillModule.fromJson(await (handleResponse(await buildHttpResponse('kivicare/api/v1/bill/bill-details?encounter_id=$encounterId'))));
}

Future addPatientBill(Map request) async {
  return await handleResponse(await buildHttpResponse('kivicare/api/v1/bill/add-bill', request: request, method: HttpMethod.POST));
}
