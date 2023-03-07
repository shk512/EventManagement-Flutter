import 'dart:core';
import 'package:event_management/utils/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../services/db.dart';
import '../utils/decor.dart';
import '../widgets/snack_bar.dart';

class Booking extends StatefulWidget {
  final String hallName;
  const Booking({Key? key, required this.hallName}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  TextEditingController date = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController contact2 = TextEditingController();
  String extraInfoCtrl = '';
  String catteringAmount = '';
  String decorAmount = '0';
  String totalPersons = '';
  String advanceAmount = '0';
  String decorDetails = '';
  String menu = '';
  String time = '';
  Time selectedTime = Time.morning;
  Type selectedType = Type.perhead;
  String type = 'PerHead';
  bool decor = false;
  bool extraInfo = false;
  bool search = false;
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Decor.prime,
                ),
                child: const Text(
                  'Booking Form',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //Hall Name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Selected Hall: ',
                    style: TextStyle(
                        color: Decor.prime,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Text(
                    widget.hallName,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),

              //Date
              TextField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_month),
                    labelText: "Select Date",
                  ),
                  readOnly: true,
                  controller: date,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat("dd-MM-yyyy").format(pickedDate);
                      setState(() {
                        date.text = formattedDate;
                      });
                    }
                  }),
              const SizedBox(height: 15),
              //TIME
              Row(
                children: [
                  //MORNING
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        'Morning',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Radio(
                        value: Time.morning,
                        groupValue: selectedTime,
                        onChanged: (Time? value) {
                          setState(() {
                            selectedTime = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  //EVENING
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        'Evening',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Radio(
                        value: Time.evening,
                        groupValue: selectedTime,
                        onChanged: (Time? value) {
                          setState(() {
                            selectedTime = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  //BOTH
                  Expanded(
                    child: ListTile(
                      title: const Text(
                        'All Day',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      leading: Radio(
                        value: Time.both,
                        groupValue: selectedTime,
                        onChanged: (Time? value) {
                          setState(() {
                            selectedTime = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              search
                  ? const SizedBox(height: 0)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (date.text.isNotEmpty) {
                              setState(() {
                                isLoading = true;
                              });
                              if (selectedTime == Time.morning) {
                                time = 'morning';
                              } else if (selectedTime == Time.evening) {
                                time = 'evening';
                              } else if (selectedTime == Time.both) {
                                time = 'all day';
                              }
                              searchDateHallAndTime();
                            } else {
                              showSnackbar(context, Colors.red,
                                  "Can't search. Date is empty");
                            }
                          },
                          child: Text(isLoading
                              ? 'Searching... Please Wait'
                              : 'Search'),
                        ),
                      ],
                    ),
              const SizedBox(height: 15),

              search
                  ? Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //NAME OF CLIENT
                          TextFormField(
                            controller: name,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Name',
                              labelText: 'Hosted By',
                            ),
                            validator: (value) {
                              if (name.text.isNotEmpty) {
                                return null;
                              } else {
                                return '*Required';
                              }
                            },
                          ),
                          const SizedBox(height: 15),

                          //Contact
                          TextFormField(
                              controller: contact,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '03xxxxxxxxx',
                                labelText: 'Contact',
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (contact.text.isNotEmpty) {
                                  if (value!.length == 11) {
                                    return null;
                                  } else {
                                    return "Invalid format";
                                  }
                                } else {
                                  return '*Required';
                                }
                              }),
                          const SizedBox(height: 15),

                          //2nd Contact
                          TextFormField(
                            controller: contact2,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: '03xxxxxxxxx',
                              labelText: 'Contact (Optional)',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          const SizedBox(height: 15),

                          //PERHEAD/LUMPSUM WITH CATERIN
                          Row(
                            children: [
                              //PERHEAD
                              Expanded(
                                child: ListTile(
                                  title: const Text(
                                    'Per Head',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  leading: Radio(
                                    value: Type.perhead,
                                    groupValue: selectedType,
                                    onChanged: (Type? value) {
                                      setState(() {
                                        selectedType = value!;
                                        type = 'PerHead';
                                      });
                                    },
                                  ),
                                ),
                              ),

                              //LUMPSUM
                              Expanded(
                                child: ListTile(
                                  title: const Text(
                                    'Lumpsum',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  leading: Radio(
                                    value: Type.lumpsum,
                                    groupValue: selectedType,
                                    onChanged: (Type? value) {
                                      setState(() {
                                        selectedType = value!;
                                        type = 'Lumpsum';
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),

                          //persons
                          TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'e.g. 200',
                              labelText: 'Total Persons',
                            ),
                            onChanged: (value) {
                              totalPersons = value;
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter persons';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          //total price
                          TextFormField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: selectedType == Type.lumpsum
                                  ? 'e.g. 50000'
                                  : 'e.g. 1000',
                              labelText: selectedType == Type.lumpsum
                                  ? 'Cattering Amount'
                                  : 'Per head Rate',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (val) {
                              catteringAmount = val;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Amount';
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 10),

                          //MENU
                          selectedType == Type.perhead
                              ? TextFormField(
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Starter\nMain Course\nDessert',
                                    labelText: 'Menu',
                                  ),
                                  onChanged: (val) {
                                    menu = val;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Menu';
                                    } else {
                                      return null;
                                    }
                                  },
                                )
                              : const SizedBox(height: 0),
                          const SizedBox(height: 15),

                          //DECORATION
                          CheckboxListTile(
                            value: decor,
                            onChanged: (value) {
                              setState(() {
                                decor = value as bool;
                              });
                            },
                            subtitle:
                                const Text('Want some customize decoration?'),
                            title: const Text(
                              'Decoration',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),

                          //DECORATION DESCRIPTION
                          decor
                              ? Column(
                                  children: [
                                    TextFormField(
                                      maxLines: 2,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText:
                                            'Design no. or brief about designs',
                                        labelText: 'Decoration Details',
                                      ),
                                      onChanged: (val) {
                                        decorDetails = val;
                                      },
                                      validator: (value) {
                                        if (value!.isNotEmpty) {
                                          return null;
                                        } else {
                                          return 'Enter Decor Details';
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: 'e.g. 100000',
                                        labelText: 'Decor Amount',
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (val) {
                                        decorAmount = val;
                                      },
                                      validator: (value) {
                                        return value!.isEmpty
                                            ? '*Required'
                                            : null;
                                      },
                                    )
                                  ],
                                )
                              : const SizedBox(height: 0),
                          const SizedBox(height: 10),

                          //Extra Info
                          CheckboxListTile(
                            value: extraInfo,
                            onChanged: (value) {
                              setState(() {
                                extraInfo = value as bool;
                              });
                            },
                            title: const Text(
                              'Extra Info (if-any)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),

                          //Extra Info Details
                          extraInfo
                              ? TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Details...",
                                    labelText: 'Extra Info (if-any)',
                                  ),
                                  onChanged: (val) {
                                    extraInfoCtrl = val;
                                  },
                                  validator: (value) {
                                    return value!.isEmpty ? '*Required' : null;
                                  },
                                )
                              : const SizedBox(height: 0),
                          const SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Advance Amount',
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (val) {
                              advanceAmount = val;
                            },
                          ),
                        ],
                      ),
                    )
                  : Container(),
              //SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: search
          ? ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                    onPressed: () {
                      if (date.text.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        if (selectedTime == Time.morning) {
                          time = 'morning';
                        } else if (selectedTime == Time.evening) {
                          time = 'evening';
                        } else if (selectedTime == Time.both) {
                          time = 'all day';
                        }
                        searchDateHallAndTime();
                      } else {
                        showSnackbar(
                            context, Colors.red, "Can't search. Date is empty");
                      }
                    },
                    child: Text(
                        isLoading ? 'Searching... Please Wait' : 'Search')),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      saveBooking();
                      setState(() {
                        isLoading = true;
                      });
                    } else {
                      showSnackbar(
                          context, Colors.red, "Form is not properly filled");
                    }
                  },
                  child: Text(
                    isLoading ? "Saving..." : 'Save',
                  ),
                ),
              ],
            )
          : const SizedBox(height: 0),
    );
  }

  searchDateHallAndTime() async {
    String bookingId = '${date.text}__${widget.hallName}_$time';
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .searchDateHallAndTime(bookingId)
        .then((value) {
      setState(() {
        search = value;
      });
    });
    if (search == true) {
      showSnackbar(context, Colors.green, "Hurray! Available");
      setState(() {
        isLoading = false;
      });
    } else {
      showSnackbar(context, Colors.red, "Oops! Not Available");
      setState(() {
        isLoading = false;
      });
    }
  }

  saveBooking() async {
    String bookingId = '${date.text}__${widget.hallName}_$time';
    Map<String, dynamic> bookingMap = {
      "date": date.text,
      "bookingId": bookingId,
      "hallName": widget.hallName,
      "time": time,
      "name": name.text,
      "contact": contact.text,
      "contact2": contact2.text,
      "type": selectedType.name,
      "totalPersons": totalPersons,
      "menu": menu,
      "rate": catteringAmount,
      "advance": advanceAmount,
      "decoration": decorDetails,
      "decorAmount": decorAmount,
      "extraInfo": extraInfoCtrl,
      "extraAmount": "0",
      "totalAmount": "0",
      "balanceAmount": "0",
      "concessionAmount": "0",
      "booking": "admin",
      "status": "confirm",
    };
    await Db(id: FirebaseAuth.instance.currentUser!.uid)
        .saveBooking(bookingId, bookingMap)
        .whenComplete(() {
      setState(() {
        isLoading = false;
      });
      showSnackbar(context, Colors.green, "Saved Successfully");
      Navigator.pop(context);
    });
  }
}
