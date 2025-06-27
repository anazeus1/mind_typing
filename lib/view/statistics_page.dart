import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  // TODO: Replace with actual data from your data source
  final List<Map<String, dynamic>> _typingSessions = [
    {
      'date': '2024-03-20',
      'wpm': 45,
      'accuracy': 95,
      'duration': '5:00',
    },
    {
      'date': '2024-03-19',
      'wpm': 42,
      'accuracy': 92,
      'duration': '3:30',
    },
    {
      'date': '2024-03-18',
      'wpm': 38,
      'accuracy': 88,
      'duration': '4:15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            Text(
              'Recent Sessions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildSessionsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard(
          'Average WPM',
          '42',
          Icons.speed,
          Colors.blue,
        ),
        _buildSummaryCard(
          'Best WPM',
          '45',
          Icons.emoji_events,
          Colors.amber,
        ),
        _buildSummaryCard(
          'Accuracy',
          '92%',
          Icons.percent,
          Colors.green,
        ),
        _buildSummaryCard(
          'Total Practice',
          '12:45',
          Icons.timer,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsList() {
    return ListView.builder(
      itemCount: _typingSessions.length,
      itemBuilder: (context, index) {
        final session = _typingSessions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '${session['wpm']}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text('WPM: ${session['wpm']}'),
            subtitle: Text(
              'Accuracy: ${session['accuracy']}% • Duration: ${session['duration']}',
            ),
            trailing: Text(
              session['date'],
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      },
    );
  }
}
