import 'package:datatable/datatable.dart';
import 'package:flutter/material.dart';

class Inputpage extends StatefulWidget {
    Inputpage({super.key});

  @override
  State<Inputpage> createState() => _InputpageState();
}

class _InputpageState extends State<Inputpage> {
  

  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

@override
  void initState() {
    super.initState();
    filteredUsers = List.from(users);
  }
  void addUser() {
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty) 
        {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    setState(() {
      users.add({
        "Id": idController.text,
        "Name": nameController.text,
        "Email": emailController.text,
      });
      filteredUsers = List.from(users);

      idController.clear();
      nameController.clear();
      emailController.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 450,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SizedBox(height:40),
              Container(
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                            controller: idController,
                            decoration: InputDecoration(
                              labelText: 'Id',
                              hintText:
                                  'Enter your Id ',
                              prefixIcon: Icon(Icons.text_fields),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  width: 2,
                                ),
                                
                              ),
                             
                            ),
                          ),
              ),
                SizedBox(height: 20),
              Container(
                width: 400,
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(8),
              ),
                                    child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText:
                                'Enter your Name ',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                width: 2,
                              ),
                              
                            ),
                            
                          ),
                        ),
              ),
                SizedBox(height: 20),
              Container(
                width: 400,
              decoration: BoxDecoration(
                
                borderRadius: BorderRadius.circular(8),
              ),
                                    child:TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText:
                                'Enter your Email ',
                            prefixIcon: Icon(Icons.text_fields),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                width: 2,
                              ),
                              
                            ),
                            
                          ),
                        ),
              ),
              SizedBox(height:20),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
            children:[  ElevatedButton(
                onPressed: addUser,
                child:   Text("Add"),
              ),
              SizedBox(width: 40),
                ElevatedButton(
                onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Datatable()));
                },
                child:   Text("View Table"),
              )
            ])
            ],
          ),
        ),
      ),
    );
  }
}