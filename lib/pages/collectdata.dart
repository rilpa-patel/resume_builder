import 'package:flutter/material.dart';
import 'ViewPage.dart';
import '../models/ResumeItem.dart';

class CollectData extends StatefulWidget {
  @override
  _CollectDataState createState() => _CollectDataState();
}

class _CollectDataState extends State<CollectData> {
  List<ResumeItem> resumeItems = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume Builder'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: resumeItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(resumeItems[index].title),
                  subtitle: Text(resumeItems[index].content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        resumeItems.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(
                    labelText: 'Content',
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          resumeItems.add(
                            ResumeItem(
                              title: titleController.text,
                              content: contentController.text,
                            ),
                          );
                          titleController.clear();
                          contentController.clear();
                        });
                      },
                      child: Text('Add'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          resumeItems.clear();
                        });
                      },
                      child: Text('Clear All'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _viewResume();
            },
            child: Text('View Resume'),
          ),
        ],
      ),
    );
  }

  void _viewResume() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPage(),
      ),
    );
  }
}