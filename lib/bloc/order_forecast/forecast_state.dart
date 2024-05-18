import 'package:equatable/equatable.dart';

class ForecastState extends Equatable {
 final int? index;
 final bool isExpanded;
 final List<double> rowHeights;

  const ForecastState( {
    this.index,
    required this.rowHeights,
    required this.isExpanded
  });

  @override
  List<Object?> get props => [index,rowHeights,isExpanded];

 ForecastState copyWith({
    int? index,
   List<double>? rowHeights,
   bool? isExpanded,

 }) {
    return  ForecastState (
        index: index ?? this.index,
      rowHeights: rowHeights ?? this.rowHeights,
      isExpanded: isExpanded ?? this.isExpanded
    );
  }
}

