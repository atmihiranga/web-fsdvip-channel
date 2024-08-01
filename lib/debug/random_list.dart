import 'dart:math';

dynamic getRandomItem(List<dynamic> myList) {
  Random random = Random();
  dynamic randomItem = myList[random.nextInt(myList.length)];

  return randomItem;
}
