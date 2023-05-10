import json
from enum import Enum

import requests


class Method(Enum):
    GET = 1
    POST = 2

class ResponseValueError(Exception):

    def __init__(self, name):
        self.name = name

class VerifyResponse():

    def __init__(self, base_url, method, request_url, expected_response):
        self.base_url = base_url
        self.method = method
        self.request_url = request_url
        self.expected_response = expected_response
        self.verify()

    def verify(self):
        try:
            if (self.method == Method.GET):
                r = requests.get(f"{self.base_url}{self.request_url}", timeout=5)
            elif (self.method == Method.POST):
                r = requests.post(f"{self.base_url}{self.request_url}", timeout=5)

        except requests.exceptions.RequestException:
            return False

        if not (r.json() == self.expected_response):
            raise ResponseValueError(self.request_url)

        if "server" not in r.headers:
            raise ResponseValueError(self.request_url)

        if "date" not in r.headers:
            raise ResponseValueError(self.request_url)

        if not (r.headers["content-type"] == "application/json"):
            raise ResponseValueError(self.request_url)

        if r.headers["content-length"] != len(str(r.json())) + len(r.headers["connection"]):
            print(r.headers)
            print(r.json())
            raise ResponseValueError(self.request_url)


        print(F"{self.request_url} verification success")
        return None


def verify_data(base_url):
    try:
        VerifyResponse(
            base_url,
            Method.GET,
            "/static/raw_json",
            {"message": "Static GET Success"},
        )

        VerifyResponse(
            base_url,
            Method.POST,
            "/static/post",
            {"message": "Static POST Success"},
        )

        VerifyResponse(
            base_url,
            Method.GET,
            "/dynamic/get/1",
            {"message": "1"},
        )
        VerifyResponse(
            base_url,
            Method.GET,
            "/dynamic/get/2",
            {"message": "2"},
        )


    except ResponseValueError as e:
        print(f"Wrong response: {e}")
        return False

    return True
