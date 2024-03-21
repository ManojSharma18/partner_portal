import 'package:equatable/equatable.dart';

abstract class ForeCastEvent extends Equatable {
  const ForeCastEvent();

  @override
  List<Object?> get props => [];
}

class ItemHeightEvent extends ForeCastEvent {
  final int index;
  final List<double> rowHeights;
  const ItemHeightEvent(this.index,this.rowHeights);
}
