
 import 'dart:async';
 import 'dart:convert';
 import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
 import 'package:shared_preferences/shared_preferences.dart';
 import 'package:google_fonts/google_fonts.dart';

 import '../registration/login.dart';
 class ChatBotScreen extends StatefulWidget {
   @override
   _ChatBotScreenState createState() => _ChatBotScreenState();
 }

 class _ChatBotScreenState extends State<ChatBotScreen> {
   final TextEditingController _messageController = TextEditingController();
   final ScrollController _scrollController = ScrollController();
   List<Map<String, String>> messages = [];
   bool showWelcomeMessage = true;

   // تحديد إذا كان النص بالعربية
   bool _isArabic(String text) {
     final arabicPattern = RegExp(r'[\u0600-\u06FF]');
     return arabicPattern.hasMatch(text);
   }

   // استبدال الرموز الغير مرغوب فيها
   String _sanitizeText(String text) {
     // استبدال الرموز غير المرغوب فيها بنقاط أو أرقام
     return text
         .replaceAll(RegExp(r'[#*]'), '•')  // استبدال # و * بنقطة
         .replaceAll(RegExp(r'[-]'), '1.');  // استبدال - بأرقام مثل 1.
   }

   Future<void> sendMessage(String message) async {
     if (message.trim().isEmpty) return;

     setState(() {
       messages.add({"sender": "user", "text": message});
       showWelcomeMessage = false;
       _messageController.clear();
     });

     _scrollToBottom();

     try {
       final prefs = await SharedPreferences.getInstance();
       final token = prefs.getString('access_token');

       if (token == null || token.isEmpty) {
         setState(() {
           messages.add({
             "sender": "bot",
             "text": "يرجى تسجيل الدخول لاستخدام الشات بوت."
           });
         });
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => Login()),
         );
         return;
       }

       final response = await http.post(
         Uri.parse("https://580d-197-35-65-10.ngrok-free.app/api/chatbot/chat/"),
         headers: {
           "Content-Type": "application/json; charset=UTF-8",
           "Authorization": "Bearer $token",
         },
         body: jsonEncode({"message": message}),
       ).timeout(Duration(seconds: 30), onTimeout: () {
         throw TimeoutException("انتهت مهلة الاتصال بالخادم.");
       });

       if (response.statusCode == 200) {
         final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
         setState(() {
           messages.add({
             "sender": "bot",
             "text": _sanitizeText(jsonResponse["bot_response"] ?? "لا يوجد رد حالياً.")
           });
         });
       } else if (response.statusCode == 401) {
         setState(() {
           messages.add({
             "sender": "bot",
             "text": "انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى."
           });
         });
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => Login()),
         );
       } else {
         setState(() {
           messages.add({
             "sender": "bot",
             "text": "خطأ في الخادم: ${response.statusCode}. حاول مرة أخرى لاحقًا."
           });
         });
       }
     } catch (e) {
       setState(() {
         messages.add({
           "sender": "bot",
           "text": "تعذر الاتصال بالخادم. تحقق من الاتصال بالإنترنت."
         });
       });
     }

     _scrollToBottom();
   }

   void _scrollToBottom() {
     Future.delayed(Duration(milliseconds: 100), () {
       if (_scrollController.hasClients) {
         _scrollController.animateTo(
           _scrollController.position.maxScrollExtent,
           duration: Duration(milliseconds: 300),
           curve: Curves.easeOut,
         );
       }
     });
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Chatbot", style: GoogleFonts.poppins(color: Colors.black)),
         backgroundColor: Colors.white,
         leading: IconButton(
           icon: Icon(Icons.arrow_back, color: Colors.black),
           onPressed: () => Navigator.pop(context),
         ),
       ),
       body: Column(
         children: [
           Expanded(
             child: ListView.builder(
               controller: _scrollController,
               itemCount: messages.length + (showWelcomeMessage ? 1 : 0),
               itemBuilder: (context, index) {
                 if (showWelcomeMessage && index == 0) {
                   return _buildWelcomeMessage();
                 }

                 final msg = messages[showWelcomeMessage ? index - 1 : index];
                 final isUser = msg["sender"] == "user";

                 final messageLines = _sanitizeText(msg["text"]!)
                     .split(RegExp(r'\n|•|-|\u2022'))
                     .where((line) => line.trim().isNotEmpty)
                     .toList();

                 bool isArabicText = _isArabic(msg["text"]!);

                 return Align(
                   alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                   child: Container(
                     margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     padding: EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: isUser ? Color(0xFF6D838E) : Colors.grey[200],
                       borderRadius: BorderRadius.circular(16),
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: messageLines.map((line) {
                         return Padding(
                           padding: const EdgeInsets.symmetric(vertical: 2.0),
                           child: Text(
                             isUser ? line.trim() : "🔹 ${line.trim()}",
                             style: GoogleFonts.poppins(
                               color: isUser ? Colors.white : Colors.black87,
                               fontSize: 15,
                               height: 1.5,
                               //textDirection: isArabicText ? TextDirection.rtl : TextDirection.ltr,
                             ),
                           ),
                         );
                       }).toList(),
                     ),
                   ),
                 );
               },
             ),
           ),
           _buildInputField(),
         ],
       ),
     );
   }

   Widget _buildWelcomeMessage() {
     return Padding(
       padding: const EdgeInsets.all(16),
       child: Column(
         children: [
           Text(
             "How can i help you? 🤖",
             style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFB5B5B5)),
           ),
           SizedBox(height: 20),
           Container(
             padding: EdgeInsets.all(12),
             decoration: BoxDecoration(color: Color(0xFFF4F4F4), borderRadius: BorderRadius.circular(8)),
             child: Text(
               "you can ask about any skin disease and i will give you more information about it. 💡",
               style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFFB5B5B5)),
               textAlign: TextAlign.center,
             ),
           ),
           SizedBox(height: 40),
         ],
       ),
     );
   }

   Widget _buildInputField() {
     return Padding(
       padding: const EdgeInsets.all(8.0),
       child: Container(
         margin: EdgeInsets.all(8),
         padding: EdgeInsets.symmetric(horizontal: 12),
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.circular(12),
           boxShadow: [
             BoxShadow(
               color: Colors.black26,
               blurRadius: 10,
               spreadRadius: 1,
               offset: Offset(0, 4),
             ),
           ],
         ),
         child: Row(
           children: [
             Expanded(
               child: TextField(
                 controller: _messageController,
                 decoration: InputDecoration(
                   hintText: "Write your message...",
                   border: InputBorder.none,
                 ),
                 textDirection: TextDirection.rtl,
                 onSubmitted: (value) => sendMessage(value),
               ),
             ),
             IconButton(
               icon: Icon(Icons.send_outlined, color: Color(0xFF6D838E)),
               onPressed: () => sendMessage(_messageController.text),
             ),
           ],
         ),
       ),
     );
   }
 }

