# Assignment 8

Implement a GTIN-14 validator as an Erlang module function validate({gtin, Value}) -> ok |
{error, Error}, Value is iolist() or binary(). The related specification can be found
here: http://www.gs1.org/barcodes-epcrfid-id-keys/gs1-general-specifications




Usage:
```
1> assignment_8:validate({gtin, <<"00012345600012>>}).
ok
2> assignment_8:validate({gtin, <<"99999999999999">>}).
{error,checksum_mismatch}
```