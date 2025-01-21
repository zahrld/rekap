import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/survey_model.dart';
import '../services/survey_service.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final User user;

  const CalendarScreen({super.key, required this.user});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentDate;
  late int _selectedDay;
  late int _currentMonth;
  late int _currentYear;
  Map<String, bool> noteExist = {};
  final SurveyService _surveyService = SurveyService();
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _currentMonth = _currentDate.month;
    _currentYear = _currentDate.year;
    _selectedDay = _currentDate.day;
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    try {
      final surveys = await _surveyService.getSurveys();
      setState(() {
        activities = surveys;
        noteExist.clear();
        for (var activity in activities) {
          String dateKey = '${activity.tanggal.day}-${activity.tanggal.month}-${activity.tanggal.year}';
          noteExist[dateKey] = true;
        }
      });
    } catch (e) {
      print('Error loading activities: $e');
    }
  }

  int _daysInMonth(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  void _changeMonth(int direction) {
    setState(() {
      _currentMonth += direction;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      } else if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
    });
  }

  List<DateTime> _getDaysInMonth() {
    List<DateTime> days = [];
    
    DateTime firstDayOfMonth = DateTime(_currentYear, _currentMonth, 1);
    int firstWeekday = firstDayOfMonth.weekday % 7;
    
    DateTime lastMonth = DateTime(_currentYear, _currentMonth - 1);
    int daysInLastMonth = _daysInMonth(_currentMonth - 1, _currentYear);
    for (int i = 0; i < firstWeekday; i++) {
      days.insert(0, DateTime(lastMonth.year, lastMonth.month, daysInLastMonth - i));
    }
    
    for (int i = 1; i <= _daysInMonth(_currentMonth, _currentYear); i++) {
      days.add(DateTime(_currentYear, _currentMonth, i));
    }
    
    int remainingDays = 42 - days.length;
    DateTime nextMonth = DateTime(_currentYear, _currentMonth + 1);
    for (int i = 1; i <= remainingDays; i++) {
      days.add(DateTime(nextMonth.year, nextMonth.month, i));
    }
    
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalender Kegiatan',
          style: TextStyle(
            color: Color(0xFF396BB5),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF396BB5)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 8.0),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    '${DateFormat('MMMM').format(DateTime(_currentYear, _currentMonth))}-$_currentYear',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _changeMonth(1),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  Text('Min', style: TextStyle(color: Colors.red)),
                  Text('Sen'),
                  Text('Sel'),
                  Text('Rab'),
                  Text('Kam'),
                  Text('Jum'),
                  Text('Sab'),
                ],
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: GridView.builder(
                  itemCount: 42,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (_, i) {
                    DateTime currentDate = _getDaysInMonth()[i];
                    int day = currentDate.day;
                    bool isCurrentMonth = currentDate.month == _currentMonth;
                    bool isToday = currentDate.year == DateTime.now().year &&
                        currentDate.month == DateTime.now().month &&
                        currentDate.day == DateTime.now().day;
                    bool isSelected = isCurrentMonth && _selectedDay == day;
                    
                    String dateKey = '${currentDate.day}-${currentDate.month}-${currentDate.year}';
                    bool hasActivity = noteExist[dateKey] ?? false;
                    
                    bool isSunday = currentDate.weekday == DateTime.sunday;

                    return GestureDetector(
                      onTap: () {
                        if (isCurrentMonth) {
                          setState(() {
                            _selectedDay = day;
                          });
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isToday && isCurrentMonth
                              ? const Color(0xFF396BB5)
                              : isSelected && isCurrentMonth
                                  ? Colors.blue.withOpacity(0.3)
                                  : Colors.transparent,
                          border: hasActivity && isCurrentMonth
                              ? Border.all(color: Colors.green, width: 2)
                              : null,
                        ),
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: !isCurrentMonth 
                                ? Colors.grey.withOpacity(0.5)
                                : isToday
                                    ? Colors.white
                                    : isSunday 
                                        ? Colors.red
                                        : Colors.black,
                            fontWeight: (isSelected || isToday) && isCurrentMonth 
                                ? FontWeight.bold 
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Text(
                'Pilih tanggal untuk melihat kegiatan',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 