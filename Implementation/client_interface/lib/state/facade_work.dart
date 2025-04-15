import 'package:client_interfaces1/state/state_work.dart';
import '../service/work/service_client_work.dart';
import 'facade_base.dart';
import 'response_process.dart';

class FacadeWork extends FacadeBase {
  //#region CONSTRUCTION

  FacadeWork(this._serviceClient);

  //#endregion

  //#region METHODS

  Future<List<WorkSummary>> listAll() async {
    var response = await _serviceClient.listAll();
    return response.items
        .map((e) => WorkSummary(
            id: e.id,
            name: e.name,
            reference: nullToEmptyString(e.reference),
            type: nullToEmptyString(e.type),
            archived: e.archived))
        .toList();
  }

  Future<StateWork> define({required StateWork item}) async {
    var request = RequestCreateWork(
        name: item.name.value!,
        type: item.type.value,
        reference: item.reference.value,
        description: item.description.value);
    var response = await _serviceClient.create(request);
    var responseProcess =
        ResponseProcessFactory.createWorkProcessResponse(response, item);
    responseProcess?.process();
    return item;
  }

  Future update({required StateWork item}) async {
    var updatedProperties = <WorkUpdatedProperty>[];
    if (item.name.isChanged) {
      updatedProperties
          .add(WorkUpdatedProperty(name: 'Name', value: item.name.value));
    }
    if (item.type.isChanged) {
      updatedProperties
          .add(WorkUpdatedProperty(name: 'Type', value: item.type.value?.name));
    }
    if (item.reference.isChanged) {
      updatedProperties.add(
          WorkUpdatedProperty(name: 'Reference', value: item.reference.value));
    }
    if (item.description.isChanged) {
      updatedProperties.add(WorkUpdatedProperty(
          name: 'Description', value: item.description.value));
    }
    if (updatedProperties.isNotEmpty) {
      var request =
          RequestWorkUpdate(id: item.id!, updatedProperties: updatedProperties);
      var response = await _serviceClient.update(request);
      var responseProcess =
          ResponseProcessFactory.createWorkProcessResponse(response, item);
      responseProcess?.process();
    }
  }

  Future delete({required StateWork item}) async {
    await _serviceClient.delete(item.id!);
  }

  //#endregion

//# region FIELDS

  final ServiceClientWork _serviceClient;

//#endregion
}
