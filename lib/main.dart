import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:week_7_android_features/pages/add_contact.dart';
import 'pages/contact.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      // theme: ThemeData(
      //     appBarTheme: const AppBarTheme(
      //         iconTheme: IconThemeData(color: Colors.white),
      //         color: Colors.blue,
      //         titleTextStyle: TextStyle(
      //             color: Colors.white,
      //             fontSize: 23,
      //             fontWeight: FontWeight.bold)),
      //     floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //         backgroundColor: Colors.blue, 
      //         foregroundColor: Colors.white)),
      initialRoute: "/home",
      onGenerateRoute: (settings) {
        if(settings.name == "/home") {
          return MaterialPageRoute(builder: (context) => const ContactList());
        }
        else if(settings.name == "/contact") {
          final contact = settings.arguments as Contact;
          return MaterialPageRoute(builder: (context) => ContactPage(contact));
        }
        else if(settings.name == "/add-contact") {
          return MaterialPageRoute(builder: (context) => const AddContactPage());
        }
        return null;
      },
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    FlutterContacts.addListener(() => _fetchContacts());
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: false)) {
      setState(() => _permissionDenied = true);
    } else {
      var contacts = await FlutterContacts.getContacts();
      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('My Contacts')), 
        body: _body(),
        floatingActionButton: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.deepPurple)
          ),
          onPressed: (){
            Navigator.pushNamed(context, "/add-contact");
          }, 
          child: const Icon(Icons.contacts_rounded)
        ),
    );
  }

  Widget _body() {
    if (_permissionDenied) {
      return const Center(child: Text('Permission denied'));
    }
    if (_contacts == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(_contacts![i].displayName),
        onTap: () {
          FlutterContacts.getContact(_contacts![i].id).then((contact) {
            Navigator.pushNamed(
              context,
              "/contact",
              arguments: contact
            );
          });
        }
      )
    );
  }
}
