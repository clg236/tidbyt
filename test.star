load("http.star", "http")
load("render.star", "render")

def get_token():
    res = http.post(
        url = "https://sandbox-api.dexcom.com/v2/oauth2/token",
        headers = {
            "Accept": "application/json",
        },
        form_body = dict(
            grant_type="authorization_code",
            code="b487d96aba8fcd42e082bd58a3404c66",
            client_id="dAnsdSoFNRyBwrO1w2oOJmYfu2s12Zwo",
            client_secret="ZrXkxB0KlVKeXJ7Z",
            redirect_uri="https://oauthdebugger.com/debug",
        ),
        form_encoding = "application/x-www-form-urlencoded",
    )

    token_params = res.json()
    access_token = token_params["access_token"]
    
    return access_token

def get_glocose(access_token):
    # get(url,params={},headers={},auth=()) response
    res = http.get(
        url = "https://sandbox-api.dexcom.com/v3/users/self/events",
        headers = {
            "Authorization": "Bearer " + access_token
        },
        params = dict(
            startDate = "2019-08-20T14:15:22",
            endDate = "2019-08-24T14:15:22"

        )
    )
    print(access_token)
    print(res.status_code)
    data = res.json()
    print(data)

def main():

    # get a token
    token = get_token()

    # use the token to make a request to the dexcom API
    get_glocose(token)

    return render.Root(
        child = render.Marquee(
            width = 64,
            child = render.Text("welcome!")
        )
    )