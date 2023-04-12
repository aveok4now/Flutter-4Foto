class ChangeDescription {
  final Function undo;
  final Function redo;
  final String name;

  ChangeDescription(this.undo, this.redo, this.name);
}
