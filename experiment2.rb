# require "minruby"
# pp(minruby_parse("
# x = 1
# y = 2 * 3
# "))

hsh = { "foo" => 1, "bar" => 2 }
hsh["answer"] = 42
hsh["foo"] = 100
p hsh