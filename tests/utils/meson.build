util_test_files = files ([
  'prefixes.vala',
  'fast_number.vala',
  #'gobject_to_string.vala',

  'test_runner.vala',
  'stack.vala',
])

utils_test_runnner = executable ('utils_test_runnner',
                     util_test_files,
                     dependencies: [test_dependencies, libvqdr_dep])

test ('Utils Tests', utils_test_runnner)
