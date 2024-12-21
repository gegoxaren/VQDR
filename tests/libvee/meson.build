libvee_test_files = files ([
  'prefixes.vala',
  'fast_number.vala',
  #'gobject_to_string.vala',

  'test_runner.vala',
  'stack.vala',
  'named_vector.vala',
])

libvee_test_runnner = executable ('libvee_test_runnner',
                     libvee_test_files,
                     dependencies: [test_dependencies, libvqdr_dep])

test ('LibVee Tests', libvee_test_runnner)
