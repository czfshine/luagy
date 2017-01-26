-- load the http module
http = require("socket.http")
ltn12 = require("ltn12")
ltn12.
-- Requests information about a document, without downloading it.
-- Useful, for example, if you want to display a download gauge and need
-- to know the size of the document in advance

t={}
r, c, h = http.request {
  method = "POST",
  url = "https://api.github.com/markdown?text=1",
  source=ltn12.source.string("?text=1"),
  sink = ltn12.sink.table(t)
}

print(c)
print(r)
require"luagy.print.printtable"
ptt(h)
ptt(t)

-- r is 1, c is 200, and h would return the following headers:
-- h = {
--   date = "Tue, 18 Sep 2001 20:42:21 GMT",
--   server = "Apache/1.3.12 (Unix)  (Red Hat/Linux)",
--   ["last-modified"] = "Wed, 05 Sep 2001 06:11:20 GMT",
--   ["content-length"] = 15652,
--   ["connection"] = "close",
--   ["content-Type"] = "text/html"
-- }


{"text": "Hello world github/linguist#1 **cool**, and #1!","mode": "gfm","context": "github/gollum"}