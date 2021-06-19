import 'package:flutter/material.dart';

import 'util/database.dart';
import 'util/validator.dart';

class ScreenAdd extends StatefulWidget {
  const ScreenAdd({Key? key}) : super(key: key);

  @override
  _ScreenAddState createState() => _ScreenAddState();
}

class _ScreenAddState extends State<ScreenAdd> {
  final _addItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addItemFormKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  : ElevatedButton(
                      onPressed: () async {
                        if (_addItemFormKey.currentState!.validate()) {
                          setState(() {
                            _isProcessing = true;
                          });

                          try {
                            await Database.addItem(
                              title: _titleController.text,
                              description: _descriptionController.text,
                            );

                            Navigator.of(context).pop();
                          } finally {
                            setState(() {
                              _isProcessing = false;
                            });
                          }
                        }
                      },
                      child: Text('ADD ITEM'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
