import 'package:client_interfaces1/model/model_property.dart';
import 'package:client_interfaces1/model/model_property_change_context.dart';
import 'package:get_it/get_it.dart';
import '../service/work/service_client_work.dart';
import 'data_conversion.dart';
import 'work.dart';

class WorkList extends ContextOwner{

  List<Work> workItems = [];

  WorkList(ModelPropertyChangeContext super.context);

  Future obtain() async {
    var response = await _serviceClient.listAll();
    workItems = response.items
        .map((e) => Work(
            context: context,
            id: e.id,
            name: e.name,
            reference: DataConversionServiceToModel.nullToEmptyString(e.reference),
            type: DataConversionServiceToModel.nullToEmptyString(e.type),
            archived: e.archived))
        .toList();
    _isObtained = true;
  }

  void add(Work work) {
    assert(_isObtained, 'The list of work has not been obtained. Please call obtain before calling add.');
    workItems.add(work);
  }

  void delete(Work item) {
    assert(_isObtained, 'The list of work has not been obtained. Please call obtain before calling delete.');
    workItems.remove(item);
  }

  final ServiceClientWork _serviceClient = GetIt.instance<ServiceClientWork>();
  bool _isObtained = false;
}
