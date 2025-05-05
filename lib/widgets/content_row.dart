import 'package:flutter/material.dart';

class ContentRow extends StatefulWidget {
  final String title;

  const ContentRow({super.key, required this.title});

  @override
  _ContentRowState createState() => _ContentRowState();
}

class _ContentRowState extends State<ContentRow> {
  int _hoveredIndex = -1;

  final List<String> movieImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT00aWj_pfl9mWj6NrZCIJ3y_2itdzAtgQa-A&s',
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_CJGsDKFqjpzr7qHzLIAFdBHU8SzHA5fLdQ&s",
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGs4G014EanIiUA4XYTHORC41zT5WeAv185w&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMXBMbpYG0XOauMH-hTDnGUcbYEgaHwBFbsg&s',
    'https://dnm.nflximg.net/api/v6/BvVbc2Wxr2w6QuoANoSpJKEIWjQ/AAAAQYUq_zf19ovHF8C5YiQiDZFQVr8TalWUTMO7OrgYhzrD_UjHotsqkV9nSJK8S_oy2BO0FWj3eUmPFt8yyDQ7tx4LwDMF2IwJRKZvHtm67u1jHDPL0whBbIep5Jf5nsbN6KlR8-jgQ9ohg3szWKIS49g1.jpg?r=386',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAfEyhddcvsLmIynPIL2Twjej4wyzq1R1ybQ&s'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieImages.length,
            itemBuilder: (context, index) {
              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = index),
                onExit: (_) => setState(() => _hoveredIndex = -1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.all(8),
                  height: _hoveredIndex == index ? 160 : 140,
                  width: _hoveredIndex == index ? 260 : 220,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            movieImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (_hoveredIndex == index)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.7),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.play_arrow, color: Colors.white),
                                  Icon(Icons.add, color: Colors.white),
                                  Icon(Icons.thumb_up_outlined,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
