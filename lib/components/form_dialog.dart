import 'package:flutter/material.dart';
import 'package:lunchspot_v1/components/sys_button.dart';
import 'package:lunchspot_v1/data/restaurant_record.dart';

class FormDialog extends StatefulWidget {
  final bool isEditing; // Flag to indicate add or edit mode
  final RestaurantRecord?
      initialRecord; // Existing record for editing (optional)
  final Function(RestaurantRecord)
      onRecordSaved; // Callback to handle saved record

  // const FormDialog({super.key});
  const FormDialog({
    super.key,
    required this.isEditing,
    this.initialRecord,
    required this.onRecordSaved,
  });

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = ''; // State variables for record fields
  String _address = '';
  String _logoUrl = '';

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.initialRecord != null) {
      _name = widget.initialRecord!.name;
      _address = widget.initialRecord!.address;
      _logoUrl = widget.initialRecord!.logoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEditing ? 'Edit Record' : 'Add Record'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
                hintText: "Enter restaurant name",
              ),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a restaurant name' : null,
              onSaved: (newValue) => _name = newValue!,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              initialValue: _address,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Address",
                hintText: "Enter restaurant address",
              ),
              onSaved: (newValue) => _address = newValue!,
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              initialValue: _logoUrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Logo",
                hintText: "Enter restaurant logo URL",
              ),
              // The validator receives the text that the user has entered.
              validator: (url) {
                // TODO: check valid url
                // if (url == null ||
                //     url.isNotEmpty ||
                //     !Uri.parse(url).isAbsolute) {
                //   return 'Please enter a valid URL';
                // }
                return null;
              },
              onSaved: (newValue) => _logoUrl = newValue!,
            ),
          ],
        ),
      ),
      actions: [
        SysButton(text: "Cancel", onPressed: () => Navigator.pop(context)),
        SysButton(
            text: widget.isEditing ? 'Update' : 'Save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final newRecord = RestaurantRecord(
                  name: _name,
                  address: _address,
                  logoUrl: _logoUrl,
                );
                widget.onRecordSaved(newRecord);
                Navigator.pop(context); // Close dialog after saving
              }
            }),
      ],
    );
  }
}
