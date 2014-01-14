WebResponse := Object clone do(
  OK := "HTTP/1.0 200 OK\n\n";
  NOT_FOUND := "HTTP/1.0 400 NOT FOUND\n\n";

  respond := method(socket, server,
    path := pathFromSocket(socket)
    if(path == nil, return)
    data := server cache find(path)

    if(data,
      socket streamWrite(WebResponse OK)
      socket streamWrite(data)
    ,
      socket streamWrite(WebResponse NOT_FOUND)
    )

    socket close;
  )

  pathFromSocket := method(socket,
    socket streamReadNextChunk;
    if(socket isOpen == false, return)
    socket readBuffer betweenSeq("GET ", " HTTP")
  )
)

WebCache := Object clone do(
  cache := Map clone

  find := method(path,
    cache atIfAbsentPut(path,
      writeln("caching ", path)
      f := File clone with("tmp" .. path);
      if(f exists, f contents, nil);
    )
  )
)

WebServer := Server clone do(
  setPort(7777);
  socket setHost("127.0.0.1");
  cache := WebCache clone
  handleSocket := method(socket,
    WebResponse clone respond(socket, self))
) start
