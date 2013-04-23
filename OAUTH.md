# OAuth

OAuth2 is a protocol that lets external apps request authorization to private details in a user's MySublimeVideo account without getting their password. This is preferred over Basic Authentication because tokens can be limited to specific types of data, and can be revoked by users at any time.

All developers need to register their application before getting started. A registered OAuth application is assigned a unique Client ID and Client Secret. The Client Secret should not be shared.

## Web Application Flow

This is a description of the OAuth flow from 3rd party web sites.

### 1. Redirect users to request MySublimeVideo access

`GET https://my.sublimevideo.net/oauth/authorize`

**Parameters**

`client_id`
> Required string - The client ID you received from MySublimeVideo when you registered.

`redirect_uri`
> Optional string - URL in your app where users will be sent after authorization. See details below about redirect urls.

`scope`
> Optional string - Comma separated list of scopes.

### 2. MySublimeVideo redirects back to your site

If the user accepts your request, MySublimeVideo redirects back to your site with a temporary code in a code parameter as well as the state you provided in the previous step in a state parameter. If the states don't match, the request has been created by a third party and the process should be aborted.

Exchange this for an access token:

`POST https://my.sublimevideo.net/oauth/access_token`

**Parameters**

`client_id`
> Required string - The client ID you received from MySublimeVideo when you registered.

`redirect_uri`
> Optional string

`client_secret`
> Required string - The client secret you received from MySublimeVideo when you registered.

`code`
> Required string - The code you received as a response to Step 1.

**Response**

By default, the response will take the following form:

`access_token=e72e16c7e42f292c6912e7710c838347ae178b4a&token_type=bearer`
You can also receive the content in different formats depending on the Accept header:

```
Accept: application/json
{"access_token":"e72e16c7e42f292c6912e7710c838347ae178b4a","token_type":"bearer"}
```

### 3. Use the access token to access the API

The access token allows you to make requests to the API on a behalf of a user.

`GET https://api.sublimevideo.net/sites?access_token=...`