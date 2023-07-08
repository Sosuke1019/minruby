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



# ① 計算式の文字列を読み込む
# コマンドラインに渡されたファイルを読み込んで文字列で返す
str = minruby_load()

# ② 計算式の文字列を構文解析して計算の木(構文木)にする
tree = minruby_parse(str)

# ③ 計算の木を実行(計算)する
answer = evaluate(tree)