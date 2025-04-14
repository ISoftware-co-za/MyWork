import 'dart:ui';

import 'package:client_interfaces1/dialog_work/controller_dialog_work.dart';
import 'package:client_interfaces1/execution/executor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../state/state_work.dart';
import '../state/work_type.dart';
import '../ui_toolkit/custom_icon_buttons.dart';
import 'table_columns.dart';

//----------------------------------------------------------------------------------------------------------------------

class LayoutWorkDialog extends StatelessWidget {
  const LayoutWorkDialog(
      {required ControllerDialogWork controller,
      required Iterable<WorkType> workTypes,
      super.key})
      : _controller = controller,
        _workTypes = workTypes;

  @override
  Widget build(BuildContext context) {
    WorkDialogTheme theme = Theme.of(context).extension<WorkDialogTheme>()!;
    return Dialog(
        alignment: Alignment.topLeft,
        child: Container(
            width: theme.width,
            height: theme.height,
            color: Colors.white,
            child: Column(children: [
              _LayoutDialogHeader(theme: theme),
              _LayoutTableHeader(
                  controller: _controller, workTypes: _workTypes, theme: theme),
              _LayoutTableBody(controller: _controller, theme: theme),
            ])));
  }

  final ControllerDialogWork _controller;
  final Iterable<WorkType> _workTypes;
}

//----------------------------------------------------------------------------------------------------------------------

class _LayoutDialogHeader extends StatelessWidget {
  const _LayoutDialogHeader({required WorkDialogTheme theme, super.key})
      : _theme = theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_theme.padding, _theme.padding,
          _theme.padding, _theme.verticalSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Work', style: _theme.headerTextStyle),
          SizedBox(width: _theme.horizontalSpacing),
          IconButtonAction(Icons.add,
              onPressed: () => debugPrint('Add work pressed')),
          const Spacer(),
          IconButtonAction(Icons.close, onPressed: () => Navigator.pop(context))
        ],
      ),
    );
  }

  final WorkDialogTheme _theme;
}

//----------------------------------------------------------------------------------------------------------------------

class _LayoutTableHeader extends StatelessWidget {
  _LayoutTableHeader(
      {required ControllerDialogWork controller,
      required Iterable<WorkType> workTypes,
      required WorkDialogTheme theme,
      super.key})
      : _controller = controller,
        _theme = theme {
    _workTypes = workTypes
        .map((item) =>
            TableColumnListItem(item.name, ValueNotifier<bool>(false)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = _createColumns();
    return Container(
      color: Color.fromARGB(255, 255, 240, 240),
      padding: EdgeInsets.symmetric(
          horizontal: _theme.padding, vertical: _theme.verticalSpacing),
      child: Row(children: columns),
    );
  }

  List<Widget> _createColumns() {
    var columns = <Widget>[];
    for (int index = 0; index < _controller.columns.columns.length; index++) {
      var column = _controller.columns.columns[index];
      Widget columnWidget;
      if (column is TableColumnText) {
        columnWidget = _ControlColumnText(column: column);
      } else if (column is TableColumnList) {
        columnWidget = _ControlColumnList(column: column);
      } else if (column is TableColumnBoolean) {
        columnWidget = _ControlColumnBoolean(column: column);
      } else {
        throw Exception(
            'There is no Widget defined for the column ${column.runtimeType}. Please define how a this type of column should be handled in LayoutTableHeader._createColumns.');
      }

      if (index > 0) {
        columns.add(SizedBox(width: _theme.horizontalSpacing));
      }
      if (column.relativeWidth) {
        columns.add(Expanded(
          flex: column.width,
          child: columnWidget,
        ));
      } else {
        columns
            .add(SizedBox(width: column.width.toDouble(), child: columnWidget));
      }
    }
    return columns;
  }

  final ControllerDialogWork _controller;
  late final Iterable<TableColumnListItem> _workTypes;
  final WorkDialogTheme _theme;
}

//----------------------------------------------------------------------------------------------------------------------

class _LayoutTableBody extends StatelessWidget {
  const _LayoutTableBody(
      {required ControllerDialogWork controller,
      required WorkDialogTheme theme,
      super.key})
      : _controller = controller,
        _theme = theme;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
          valueListenable: _controller.filter.filteredWorkItems,
          builder: (context, value, child) => ListView.builder(
              itemCount: _controller.filter.filteredWorkItems.value.length,
              itemBuilder: (context, index) {
                var row = _controller.filter.filteredWorkItems.value[index];
                return _LayoutTabelRow(
                    columns: _controller.columns,
                    workSummary: row,
                    onWorkSummarySelectedHandler: workSelectedHandler,
                    theme: _theme);
              })),
    );
  }

  Future workSelectedHandler(WorkSummary selectedWorkSummary) async {
    await _controller.filter.onWorkSelected(selectedWorkSummary);
  }

  final ControllerDialogWork _controller;
  final WorkDialogTheme _theme;
}

//----------------------------------------------------------------------------------------------------------------------

class _LayoutTabelRow extends StatefulWidget {
  const _LayoutTabelRow(
      {required TableColumnCollection columns,
      required WorkSummary workSummary,
      required AsyncValueSetter<WorkSummary> onWorkSummarySelectedHandler,
      required WorkDialogTheme theme,
      super.key})
      : _columns = columns,
        _workSummary = workSummary,
        _onWorkSummarySelectedHandler = onWorkSummarySelectedHandler,
        _theme = theme;

  @override
  State<_LayoutTabelRow> createState() => _LayoutTabelRowState();

  final TableColumnCollection _columns;
  final WorkSummary _workSummary;
  final WorkDialogTheme _theme;
  final AsyncValueSetter<WorkSummary> _onWorkSummarySelectedHandler;
}

class _LayoutTabelRowState extends State<_LayoutTabelRow> {
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (int index = 0; index < widget._columns.columns.length; ++index) {
      var column = widget._columns.columns[index];
      dynamic cellValue = column.cellValueGetter(widget._workSummary);
      Widget cellWidget;
      if (cellValue is bool) {
        if (cellValue == true) {
          cellWidget = Icon(Icons.check, color: Colors.black, size: 20);
        } else {
          cellWidget = SizedBox(width: 20, height: 20);
        }
      } else if (cellValue is String) {
        cellWidget = Text(cellValue, overflow: TextOverflow.ellipsis);
      } else {
        throw Exception(
            'TabelRow is not able to display a ${cellValue.runtimeType} type. Please add support for this type in TabelRow.');
      }

      if (index > 0) {
        widgets.add(SizedBox(width: widget._theme.horizontalSpacing));
      }
      if (column.relativeWidth) {
        widgets.add(Expanded(
          flex: column.width,
          child: cellWidget,
        ));
      } else {
        widgets
            .add(SizedBox(width: column.width.toDouble(), child: cellWidget));
      }
    }
    return MouseRegion(
      onEnter: (event) => {
        setState(() {
          _isMouseOver = true;
        })
      },
      onExit: (event) => {
        setState(() {
          _isMouseOver = false;
        })
      },
      child: GestureDetector(
        onTap: () async {
          await Executor.runCommandAsync('_LayoutTabelRow', 'DialogWork',
              () async {
            await widget._onWorkSummarySelectedHandler(widget._workSummary);
            Navigator.pop(context);
          }, context);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(widget._theme.padding, 0,
              widget._theme.padding, widget._theme.verticalSpacing),
          color: (_isMouseOver) ? Colors.grey[300] : Colors.white,
          child: Row(children: widgets),
        ),
      ),
    );
  }

  bool _isMouseOver = false;
}

//----------------------------------------------------------------------------------------------------------------------

class _ControlColumnText extends StatefulWidget {
  const _ControlColumnText({required TableColumnText column, super.key})
      : _column = column;

  @override
  State<_ControlColumnText> createState() => _ControlColumnTextState();

  final TableColumnText _column;
}

class _ControlColumnTextState extends State<_ControlColumnText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget._column.label),
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(8),
            filled: true,
            fillColor: Colors.white,
            constraints: BoxConstraints(maxHeight: 28),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.zero),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.zero),
          ),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          onChanged: (text) {
            widget._column.filterValue.value = text;
          },
        ),
      ],
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class _ControlColumnBoolean extends StatefulWidget {
  //#region PROPERTIES
  final TableColumnBoolean column;

  //#endregion

  //#region CONSTRUCTION
  const _ControlColumnBoolean({required this.column, super.key});

  @override
  State<_ControlColumnBoolean> createState() => _ControlColumnBooleanState();

  //#endregion
}

class _ControlColumnBooleanState extends State<_ControlColumnBoolean> {
//#region BUILD

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.column.label),
      Checkbox(
          tristate: true,
          value: widget.column.filterValue.value,
          onChanged: (value) {
            setState(() {
              widget.column.filterValue.value = value;
              ;
            });
          })
    ]);
  }

  //#endregion
}

//----------------------------------------------------------------------------------------------------------------------

class _ControlColumnList extends StatefulWidget {
  const _ControlColumnList({required TableColumnList column, super.key})
      : _column = column;

  @override
  State<_ControlColumnList> createState() => _ControlColumnListState();

  final TableColumnList _column;
}

class _ControlColumnListState extends State<_ControlColumnList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget._column.label),
        InkWell(
            child: ValueListenableBuilder(
                valueListenable: widget._column.selectedCount,
                builder: (context, value, child) {
                  return Text(widget._column.selectedCount.value.toString(),
                      key: selectedWorkTypeCountKey);
                }),
            onTap: () {
              RenderBox renderBox = selectedWorkTypeCountKey.currentContext!
                  .findRenderObject() as RenderBox;
              Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
              List<TableColumnListItem> workTypes =
                  widget._column.listFilterItems(context);
              showDialog(
                  context: context,
                  builder: (context) {
                    return Stack(children: [
                      Positioned(
                        top: widgetPosition.dy,
                        left: widgetPosition.dx,
                        width: 500,
                        height: 500,
                        child: Material(
                          child: LayoutDialogWorkTypesFilter(
                              workTypes: workTypes, column: widget._column),
                        ),
                      )
                    ]);
                  });
            }),
      ],
    );
  }

  final GlobalKey selectedWorkTypeCountKey = GlobalKey();
}

//----------------------------------------------------------------------------------------------------------------------

class LayoutDialogWorkTypesFilter extends StatelessWidget {
  LayoutDialogWorkTypesFilter(
      {required TableColumnList column,
      required List<TableColumnListItem> workTypes,
      super.key})
      : _column = column,
        _workTypes = workTypes;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TypesFilterHeader(column: _column),
      Expanded(
        child: ListView.builder(
            itemCount: _workTypes.length,
            itemBuilder: (context, index) {
              var listItem = _workTypes[index];
              return _ControlColumnListItem(
                  column: _column, listItem: listItem);
            }),
      ),
    ]);
  }

  final TableColumnList _column;
  late final List<TableColumnListItem> _workTypes;
}

//----------------------------------------------------------------------------------------------------------------------

class TypesFilterHeader extends StatelessWidget {
  const TypesFilterHeader({required TableColumnList column, super.key})
      : _column = column;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: _column.selectedCount,
              builder: (context, value, child) {
                return Text('Selected ${_column.selectedCount.value}');
              }),
        ),
        IconButtonAction(Icons.close, onPressed: () => Navigator.pop(context))
      ],
    );
  }

  final TableColumnList _column;
}

//----------------------------------------------------------------------------------------------------------------------

class _ControlColumnListItem extends StatefulWidget {
  const _ControlColumnListItem(
      {required TableColumnList column,
      required TableColumnListItem listItem,
      super.key})
      : _column = column,
        _listItem = listItem;

  @override
  State<_ControlColumnListItem> createState() => _ControlColumnListItemState();

  final TableColumnList _column;
  final TableColumnListItem _listItem;
}

class _ControlColumnListItemState extends State<_ControlColumnListItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            value: widget._listItem.isSelected.value,
            onChanged: (value) {
              setState(() {
                widget._listItem.isSelected.value = value!;
                if (widget._listItem.isSelected.value) {
                  widget._column
                      .selectWorkType(widget._listItem.lowercaseLabel);
                } else {
                  widget._column
                      .deselectWorkType(widget._listItem.lowercaseLabel);
                }
              });
            }),
        Text(widget._listItem.label),
      ],
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------

class WorkDialogTheme extends ThemeExtension<WorkDialogTheme> {
  final double width;
  final double height;
  final double padding;
  final double horizontalSpacing;
  final double verticalSpacing;
  final TextStyle headerTextStyle;

  final Color backgroundColor;

  const WorkDialogTheme({
    required this.width,
    required this.height,
    required this.padding,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    required this.headerTextStyle,
    required this.backgroundColor,
  });

  @override
  ThemeExtension<WorkDialogTheme> copyWith() {
    return WorkDialogTheme(
      width: width,
      height: height,
      padding: padding,
      verticalSpacing: verticalSpacing,
      horizontalSpacing: horizontalSpacing,
      headerTextStyle: headerTextStyle,
      backgroundColor: backgroundColor,
    );
  }

  @override
  ThemeExtension<WorkDialogTheme> lerp(
      covariant WorkDialogTheme? other, double t) {
    if (other == null) return this;
    return WorkDialogTheme(
      width: lerpDouble(width, other.width, t)!,
      height: lerpDouble(height, other.height, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      verticalSpacing: lerpDouble(verticalSpacing, other.verticalSpacing, t)!,
      horizontalSpacing:
          lerpDouble(horizontalSpacing, other.horizontalSpacing, t)!,
      headerTextStyle:
          TextStyle.lerp(headerTextStyle, other.headerTextStyle, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
    );
  }
}

//----------------------------------------------------------------------------------------------------------------------
