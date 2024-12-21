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


subdir ('tokens')

subdir ('libvee')

subdir_done ()
