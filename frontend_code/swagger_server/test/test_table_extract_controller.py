# coding: utf-8

from __future__ import absolute_import

from flask import json
from six import BytesIO

from swagger_server.test import BaseTestCase


class TestTableExtractController(BaseTestCase):
    """TableExtractController integration test stubs"""

    def test_table_extract_post(self):
        """Test case for table_extract_post

        Upload a table image and get recognized result.
        """
        body = Object()
        response = self.client.open(
            '/table_extract',
            method='POST',
            data=json.dumps(body),
            content_type='image/png')
        self.assert200(response,
                       'Response body is : ' + response.data.decode('utf-8'))


if __name__ == '__main__':
    import unittest
    unittest.main()
