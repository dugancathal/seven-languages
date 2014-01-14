SGML

Fetcher := Object clone do(
  url ::= "";

  with := method(url,
    newb := clone;
    newb setUrl(url);
    newb)

  fetch := method(
    URL with(url) fetch)

  getTitle := method(
    fetch asXML elementsWithName("title") at(0))
)

"About to start fetchers" println

f := File with("langpages.csv") openForReading 
urls := f readLines
f close

"Asynchronous" println
start := Date clone

futures := urls map(url, Fetcher clone with(url) @getTitle)
"This will execute before they are fetched" println
futures foreach(result, result println)

((Date now) - start) println


