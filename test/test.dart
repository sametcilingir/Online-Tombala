import 'package:flutter_test/flutter_test.dart';

void main(List<String> args) {
  test("listTest", () {
    List<int> allNumbersListForCard = List<int>.generate(99, (i) => i + 1);
    var rangeOf91and99Numbers = allNumbersListForCard.sublist(90, 99)
      ..shuffle();

    print(rangeOf91and99Numbers[0]);

    List<int> cardNumbersList = [];

    for (var i = 0; i < 2; i++) {
      cardNumbersList.add(rangeOf91and99Numbers[i]);
      cardNumbersList.add(rangeOf91and99Numbers[i]);
    print(cardNumbersList);

    }
  });
}
