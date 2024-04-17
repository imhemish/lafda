import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20), 
          Center(
            child: CircleAvatar(
              radius: 50,
              //backgroundImage: AssetImage('assets/avatar.jpg'),
            ),
          ),
          SizedBox(height: 20), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: TextField(
                controller: _controllers[0],
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(height: 20), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FractionallySizedBox(
              widthFactor: 0.2,
              child: ElevatedButton(
                onPressed: () {
                 
                },
                child: Text('Save'),
              ),
            ),
          ),
          SizedBox(height: 20), 
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 2),
            painter: DiagonalPainter(),
          ),
          SizedBox(height: 20), 
          Center(
            child: Text(
              'Real Identity Card',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FractionallySizedBox(
              widthFactor: 0.3, 
              child: ElevatedButton(
                onPressed: () {
                 
                },
                child: Text('Upload Photo'),
              ),
            ),
          ),
          SizedBox(height: 20), 
          Column(
            children: [
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: TextField(
                          controller: _controllers[i],
                          decoration: InputDecoration(
                            labelText: _getFieldLabel(i),
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              SizedBox(height: 20), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FractionallySizedBox(
                  widthFactor: 0.2,
                  child: ElevatedButton(
                    onPressed: () {
                     
                    },
                    child: Text('Save'),
                  ),
                ),
              ),
               SizedBox(height: 20), 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '*You can only upload your photo and real ID card. It will not affect your identity on app and you can still chat anonymously.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFieldLabel(int index) {
    switch (index) {
      case 0:
        return 'Name';
      case 1:
        return 'About';
      case 2:
        return 'Bio';
      case 3:
        return 'Contact';
      default:
        return '';
    }
  }
}

class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    const double startX = 0;
    const double startY = 0;
    final double endX = size.width;
    final double endY = size.height;

    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}