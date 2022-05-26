token_test1_files = files ([
  'test_prefixes.vala',
  'token_tests.vala',

  'value/constant.vala',
  'value/variabel.vala',

  'operator/add.vala',
  'operator/dice.vala',
  'operator/divide.vala',
  'operator/multiply.vala',
  'operator/subtract.vala',
])

token_test1 = executable ('token_test',
                          token_test1_files,
                          dependencies: [test_dependencies, libvqdr_dep])

test ('token tests', token_test1)

subdir_done ()
