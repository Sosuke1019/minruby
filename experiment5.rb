require "minruby"
pp(minruby_parse("p(raise(2))"))
pp(minruby_parse("p(1, 2)"))
