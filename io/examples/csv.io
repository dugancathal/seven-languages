OperatorTable addOperator("[]", 4)

CsvRow := Object clone do(
  squareBrackets := method(key, map at(key))
    from := method(headers, str,
    cols := str split(",");
    cols foreach(i, cell,
      self setSlot(headers at(i), cell))
    self)
)

CsvParser := Object clone do(
  filename := method(self type asLowercase .. ".csv")
  fileContent := method(
    f := File with(self filename) openForReading
    content := f contents
    f close
    content)

  read := method(
    rows := self fileContent split("\n"); 
    headers := rows removeFirst split(",");
    rows map(line,
      CsvRow clone from(headers, line)))
)

Testing := CsvParser clone
csv := Testing read


# Print the table
"Store, Orange Sales" println
csv foreach(row,
  writeln(row Store, ", ", row Oranges)
)
