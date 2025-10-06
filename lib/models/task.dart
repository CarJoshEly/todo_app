class Task {
  String title;
  String description;
  String date;
  bool done;

  Task(this.title, {this.description = "", this.date = "", this.done = false});
}