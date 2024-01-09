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
    int? editingIndex;


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

  

  _saveResumeItems() async {
    DataStorage dataStorage = DataStorage();
    await dataStorage.StoreData(resumeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume Builder'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: resumeItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
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
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ]),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _startEditing(index);
                          },
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            resumeItems.removeAt(index);
                            _saveResumeItems();
                          });
                        },
                      ),
                    ],
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
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (editingIndex == null)
                      ElevatedButton(
                        onPressed: () {
                          _addResumeItem();
                        },
                        child: const Text('Add'),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          _updateResumeItem();
                        },
                        child: const Text('Edit'),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        _clearFields();
                      },
                      child: const Text('Clear All'),
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
            child: const Text('View Resume'),
          ),
        ],
      ),
    );
  }

  void _addResumeItem() {
    setState(() {
      resumeItems.add(
        ResumeItem(
          title: titleController.text,
          content: contentController.text,
        ),
      );
      _clearFields();
      _saveResumeItems();
    });
  }
    void _updateResumeItem() {
    setState(() {
      if (editingIndex != null) {
        resumeItems[editingIndex!] = ResumeItem(
          title: titleController.text,
          content: contentController.text,
        );
        _clearFields();
        _saveResumeItems();
      }
    });
  }

  void _startEditing(int index) {
    setState(() {
      editingIndex = index;
      titleController.text = resumeItems[index].title;
      contentController.text = resumeItems[index].content;
    });
  }

  void _clearFields() {
    setState(() {
      editingIndex = null;
      titleController.clear();
      contentController.clear();
    });
  }

  void _viewResume() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewPage(),
      ),
    );
  }

  void _moveItem(int fromIndex, int offset) {
    setState(() {
      if (fromIndex + offset >= 0 &&
          fromIndex + offset < resumeItems.length) {
        final movedItem = resumeItems.removeAt(fromIndex);
        resumeItems.insert(fromIndex + offset, movedItem);
        _saveResumeItems();
      }
    });
  }
}
