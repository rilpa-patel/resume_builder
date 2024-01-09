import 'package:flutter/material.dart';
import 'package:resumebuilder/services/data.dart';
import 'ViewPage.dart';
import '../models/ResumeItem.dart';

class CollectData extends StatefulWidget {
  const CollectData({super.key});

  @override
  _CollectDataState createState() => _CollectDataState();
}

class _CollectDataState extends State<CollectData> {
  List<ResumeItem> resumeItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResumeItems();
  }

  _loadResumeItems() async {
    DataStorage dataStorage = DataStorage();
    List<String>? titles = await dataStorage.readTitels();
    List<String>? contents = await dataStorage.readContant();

    if (titles != null && contents != null) {
      setState(() {
        for (int i = 0; i < titles.length; i++) {
          resumeItems.add(ResumeItem(title: titles[i], content: contents[i]));
        }
      });
    }
  }

  _editFiled(int index) async {
    DataStorage dataStorage = DataStorage();
    List<String>? titles = await dataStorage.readTitels();
    List<String>? contents = await dataStorage.readContant();
    setState(() {
      titleController.text = titles![index];
      contentController.text = contents![index];
    });
  }

  _saveResumeItems() async {
    DataStorage dataStorage = DataStorage();
    await dataStorage.StoreData(resumeItems);
  }

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
                return Row(
                  children: [
                    Expanded(child: Text(resumeItems[index].title)),
                    Expanded(
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: resumeItems[index].content,
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ]),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() async {
                          resumeItems.removeAt(index);
                          _editFiled(index);
                          _saveResumeItems();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          resumeItems.removeAt(index);
                          _saveResumeItems();
                        });
                      },
                    ),
                  ],
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
                          _saveResumeItems();
                        });
                      },
                      child: Text('Add'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          resumeItems.clear();
                          _saveResumeItems();
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
