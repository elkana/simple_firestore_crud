import 'package:flutter/material.dart';

import 'util/database.dart';
import 'util/validator.dart';

class ScreenEdit extends StatefulWidget {
  final String currentTitle;
  final String currentDescription;
  final String documentId;

  const ScreenEdit(
      {Key? key,
      required this.currentTitle,
      required this.currentDescription,
      required this.documentId})
      : super(key: key);

  @override
  _ScreenEditState createState() => _ScreenEditState();
}

class _ScreenEditState extends State<ScreenEdit> {
  bool _isDeleting = false;
  final _editItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController(
      text: widget.currentTitle,
    );

    _descriptionController = TextEditingController(
      text: widget.currentDescription,
    );
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _isDeleting
              ? CircularProgressIndicator()
              : IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    setState(() {
                      _isDeleting = true;
                    });

                    try {
                      await Database.deleteItem(
                        docId: widget.documentId,
                      );

                      Navigator.of(context).pop();
                    } finally {
                      setState(() {
                        _isDeleting = false;
                      });
                    }
                  },
                ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _editItemFormKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title'),
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    validator: (value) => Validator.validateField(
                      value: value!,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter your note title',
                    ),
                  ),
                  Text('Description'),
                  TextFormField(
                    maxLines: 10,
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value!,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Description',
                      hintText: 'Enter your note description',
                    ),
                  ),
                ],
              ),
              _isProcessing
                  ? CircularProgressIndicator()
                  : Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_editItemFormKey.currentState!.validate()) {
                            setState(() {
                              _isProcessing = true;
                            });

                            await Database.updateItem(
                              docId: widget.documentId,
                              title: _titleController.text,
                              description: _descriptionController.text,
                            );

                            setState(() {
                              _isProcessing = false;
                            });

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text('UPDATE ITEM'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
