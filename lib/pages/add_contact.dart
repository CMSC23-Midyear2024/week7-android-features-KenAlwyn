import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:week_7_android_features/components/camera_widget.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? _fname;
  String? _lname;
  String? _phoneNumber;
  String? _email;

    Widget createTextFormField(String textHint, bool validate, Function(String?) handleOnSave) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: TextFormField(
        validator: validate 
        ?(val) {
          if (val == null || val.isEmpty) {
            return "This is a required field";
          }
          return null;
        }
        : null,
        decoration: InputDecoration(
          labelText: textHint,
          border: const OutlineInputBorder(),
          hintText: textHint,
        ),
        onSaved: handleOnSave
      ),
    );
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contact"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),         
            const CameraWidget(),
            const SizedBox(height: 30,),

            Form(
              key: _formkey,
              child: Column(
                children: [
                  createTextFormField("First Name", true, (val){
                    setState(() {
                      _fname = val;
                    });
                  }),
                  createTextFormField("Last Name", true, (val){
                    setState(() {
                      _lname = val;
                    });
                  }),
                  createTextFormField("Phone Number", true, (val){
                    setState(() {
                      _phoneNumber = val;
                    });
                  }),
                  createTextFormField("Email", false, (val){
                    setState(() {
                      _email = val;
                    });
                  }),
                  
                  const SizedBox(height: 30,),
        
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.deepPurple)
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        
                        final newContact = Contact(
                          name: Name(
                            first: _fname!,
                            last: _lname!
                          ),
                          phones: [Phone(_phoneNumber!)], 
                          emails: [Email(_email ?? "")]
                        );

                        newContact.insert();
                        Navigator.pushNamed(context, "/home");
                      }  
                    }, 
                    child: const Text("Add Contact")
                  )
                ],
              )
            ),

          ],
        ),
      ),
    );
  }
}