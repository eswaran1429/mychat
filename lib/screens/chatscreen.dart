import 'package:flutter/material.dart';
import 'package:mychat/model/messagemodel.dart';
import 'package:mychat/service/database.dart';

class Chatscreen extends StatefulWidget {
  final String senderid;
  final String receiverId;
  const Chatscreen({super.key, required this.senderid, required this.receiverId});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  late Database _database ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _database = Database(uid: widget.senderid);
  }
  
  void _sendMessage() async{
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_controller.text.trim());
      });
      await _database.addMessage(widget.senderid, widget.receiverId, _controller.text.trim());
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
      appBar: AppBar(title:  Text(widget.receiverId)),
      body: Column(
        children: [
          Text(widget.senderid),
          // Chat Messages List
          Expanded(
            child: StreamBuilder<List<Messagemodel>>(
              stream: _database.getMessages(getChatId(widget.senderid, widget.receiverId)),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages'),);
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
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blueAccent : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              msg.message,
              style: TextStyle(color: isMe ? Colors.white : Colors.black),
            ),
          ),
        );
                  },
                );
              }
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
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
    );
  }
}
