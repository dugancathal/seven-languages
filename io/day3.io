#!/usr/bin/env io

Object printHeader := method(header, 
  writeln
  writeln
  writeln
  "********************" println;
  header println;
  "********************" println)

printHeader("Indented XML")

Sequence * := method(num,
  tmp := self asMutable;
  if(num == 0,
    "",
    for(i, 0, num - 1, tmp = tmp .. self)))
Builder := Object clone
Builder callStackHeight := 0
Builder forward := method(
  tagName := call message name;
  writeln(" " * (self callStackHeight * 2), "<", tagName, ">");
  self callStackHeight = self callStackHeight + 1;
  call message arguments foreach(tag,
    content := self doMessage(tag);
    if(content type == "Sequence", writeln(" " * (self callStackHeight * 2), content)));
    self callStackHeight = callStackHeight - 1;
  writeln(" " * (self callStackHeight * 2), "</", tagName, ">"))

Builder ul(li("Testing"), li("Testing"), li(a("I'm just suggesting")))

printHeader("Lists with Brackets")
#curlyBrackets := method(r := List clone; call message arguments foreach(arg, r append(arg)); r)
#{1,2,3,4} println

printHeader("XML with Attritude")
OperatorTable addAssignOperator(":", "atPutItem")
curlyBrackets := method(
  r := Map clone
  call message arguments foreach(arg,
    r doString(arg code)); r)
  
Map atPutItem := method(
  self atPut(
    call evalArgAt(0) asMutable removePrefix("\"") removeSuffix("\""),
    call evalArgAt(1)))

AttributeBuilder := Builder clone
AttributePrinter := Object clone
AttributePrinter print := method(m,
  m map(k, v, "#{k}=\"#{v}\"" interpolate) join(" ")
)
AttributeBuilder forward := method(
  arg1 := call evalArgAt(0)
  tagName := call message name;

  attrs := if(arg1 type == "Map",
    AttributePrinter print(arg1), "");

  writeln(" " * (self callStackHeight * 2), "<", tagName, " #{attrs}" interpolate asMutable rstrip, ">");

  self callStackHeight = self callStackHeight + 1;
  call message arguments foreach(tag,
    content := self doMessage(tag);
    if(content type == "Sequence", writeln(" " * (callStackHeight * 2), content)));
  self callStackHeight = callStackHeight - 1;
  writeln(" " * (callStackHeight * 2), "</", tagName, ">"))
    
AttributeBuilder ul({"class": "listing", "id": "contents"}, li("content"))
