from unittest.mock import patch

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import TestCase


class CommandsTestCase(TestCase):

    def test_wait_for_db_ready(self):
        """Test waiting for db when db is available"""

        # Mock ConnectionHandler to just return true every time it's called
        # The way that we tested the database is available
        # in Django is we just try and retrieve the default
        # database via the ConnectionHandler
        with patch('django.db.utils.ConnectionHandler.__getitem__') as gi:
            gi.return_value = True

            call_command('wait_for_db')
            self.assertEqual(gi.call_count, 1)

    # Mock the time.sleep so we don't have to wait
    # for a real particular time (example: 5 second)
    @patch('time.sleep', return_value=None)
    def test_wait_for_db(self, ts):
        """Test waiting for db"""

        with patch('django.db.utils.ConnectionHandler.__getitem__') as gi:
            # The first 5 times will get OperationalError
            gi.side_effect = [OperationalError] * 5 + [True]
            call_command('wait_for_db')
            self.assertEqual(gi.call_count, 6)
