# Assignment 6

Implement an Erlang/OTP application that has a POST /capture method which receives input requests like the attached file Test.xml. 
If PROD_COVER_GTIN, PROD_NAME can be captured from a request then the request is accepted, the values of PROD_COVER_GTIN, PROD_NAME and additional values of PROD_DESC, BRAND_OWNER_NAME 
are written to external CSV file with 4 columns: GTIN,NAME,DESC,COMPANY. 

NOTE: if PROD_DESC, BRAND_OWNER_NAME are missed in an input request then empty values will be saved to the CSV.

Usage:

```
1> application:start(assignment_6).
ok

...

$ curl -vv -X POST -d @Text.xml --header "Content-Type: application/soap+xml" http://127.0.0.1:9090/capture
* Hostname was NOT found in DNS cache
*   Trying 127.0.0.1...
* Connected to 127.0.0.1 (127.0.0.1) port 9090 (#0)
> POST /capture HTTP/1.1
> User-Agent: curl/7.38.0
> Host: 127.0.0.1:9090
> Accept: */*
> Content-Type: application/soap+xml
> Content-Length: 8488
> Expect: 100-continue
>
< HTTP/1.1 100 Continue
< HTTP/1.1 204 No Content
* Server Cowboy is not blacklisted
< server: Cowboy
< date: Fri, 16 Sep 2016 18:23:08 GMT
< content-length: 0
< content-type: text/plain
<
* Connection #0 to host 127.0.0.1 left intact
$ cat output.csv
4600209001493,"""Малютка"™","смесь сухая молочная ""малютка 1 плюс"","ОАО ""Детское питание "Истра-Нутриция""
```
