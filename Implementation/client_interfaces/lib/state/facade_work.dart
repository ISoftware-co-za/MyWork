import 'package:client_interfaces1/state/state_work.dart';
import '../service/work.dart';
import 'facade_base.dart';
import 'response_process.dart';

class FacadeWork extends FacadeBase {

  //#region CONSTRUCTION

  FacadeWork(super.serviceClient);

  //#endregion

  //#region METHODS

  List<StateWork> list({required int pageNumber, String? name, List<String>? types, String? reference, bool? archived}) {
    return [
      StateWork(name: 'Work 1', reference: 'REF-001', description: 'Description 1', type: 'Type 1'),
      StateWork(name: 'Work 2', reference: 'REF-002', description: 'Description 2', type: 'Type 2'),
      StateWork(name: 'Work 3', reference: 'REF-003', description: 'Description 3', type: 'Type 3'),
    ];
  }

  Future<StateWork> define({required StateWork item}) async {
    var request = WorkCreateRequest(name: item.name.value!, type: item.type.value, reference: item.reference.value, description: item.description.value);
    var response = await serviceClient.workCreate(request);
    var responseProcess = ResponseProcessFactory.createWorkProcessResponse(response, item);
    responseProcess?.process();
    return item;
  }

  Future update({required StateWork item}) async {
    var updatedProperties = <WorkUpdatedProperty>[];
    if (item.name.isChanged) {
      updatedProperties.add(WorkUpdatedProperty(name: 'Name', value: item.name.value));
    }
    if (item.type.isChanged) {
      updatedProperties.add(WorkUpdatedProperty(name: 'Type', value: item.type.value));
    }
    if (item.reference.isChanged) {
      updatedProperties.add(WorkUpdatedProperty(name: 'Reference', value: item.reference.value));
    }
    if (item.description.isChanged) {
      updatedProperties.add(WorkUpdatedProperty(name: 'Description', value: item.description.value));
    }
    var request = WorkUpdateRequest(id: item.id!, updatedProperties:  updatedProperties);
    var response = await serviceClient.workUpdate(request);
    var responseProcess = ResponseProcessFactory.createWorkProcessResponse(response, item);
    responseProcess?.process();
  }

  Future delete({required StateWork item}) async {
    var response = await serviceClient.workDelete(item.id!);
  }

  //#endregion
}