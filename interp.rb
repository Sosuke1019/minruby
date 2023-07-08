require "minruby"


# 演算結果を返す関数
def evaluate(tree)
    case tree[0]
    when "lit"
        tree[1]
    when "+"
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left + right
    when "-"
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left - right
    when "*"
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left * right
    when "%"
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left % right
    when "<"
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left < right
    when "<="
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left <= right
    when "=="
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left == right
    when ">="
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left >= right
    when ">"
        left = evaluate(tree[1])
        right = evaluate(tree[2])
        left > right
    when "func_call"
        p evaluate(tree[2])
    when "stmts"
        i = 1
        last = nil
        while tree[i] != nil
            last = evaluate(tree[i])
            i = i + 1
        end
        last
    end
end

# 最大値を返す関数
def max(tree)
    if tree[0] == "lit"
        tree[1]
    else
        left  = max(tree[1])
        right = max(tree[2])
        if left < right
            right
        else
            left
        end
    end
end

# 最小値を返す関数
def min(tree)
    if tree[0] == "lit"
        tree[1]
    else
        left  = max(tree[1])
        right = max(tree[2])
        if left > right
            right
        else
            left
        end
    end
end


# ① 計算式の文字列を読み込む
# コマンドラインに渡されたファイルを読み込んで文字列で返す
str = minruby_load()

# ② 計算式の文字列を計算の木に変換する
tree = minruby_parse(str)

# ③ 計算の木を実行（計算）する
answer = evaluate(tree)