
 import 'dart:async';
 import 'dart:convert';
 import 'package:flutter/material.dart';
 import 'package:http/http.dart' as http;
 import 'package:shared_preferences/shared_preferences.dart';
 import 'package:google_fonts/google_fonts.dart';

 import '../ApiConstants.dart';
import '../registration/login.dart';
 String cleanText(String text) {
   text = text.replaceAll(r'\n', '\n');
   text = text.replaceAll(r'\t', ' ');
   text = text.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
   text = text.replaceAll(RegExp(r'_{1,2}'), '');
   text = text.replaceAll(RegExp(r'>'), '');
   text = text.replaceAll(RegExp(r'[#]+'), '');
   text = text.replaceAll(RegExp(r'[+]'), '');
   return text;
 }

 bool isArabic(String text) {
   final arabicRegex = RegExp(r'[\u0600-\u06FF]');
   return arabicRegex.hasMatch(text);
 }

 List<TextSpan> parseTextToSpans(String text, TextStyle baseStyle) {
   final lines = text.split('\n');
   List<TextSpan> spans = [];

   for (var line in lines) {
     if (line.trim().startsWith('- ') || line.trim().startsWith('* ')) {
       line = line.replaceFirst(RegExp(r'[-*]\s'), '• ');
       spans.add(TextSpan(text: line, style: baseStyle));
       spans.add(TextSpan(text: '\n'));
       continue;
     }

     final boldRegex = RegExp(r'\*\*(.*?)\*\*');
     if (boldRegex.hasMatch(line)) {
       int lastIndex = 0;
       line = line.replaceAllMapped(boldRegex, (match) {
         final before = line.substring(lastIndex, match.start);
         final boldText = match.group(1)!;
         lastIndex = match.end;
         spans.add(TextSpan(text: before, style: baseStyle));
         spans.add(TextSpan(
           text: boldText,
           style: baseStyle.copyWith(fontWeight: FontWeight.bold),
         ));
         return '';
       });
       if (lastIndex < line.length) {
         spans.add(TextSpan(text: line.substring(lastIndex), style: baseStyle));
       }
     } else {
       spans.add(TextSpan(text: line, style: baseStyle));
     }
     spans.add(TextSpan(text: '\n'));
   }

   return spans;
 }

 class ChatBotScreen extends StatefulWidget {
   @override
   _ChatBotScreenState createState() => _ChatBotScreenState();
 }

 class _ChatBotScreenState extends State<ChatBotScreen> {
   final TextEditingController _messageController = TextEditingController();
   final ScrollController _scrollController = ScrollController();
   List<Map<String, dynamic>> messages = [];
   bool showWelcomeMessage = true;

   Future<void> sendMessage(String message) async {
     if (message.trim().isEmpty) return;

     setState(() {
       messages.add({
         "sender": "user",
         "text": message,
         "isArabic": isArabic(message)
       });
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
             "text": "Please log in to use the chatbot.",
             "isArabic": false
           });
         });
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => Login()),
         );
         return;
       }

       final response = await http.post(
         Uri.parse(ApiConstants.chatpot),
         headers: {
           "Content-Type": "application/json; charset=UTF-8",
           "Authorization": "Bearer $token",
         },
         body: jsonEncode({"message": message}),
       ).timeout(Duration(seconds: 30), onTimeout: () {
         throw TimeoutException("The server request timed out.");
       });

       if (response.statusCode == 200) {
         final jsonResponse = json.decode(utf8.decode(response.bodyBytes));
         setState(() {
           String botResponse = cleanText(jsonResponse["bot_response"] ?? "No response available.");
           messages.add({
             "sender": "bot",
             "text": botResponse,
             "isArabic": isArabic(botResponse)
           });
         });
       } else if (response.statusCode == 401) {
         setState(() {
           messages.add({
             "sender": "bot",
             "text": "Your session has expired. Please log in again.",
             "isArabic": false
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
             "text": "Server error: ${response.statusCode}. Please try again later.",
             "isArabic": false
           });
         });
       }
     } catch (e) {
       setState(() {
         messages.add({
           "sender": "bot",
           "text": "Unable to connect to the server. Please check your internet connection.",
           "isArabic": false
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
         title: Text(
           "Chatbot",
           style: GoogleFonts.poppins(color: Colors.black),
         ),
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
                 final isArabic = msg["isArabic"] as bool;
                 final textStyle = GoogleFonts.poppins(
                   color: isUser ? Colors.white : Colors.black87,
                   fontSize: 15,
                   height: 1.5,
                 );

                 return Align(
                   alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                   child: Container(
                     constraints: BoxConstraints(
                       maxWidth: isUser
                           ? MediaQuery.of(context).size.width * 0.6
                           : MediaQuery.of(context).size.width * 0.80,//عرض رساله الرد
                     ),
                     margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     padding: EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       color: isUser ? Color(0xFF6D838E) : Colors.grey[200],
                       borderRadius: BorderRadius.circular(16),
                     ),
                     child: RichText(
                       textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                       text: TextSpan(
                         children: parseTextToSpans(msg["text"]!, textStyle),
                       ),
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
             "How can I assist you today? 🤖",
             style: GoogleFonts.tajawal(
               fontSize: 22,
               fontWeight: FontWeight.w600,
               color: Color(0xFFB5B5B5),
             ),
             textDirection: TextDirection.ltr,
           ),
           SizedBox(height: 20),
           Container(
             padding: EdgeInsets.all(12),
             decoration: BoxDecoration(
               color: Color(0xFFF4F4F4),
               borderRadius: BorderRadius.circular(8),
             ),
             child: Text(
               "Feel free to ask about any skin condition or skincare tips, and I'll provide detailed information. 💡",
               style: GoogleFonts.tajawal(
                 fontSize: 14,
                 color: Color(0xFFB5B5B5),
               ),
               textAlign: TextAlign.center,
               textDirection: TextDirection.ltr,
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
           borderRadius: BorderRadius.circular(16),
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
                   hintText: "Type your message...",
                   border: InputBorder.none,
                 ),
                 textDirection: isArabic(_messageController.text) ? TextDirection.rtl : TextDirection.ltr,
                 onChanged: (value) {
                   setState(() {});
                 },
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
