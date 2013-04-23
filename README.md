# api.sublimevideo.net

Lightweight application based on [Grape](https://github.com/intridea/grape) that handles the SublimeVideo Service's Public API: https://api.sublimevideo.net

* OAuth authentication is handled by [`Grape::Middleware::Auth::OAuth2`](https://github.com/intridea/grape/blob/master/lib/grape/middleware/auth/oauth2.rb).
* Views are handled by [`Grape::Rabl`](https://github.com/LTe/grape-rabl).
* No database, private API calls to https://my.sublimevideo.net for `Oauth2Token`, `User` and `Site`.

##Schema

All API access is over HTTPS, and accessed from the api.sublimevideo.net domain. All data is sent and received as JSON.

```bash
$ curl -i https://api.sublimevideo.net/sites/?access_token=OAUTH-TOKEN

HTTP/1.1 200 OK
Server: nginx
Date: Fri, 12 Oct 2012 23:33:14 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Status: 200 OK
ETag: "a00049ba79152d03380c34652f2cb612"
X-SublimeVideo-Media-Type: sublimevideo-v1; format=json
Content-Length: 5
Cache-Control: max-age=0, private, must-revalidate

[]
```
Blank fields are included as `null` instead of being omitted.

All timestamps are returned in ISO 8601 format:

`YYYY-MM-DDTHH:MM:SSZ`

## Authentication

There are two ways to authenticate through SublimeVideo API v1. Requests that require authentication will return 401.

### OAuth2 Token (sent in a header)

```bash
$ curl -H "Authorization: Bearer OAUTH-TOKEN" https://api.sublimevideo.net
```

### OAuth2 Token (sent as a parameter)

```bash
$ curl https://api.sublimevideo.net/?access_token=OAUTH-TOKEN
```

Read more about OAuth2. Note that OAuth2 tokens can be acquired programmatically, for applications that are not websites.

## Register your app

1. Register your application at https://my.sublimevideo.net/account/applications
2.

------------

Copyright (c) 2010 - 2013 Jilion(r) - SublimeVideo and Jilion are registered trademarks.
