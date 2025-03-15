import 'package:flutter/material.dart';
import 'package:mychat/model/messagemodel.dart';
import 'package:mychat/service/database.dart';

class Chatscreen extends StatefulWidget {
  final String senderid;
  final String receiverId;
  final String name;
  const Chatscreen(
      {super.key,
      required this.senderid,
      required this.receiverId,
      required this.name, 
});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController _controller = TextEditingController();
  late Database _database;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _database = Database(uid: widget.senderid,);
  }

  void _sendMessage() async {
    if (_controller.text.trim().isNotEmpty) {
      await _database.addMessage(
          widget.senderid, widget.receiverId, _controller.text.trim());
      _controller.clear();
    }
  }

  String getChatId(String senderId, String receiverId) {
    List<String> list = [senderId, receiverId];
    list.sort();
    return list.join("_");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            widget.name,
            style: const TextStyle(color: Colors.white),
          )),
      body: Stack(
        children: [
          Image.asset('assets/background.jpg', 
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,),
          Column(
            children: [
              Expanded(
                child: StreamBuilder<List<Messagemodel>>(
                    stream: _database
                        .getMessages(getChatId(widget.senderid, widget.receiverId)),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No messages'),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final messages = snapshot.data!;
          
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.senderId == widget.senderid;
          
                          return Align(
                            alignment:
                                isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blueAccent : Colors.grey.shade300,
                                borderRadius: isMe
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        bottomLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                      )
                                    : const BorderRadius.only(
                                        bottomLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                        bottomRight: Radius.circular(50)),
                              ),
                              child: Text(
                                msg.message,
                                style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
          
              // Input Field
              Container(
                padding: const EdgeInsets.all(10),
               
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50))),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blueAccent),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
