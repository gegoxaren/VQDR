test_dependencies = dependencies


test1_files = files ([
  'test_runner.vala',
  'random-d6.vala',
  'root_token.vala',
  'value-token.vala',
])

test1 = executable ('test1',
                     test1_files,
                     dependencies: [test_dependencies, libvqdr_dep])
test ('Test Suite 1', test1)

test2_files = files ([
  'common_test_runner.vala',
  'gobject_to_string.vala',
])

test2 = executable ('test2',
                     test2_files,
                     dependencies: [test_dependencies, libvqdr_dep])

test ('Test Suit 2', test2)

subdir_done ()
