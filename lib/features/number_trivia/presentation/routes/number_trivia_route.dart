import 'package:flutter/material.dart';

import '../widgets/number_trivia_route_body.dart';

class NumberTriviaRoute extends StatelessWidget {
  static const routeName = '/';
  const NumberTriviaRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade900,
        title: const Text('Reso Coder Number Trivia'),
      ),
      body: const SingleChildScrollView(
        child: NumberTriviaRouteBody(),
      ),
    );
  }
}
