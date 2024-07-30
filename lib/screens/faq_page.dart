import 'package:flutter/material.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/constants/constants.dart';
import 'package:todo_app/widgets/app_bar.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        "question": "What is the purpose of the ToDo app?",
        "answer":
            "The ToDo app helps you organize tasks, set reminders, and track your progress to increase productivity and manage your time effectively."
      },
      {
        "question": "Is the ToDo app free to use?",
        "answer":
            "Yes, the basic version of the ToDo app is free to use. Some advanced features may require a premium subscription."
      },
      {
        "question": "How do I create an account?",
        "answer":
            "You can create an account by clicking on the 'Sign Up' button on the login screen and filling out the required information."
      },
      {
        "question": "How do I add a new task?",
        "answer":
            "To add a new task, click on the 'Add Task' button, enter the task details, and save it."
      },
      {
        "question": "Can I set reminders for my tasks?",
        "answer":
            "Yes, you can set reminders by selecting the 'Reminder' option when creating or editing a task."
      },
      {
        "question": "How do I mark a task as complete?",
        "answer":
            "To mark a task as complete, simply check the box next to the task or swipe it to the right."
      },
      {
        "question":
            "My tasks are not syncing across devices. What should I do?",
        "answer":
            "Ensure you are logged into the same account on all devices and check your internet connection. If the issue persists, try logging out and logging back in."
      },
      {
        "question": "How do I contact support?",
        "answer":
            "You can contact support by going to the 'Help & Support' section in the app's settings and selecting 'Contact Us.'"
      },
      {
        "question": "Is my data safe with the ToDo app?",
        "answer":
            "Yes, we prioritize your privacy and security. Your data is encrypted and securely stored."
      },
      {
        "question": "Can I export my tasks?",
        "answer":
            "Yes, you can export your tasks by going to the settings menu and selecting the 'Export Data' option."
      }
    ];

    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: const AppBarBuilded(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            final faq = faqs[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: EasyFaq(
                question: faq['question']!,
                answer: faq['answer']!,
              ),
            );
          },
        ),
      ),
    );
  }
}
