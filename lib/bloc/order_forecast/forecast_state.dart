import 'package:equatable/equatable.dart';

class ForecastState extends Equatable {
 final int? index;
 final List<double> rowHeights;

  const ForecastState( {
    this.index,
    required this.rowHeights
  });

  @override
  List<Object?> get props => [index,rowHeights];

 ForecastState copyWith({
    int? index,
   List<double>? rowHeights,
  }) {
    return  ForecastState (
        index: index ?? this.index,
      rowHeights: rowHeights ?? this.rowHeights
    );
  }
}

