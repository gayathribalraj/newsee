import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:newsee/widgets/side_navigation.dart';

// === Added Constants ===
const double chartTopPadding = 16.0;
const double chartVerticalPadding = 24.0;
const double titleFontSize = 20.0;
const double labelFontSize = 12.0;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;
  String _selectedChartType = 'Bar';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _chartTypes = ['Bar', 'Combo', 'Line', 'Donut', 'Pie'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _isLoading = true;
      _currentPage = index;
      _animationController.reset();
      _animationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidenavigationbar(),
      appBar: AppBar(
        title: Text('Dashboard',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.teal,
        actions: [
          DropdownButton<String>(
            value: _selectedChartType,
            items: _chartTypes.map((String type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type,style: TextStyle(color: Colors.white) ),
                
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedChartType = newValue!;
                _animationController.reset();
                _animationController.forward();
              });
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildTargetVsAchievedReport(),
              _buildLeadStatusReport(),
              _buildBranchWiseRevenueReport(),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildTargetVsAchievedReport() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(chartTopPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target vs Achieved',
              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: chartVerticalPadding),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: chartVerticalPadding),
                child: _buildChart(
                  data: [
                    ChartData('Jan', 100, 80),
                    ChartData('Feb', 120, 90),
                    ChartData('Mar', 110, 95),
                    ChartData('Apr', 130, 100),
                  ],
                  series1Name: 'Target',
                  series2Name: 'Achieved',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadStatusReport() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(chartTopPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lead Status',
              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: chartVerticalPadding),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: chartVerticalPadding),
                child: _buildChart(
                  data: [
                    ChartData('New', 40, 0),
                    ChartData('Contacted', 35, 0),
                    ChartData('Qualified', 30, 0),
                    ChartData('Closed', 20, 0),
                  ],
                  series1Name: 'Count',
                  singleSeries: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchWiseRevenueReport() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(chartTopPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Branch-wise Revenue',
              style: TextStyle(fontSize: titleFontSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: chartVerticalPadding),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: chartVerticalPadding),
                child: _buildChart(
                  data: [
                    ChartData('Branch A', 200, 0),
                    ChartData('Branch B', 150, 0),
                    ChartData('Branch C', 180, 0),
                    ChartData('Branch D', 170, 0),
                  ],
                  series1Name: 'Revenue',
                  singleSeries: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart({
    required List<ChartData> data,
    required String series1Name,
    String? series2Name,
    bool singleSeries = false,
  }) {
    switch (_selectedChartType) {
      case 'Bar':
        return BarChart(
          BarChartData(
            barGroups: singleSeries
                ? data.asMap().entries.map((e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(toY: e.value.value1, color: Colors.blue, width: 20),
                      ],
                    )).toList()
                : data.asMap().entries.map((e) => BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(toY: e.value.value1, color: Colors.blue, width: 10),
                        BarChartRodData(toY: e.value.value2, color: Colors.red, width: 10),
                      ],
                    )).toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[value.toInt()].category,
                      style: const TextStyle(fontSize: labelFontSize),
                    ),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
          swapAnimationDuration: const Duration(milliseconds: 500),
        );
      case 'Combo':
        return BarChart(
          BarChartData(
            barGroups: data.asMap().entries.map((e) => BarChartGroupData(
                  x: e.key,
                  barRods: singleSeries
                      ? [
                          BarChartRodData(toY: e.value.value1, color: Colors.blue, width: 20),
                        ]
                      : [
                          BarChartRodData(
                            toY: e.value.value1 + e.value.value2,
                            rodStackItems: [
                              BarChartRodStackItem(0, e.value.value1, Colors.blue),
                              BarChartRodStackItem(e.value.value1, e.value.value1 + e.value.value2, Colors.red),
                            ],
                            width: 20,
                          ),
                        ],
                )).toList(),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[value.toInt()].category,
                      style: const TextStyle(fontSize: labelFontSize),
                    ),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
          swapAnimationDuration: const Duration(milliseconds: 500),
        );
      case 'Line':
        return LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value1)).toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 4,
                dotData: const FlDotData(show: false),
              ),
              if (!singleSeries)
                LineChartBarData(
                  spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.value2)).toList(),
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                  dotData: const FlDotData(show: false),
                ),
            ],
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      data[value.toInt()].category,
                      style: const TextStyle(fontSize: labelFontSize),
                    ),
                  ),
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
          ),
        );
      case 'Donut':
      case 'Pie':
        return Padding(
          padding: const EdgeInsets.only(bottom: 230),
          child: PieChart(
            PieChartData(
              sections: data.asMap().entries.map((e) => PieChartSectionData(
                    value: e.value.value1,
                    title: e.value.category,
                    color: Colors.primaries[e.key % Colors.primaries.length],
                    radius: _selectedChartType == 'Donut' ? 70 : 80,
                    titleStyle: const TextStyle(color: Colors.white, fontSize: labelFontSize),
                  )).toList(),
              centerSpaceRadius: _selectedChartType == 'Donut' ? 40 : 0,
              sectionsSpace: 2,
            ),
            swapAnimationDuration: const Duration(milliseconds: 500),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class ChartData {
  final String category;
  final double value1;
  final double value2;

  ChartData(this.category, this.value1, this.value2);
}
