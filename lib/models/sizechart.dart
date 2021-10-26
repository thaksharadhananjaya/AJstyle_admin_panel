class SizeChart {
  String data;
  int isLabel;

  SizeChart(this.data, this.isLabel);

  
  Map<String, dynamic> toJson() => {
        '"data"': '"$data"',
        '"isLabel"': '"$isLabel"',
      };
}
