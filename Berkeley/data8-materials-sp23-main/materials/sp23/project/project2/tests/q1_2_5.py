OK_FORMAT = True
test = {   'name': 'q1_2_5',
    'points': [0, 1, 1],
    'suites': [   {   'cases': [   {'code': '>>> monthly_increases.num_rows == 12\nTrue', 'hidden': False, 'locked': False},
                                   {'code': ">>> monthly_increases.labels == ('Month', 'Past', 'Present', 'Increase')\nTrue", 'hidden': False, 'locked': False},
                                   {   'code': ">>> # Make sure your table is sorted from January to December.\n>>> monthly_increases.row(2).item('Month') == '03 (Mar)'\nTrue",
                                       'hidden': False,
                                       'locked': False}],
                      'scored': True,
                      'setup': '',
                      'teardown': '',
                      'type': 'doctest'}]}
