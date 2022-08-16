import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../common/constants.dart' show kGrey200;
import '../../../generated/l10n.dart';
import '../../../services/index.dart';

class QuantitySelection extends StatefulWidget {
  final int limitSelectQuantity;
  final int? value;
  final double width;
  final double height;
  final Function? onChanged;
  final Color color;
  final bool useNewDesign;
  final bool enabled;
  final bool expanded;

  const QuantitySelection({
    required this.value,
    this.width = 40.0,
    this.height = 42.0,
    this.limitSelectQuantity = 100,
    required this.color,
    this.onChanged,
    this.useNewDesign = true,
    this.enabled = true,
    this.expanded = false,
  });

  @override
  _QuantitySelectionState createState() => _QuantitySelectionState();
}

class _QuantitySelectionState extends State<QuantitySelection> {
  final TextEditingController _textController = TextEditingController();
  Timer? _debounce;

  Timer? _changeQuantityTimer;

  @override
  void initState() {
    super.initState();
    _textController.text = '${widget.value}';
    _textController.addListener(_onQuantityChanged);
  }

  @override
  void didUpdateWidget(covariant QuantitySelection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.limitSelectQuantity != widget.limitSelectQuantity) {
      changeQuantity(widget.value ?? 1, forceUpdate: true);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onQuantityChanged);
    _changeQuantityTimer?.cancel();
    _debounce?.cancel();
    _textController.dispose();
    super.dispose();
  }

  int get currentQuantity => int.tryParse(_textController.text) ?? -1;

  bool _validateQuantity([int? value]) {
    if ((value ?? currentQuantity) <= 0) {
      _textController.text = '1';
      return false;
    }

    if ((value ?? currentQuantity) > widget.limitSelectQuantity) {
      _textController.text = '${widget.limitSelectQuantity}';
      return false;
    }
    return true;
  }

  void changeQuantity(int value, {bool forceUpdate = false}) {
    if (!_validateQuantity(value)) {
      return;
    }

    if (value != currentQuantity || forceUpdate == true) {
      _textController.text = '$value';
    }
  }

  void _onQuantityChanged() {
    if (!_validateQuantity()) {
      return;
    }

    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (widget.onChanged != null) {
          widget.onChanged!(currentQuantity);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useNewDesign == true) {
      final _iconPadding = EdgeInsets.all(
        max(
          ((widget.height) - 24.0 - 8) * 0.5,
          0.0,
        ),
      );
      final _textField = Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.only(bottom: 2),
        height: widget.height,
        width: widget.expanded == true ? null : widget.width,
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: kGrey200),
          borderRadius: BorderRadius.circular(3),
        ),
        alignment: Alignment.center,
        child: TextField(
          readOnly: widget.enabled == false,
          enabled: widget.enabled == true,
          controller: _textController,
          maxLines: 1,
          maxLength: '${widget.limitSelectQuantity}'.length,
          onEditingComplete: _validateQuantity,
          onSubmitted: (_) => _validateQuantity(),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          keyboardType: const TextInputType.numberWithOptions(
            signed: false,
            decimal: false,
          ),
          textAlign: TextAlign.center,
        ),
      );
      return Row(
        children: [
          widget.enabled == true
              ? Container(
                  height: widget.height,
                  width: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: kGrey200,
                    ),
                  ),
                  child: IconButton(
                    padding: _iconPadding,
                    onPressed: () => changeQuantity(currentQuantity - 1),
                    icon: const Icon(
                      Icons.remove,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          widget.expanded == true
              ? Expanded(
                  child: _textField,
                )
              : _textField,
          widget.enabled == true
              ? Container(
                  height: widget.height,
                  width: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: kGrey200,
                    ),
                  ),
                  child: IconButton(
                    padding: _iconPadding,
                    onPressed: () => changeQuantity(currentQuantity + 1),
                    icon: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      );
    }
    return GestureDetector(
      onTap: () {
        if (widget.onChanged != null) {
          showOptions(context);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: kGrey200),
          borderRadius: BorderRadius.circular(3),
        ),
        height: widget.height,
        width: widget.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 2.0,
              horizontal: (widget.onChanged != null) ? 5.0 : 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    widget.value.toString(),
                    style: TextStyle(fontSize: 14, color: widget.color),
                  ),
                ),
              ),
              if (widget.onChanged != null)
                const SizedBox(
                  width: 5.0,
                ),
              if (widget.onChanged != null)
                Icon(Icons.keyboard_arrow_down,
                    size: 14, color: Theme.of(context).colorScheme.secondary)
            ],
          ),
        ),
      ),
    );
  }

  void showOptions(context) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: !Config().isBuilder,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      for (int option = 1;
                          option <= widget.limitSelectQuantity;
                          option++)
                        ListTile(
                            onTap: () {
                              widget.onChanged!(option);
                              Navigator.pop(context);
                            },
                            title: Text(
                              option.toString(),
                              textAlign: TextAlign.center,
                            )),
                    ],
                  ),
                ),
              ),
              Container(
                height: 1,
                decoration: const BoxDecoration(color: kGrey200),
              ),
              ListTile(
                title: Text(
                  S.of(context).selectTheQuantity,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        });
  }
}
