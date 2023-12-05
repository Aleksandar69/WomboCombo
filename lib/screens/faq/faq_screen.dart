import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  static const routeName = '/faq';

  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'What is the "Combos" screen?',
      answer:
          'There are multiple options if you wish to train with WomboCombo. You can use "Combos" option in order to train your combos level by level, with a demonstrative video of the combo being played simultanously.',
    ),
    FAQItem(
      question: 'What is "Think Quick" screen?',
      answer:
          '"Think Quick" allows you to choose the difficulty which you want to train at, as well as custom timer with custom amount of runds. This option will have a voice commands which will tell you which punches to use. This requires a focus and is great for coordination training.',
    ),
    FAQItem(
      question: 'How do I know which number is which punch?',
      answer:
          'The mapping used for punches is a generic one used in boxing world. When opening "Think Quick" option, the first screen will let you know which punches map to which number.',
    ),
    FAQItem(
      question: 'Can I chat with my friends inside the app?',
      answer:
          'Yes! Our in-app chat is available. It can be accessed by going to your friend\'s profile and selecting "Send Message", or by going to your "Friend List" and sending a message from there!',
    ),
    FAQItem(
      question: 'Who can see my recorded videos?',
      answer:
          'Everyone using the app can see and comment on your recorded videos.',
    ),
    FAQItem(
      question: 'How do I earn points?',
      answer:
          'You can earn points by practicing "Think Quick" or "Customize Combos" module. The points added will be dependant on the time each round takes, difficulty as well as the number of rounds.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpansionTile(
            title: Text(
              faqItems[index].question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faqItems[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}
