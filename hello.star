# DEXCOM
# Client ID: dAnsdSoFNRyBwrO1w2oOJmYfu2s12Zwo
# Client Secret: ZrXkxB0KlVKeXJ7Z

###### STEP ONE ######
## Construct a request to the DEXCOM oauth portal 
## https://sandbox-api.dexcom.com/v2/oauth2/login?client_id=dAnsdSoFNRyBwrO1w2oOJmYfu2s12Zwo&redirect_uri=https://728e-2600-4040-7075-a200-f0ba-334c-2c24-7943.ngrok.io&response_type=code&scope=offline_access&state=12345


# local redirect: https://728e-2600-4040-7075-a200-f0ba-334c-2c24-7943.ngrok.io

load("http.star", "http")
load("render.star", "render")
load("schema.star", "schema")
load("secret.star", "secret")
load("encoding/json.star", "json")

OAUTH2_CLIENT_SECRET = secret.decrypt("ZrXkxB0KlVKeXJ7Z")

EXAMPLE_PARAMS = """
{"code": "your-code", "grant_type": "authorization_code", "client_id": "dAnsdSoFNRyBwrO1w2oOJmYfu2s12Zwo", "redirect_uri": "https://728e-2600-4040-7075-a200-f0ba-334c-2c24-7943.ngrok.io"}
"""

params = {"code": "your-code", "grant_type": "authorization_code", "client_id": "dAnsdSoFNRyBwrO1w2oOJmYfu2s12Zwo", "redirect_uri": "https://728e-2600-4040-7075-a200-f0ba-334c-2c24-7943.ngrok.io"}

def main(config):
    token = config.get("auth")

    if token:
        msg = "Authenticated"
    else:
        msg = "Unauthenticated"

    return render.Root(
        child = render.Marquee(
            width = 64,
            child = render.Text(msg),
        ),
    )

def oauth_handler(params):
    # deserialize oauth2 parameters, see example above.
    params = json.decode(params)

    # exchange parameters and client secret for an access token
    res = http.post(
        url = "https://sandbox-api.dexcom.com/v2/oauth2/token",
        headers = {
            "Accept": "application/json",
        },
        form_body = dict(
            params,
            client_secret = OAUTH2_CLIENT_SECRET,
        ),
        form_encoding = "application/x-www-form-urlencoded",
    )
    if res.status_code != 200:
        fail("token request failed with status code: %d - %s" %
             (res.status_code, res.body()))

    token_params = res.json()
    access_token = token_params["access_token"]

    return access_token

def get_schema():
    return schema.Schema(
        version = "1",
        fields = [
            schema.OAuth2(
                id = "auth",
                name = "Dexcom",
                desc = "Connect your Dexcom account.",
                icon = "dexcom",
                handler = oauth_handler,
                client_id = "dAnsdSoFNRyBwrO1w2oOJmYfu2s12Zwo",
                authorization_endpoint = "https://sandbox-api.dexcom.com/v2/oauth2/login",
                scopes = [
                    "read:user",
                ],
            ),
        ],
    )