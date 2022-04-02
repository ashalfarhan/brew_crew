import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const List<String> _sugarOptions = ["0", "1", "2", "3", "4"];

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();

  String? _name;
  String? _sugars;
  int? _strength;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    void _onSubmit(AsyncSnapshot<Brew> snap) async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      try {
        await _db.updateBrewByUid(
          user.uid,
          name: _name ?? snap.data!.name,
          sugars: _sugars ?? snap.data!.sugars,
          strength: _strength ?? snap.data!.strength,
        );
        Navigator.pop(context);
      } catch (e) {
        print("Failed to update: ${e.toString()}");
      }
    }

    return StreamBuilder<Brew>(
      stream: _db.getByUid(user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Loader();
        Brew data = snapshot.data!;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                "Update your brew settings.",
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val!.isEmpty ? "Please enter a name" : null,
                decoration: inputDecoration.copyWith(hintText: "Name"),
                onChanged: (val) => setState(() => _name = val),
                initialValue: data.name,
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: inputDecoration.copyWith(hintText: "Sugars"),
                value: _sugars ?? data.sugars,
                onChanged: (e) {
                  setState(() => _sugars = e ?? "");
                },
                items: _sugarOptions.map((item) {
                  return DropdownMenuItem<String>(
                    child: Text("$item sugar(s)"),
                    value: item,
                  );
                }).toList(),
              ),
              Slider(
                activeColor: Colors.brown[_strength ?? data.strength],
                min: 100.0,
                max: 900.0,
                divisions: 8,
                value: (_strength ?? data.strength).toDouble(),
                onChanged: (e) {
                  setState(() => _strength = e.round());
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _onSubmit(snapshot);
                },
                child: Text("Update"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown[400],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
