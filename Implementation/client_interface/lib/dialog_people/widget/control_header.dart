import 'package:client_interfaces1/dialog_people/controller/controller_dialog_people.dart';
import 'package:client_interfaces1/ui_toolkit/layout_accept_reject.dart';
import 'package:flutter/material.dart';

import '../../execution/executor.dart';
import '../../theme/theme_extension_dialog_people.dart';
import '../../ui_toolkit/control_icon_button_large.dart';

class ControlHeader extends StatelessWidget {
  const ControlHeader({
    required ControllerDialogPeople controller,
    required ThemeExtensionDialogPeople theme,
    super.key,
  }) : _controller = controller,
       _theme = theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _theme.dialogBaseTheme.dialogHeaderColor,
      child: Padding(
        padding: _theme.dialogBaseTheme.edgeInsetsWide,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Text(
                'People',
                style: _theme.dialogBaseTheme.dialogHeaderTextStyle,
              ),
            ),
            SizedBox(
              width: _theme.commandColumnWidth,
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: _controller.hasChanges,
                  builder: (context, value, child) {
                    if (_controller.hasChanges.value) {
                      return LayoutAcceptReject(
                        onAccept: () => Executor.runCommandAsync(
                          'LayoutAcceptReject.onAccept',
                          'LayoutDialogPeople',
                          () => _controller.onAcceptUpdates(),
                        ),

                        onReject: () => Executor.runCommand(
                          'LayoutAcceptReject.onReject',
                          'LayoutDialogPeople',
                          () => _controller.onClose(),
                        ),
                      );
                    } else {
                      return ControlIconButtonLarge(
                        icon: Icon(Icons.close),
                        onPressed: () => Executor.runCommand(
                          'ControlIconButtonLarge.close.onPressed',
                          'LayoutDialogPeople',
                          () => _controller.onClose(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final ControllerDialogPeople _controller;
  final ThemeExtensionDialogPeople _theme;
}
