import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class dbManager extends StatefulWidget {
  const dbManager({super.key});

  @override
  State<dbManager> createState() => _dbManagerState();
}

class _dbManagerState extends State<dbManager> {
  late DatabaseReference _dbref;
  String databasejson = "";
  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("database - " + databasejson),
              ),
              TextButton(
                  onPressed: () {
                    _createDB();
                  },
                  child: const Text("create DB")),
              TextButton(
                  onPressed: () {
                    _readdb_onechild();
                  },
                  child: const Text("read")),
            ],
          ),
        ),
      ),
    );
  }

  _createDB() {
    _dbref.child("Information").set({
      'Actinic keratoses':
          'n actinic keratosis (ak-TIN-ik ker-uh-TOE-sis) is a rough, scaly patch on the skin that develops from years of sun exposure. Its often found on the face, lips, ears, forearms, scalp, neck or back of the hands.Also known as a solar keratosis, an actinic keratosis grows slowly and usually first appears in people over 40. You can reduce your risk of this skin condition by minimizing your sun exposure and protecting your skin from ultraviolet (UV) rays.Left untreated, the risk of actinic keratoses turning into a type of skin cancer called squamous cell carcinoma is about 5% to 10%.',
      'Basal cell carcinoma':
          'Basal cell carcinoma is a type of skin cancer. Basal cell carcinoma begins in the basal cells a type of cell within the skin that produces new skin cells as old ones die off.Basal cell carcinoma often appears as a slightly transparent bump on the skin, though it can take other forms. Basal cell carcinoma occurs most often on areas of the skin that are exposed to the sun, such as your head and neck.Basal cell carcinoma usually develops on sun-exposed parts of your body, especially your head and neck. Less often, basal cell carcinoma can develop on parts of your body usually protected from the sun, such as the genitals.Basal cell carcinoma appears as a change in the skin, such as a growth or a sore that wont heal. These changes in the skin (lesions) usually have one of the following characteristics:• A shiny, skin-colored bump thats translucent, meaning you can see a bit through the surface. The bump can look pearly white or pink on white skin. On brown and Black skin, the bump often looks brown or glossy black. Tiny blood vessels might be visible, though they may be difficult to see on brown and Black skin. The bump may bleed and scab over.• A brown, black or blue lesion — or a lesion with dark spots — with a slightly raised, translucent border.• A flat, scaly patch with a raised edge. Over time, these patches can grow quite large.• A white, waxy, scar-like lesion without a clearly defined border.'
    });
  }

  _readdb_onechild() {
    _dbref
        .child("Information")
        .child("Actinic keratoses")
        .once()
        .then((DatabaseEvent dataSnapshot) {
      print("read once - " + dataSnapshot.snapshot.value.toString());
      setState(() {
        databasejson = dataSnapshot.snapshot.value.toString();
      });
    });
  }
}
