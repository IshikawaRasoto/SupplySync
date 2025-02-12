import json


class HttpError(Exception):
    def __init__(self, code, message, details):
        self.error_json = {
            "error": {
                'code': code,
                'message': message,
                'details': details
            }
        }

    def to_json(self):
        return json.dumps(self.error_json)
