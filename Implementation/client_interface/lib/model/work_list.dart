import 'package:client_interfaces1/model/model_property_change_context.dart';
import 'package:get_it/get_it.dart';
import '../service/work/service_client_work.dart';
import 'data_conversion.dart';
import 'work.dart';

class WorkList {

  List<Work> workItems = [];
  bool isObtained = false;

  WorkList(ModelPropertyChangeContext context) : _context = context;

  Future obtain() async {
    var response = await _serviceClient.listAll();
    workItems = response.items
        .map((e) => Work(
            context: _context,
            id: e.id,
            name: e.name,
            reference: DataConversionServiceToModel.nullToEmptyString(e.reference),
            type: DataConversionServiceToModel.nullToEmptyString(e.type),
            archived: e.archived))
        .toList();
    isObtained = true;
  }

  void add(Work work) {
    assert(isObtained, 'The list of work has not been obtained. Please call obtain before calling add.');
    workItems.add(work);
  }

  void delete(Work item) {
    workItems.remove(item);
  }

  final ModelPropertyChangeContext _context;
  final ServiceClientWork _serviceClient = GetIt.instance<ServiceClientWork>();
}
