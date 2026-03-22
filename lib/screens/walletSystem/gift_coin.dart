import 'package:flutter/material.dart';

class GiftCoinPage extends StatelessWidget {
  const GiftCoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift @JaneDoe'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User info section
              const UserInfoSection(),

              const Divider(height: 40, thickness: 1),

              // Points selection
              const Text(
                'Select points',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              PointsGrid(),

              const SizedBox(height: 24),

              // Account password
              const Text(
                'Account password',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '**********',
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle continue action
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('CONTINUE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'John Doe',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              '\$ 50,000 CAPP',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(width: 16),
            Text(
              '\$ 0.585 USD',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

class PointsGrid extends StatelessWidget {
  final List<Map<String, dynamic>> pointsOptions = [
    {'points': '\$50', 'usd': '\$1 USD'},
    {'points': '\$200', 'usd': '\$4 USD'},
    {'points': '\$450', 'usd': '\$8.5 USD'},
    {'points': '\$700', 'usd': '\$28 USD'},
    {'points': '\$1400', 'usd': '\$70 USD'},
    {'points': '\$3500', 'usd': '\$140 USD'},
    {'points': '\$7000', 'usd': '\$14 USD'},
    {'points': 'Custom', 'usd': 'Enter Amount'},
  ];

  PointsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: pointsOptions.length,
      itemBuilder: (context, index) {
        return PointsOptionCard(
          points: pointsOptions[index]['points'],
          usd: pointsOptions[index]['usd'],
          isCustom: index == pointsOptions.length - 1,
        );
      },
    );
  }
}

class PointsOptionCard extends StatelessWidget {
  final String points;
  final String usd;
  final bool isCustom;

  const PointsOptionCard({
    super.key,
    required this.points,
    required this.usd,
    this.isCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              points,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCustom ? Colors.blue : Colors.black,
              ),
            ),
            Text(
              usd,
              style: TextStyle(
                fontSize: 14,
                color: isCustom ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
