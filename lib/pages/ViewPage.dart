import 'package:flutter/material.dart';
import 'package:resumebuilder/services/data.dart';
import '../models/ResumeItem.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resume'),
      ),
      body: FutureBuilder<List<ResumeItem>>(
        future: _loadResumeItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<ResumeItem> resumeItems = snapshot.data!;
              return ListView.builder(
                itemCount: resumeItems.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          resumeItems[index].title,
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 20),
                        )),
                        Expanded(child: Text(resumeItems[index].content))
                      ],
                    ),
                  ));
                },
              );
            } else {
              return const Center(
                child: Text('No resume items'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: EdgeInsets.fromLTRB(26, 10, 26, 10),
        ),
        child: const Text('Edit Resume'),
      ),
    );
  }

  Future<List<ResumeItem>> _loadResumeItems() async {
    DataStorage dataStorage = DataStorage();
    List<String>? titles = await dataStorage.readTitels();
    List<String>? contents = await dataStorage.readContant();

    List<ResumeItem> resumeItems = [];

    if (titles != null && contents != null) {
      for (int i = 0; i < titles.length; i++) {
        resumeItems.add(ResumeItem(title: titles[i], content: contents[i]));
      }
    }

    return resumeItems;
  }
}
