## Rate Limiting

For requests using OAuth, we limit requests to 5,000 per hour. You can check the returned HTTP headers of any API request to see your current status:

```bash
$ curl -i https://api.sublimevideo.net/sites?access_token=OAUTH-TOKEN

HTTP/1.1 200 OK
Status: 200 OK
X-RateLimit-Limit: 5000
X-RateLimit-Remaining: 4999
```

You can also check your rate limit status without incurring an API hit.

```bash
$ curl https://api.sublimevideo.net/rate_limit?access_token=OAUTH-TOKEN

Status: 200 OK
X-RateLimit-Limit: 5000
X-RateLimit-Remaining: 4999
{
  "rate": {
    "remaining": 4999,
    "limit": 5000
  }
}
```
