import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimationManager {
  // Widget da animação, que será exibido com base em um valor externo
  Widget animationWidget(bool showAnimation) {
    if (!showAnimation) {
      return SizedBox.shrink(); // Não exibe nada quando a animação não for necessária
    }

    return SizedBox(
      width: 200,
      height: 200,
      child: RiveAnimation.asset(
        'animations/shopping_cart.riv',
        animations: ['Animation 1'], 
        fit: BoxFit.cover,
      ),
    );
  }
}
