require "minruby"
pp(minruby_parse("
answer = 0
i = 1
hhhh = 0
while i <= 1000
    if i % 2 == 0
        answer = answer + i
    else
        hhhh = hhhh - 1
    end
    i = i + 1
end
p(answer)
"))