require "minruby"


# 演算結果を返す関数
def evaluate(tree, env)
    case tree[0]
    when "lit"
        tree[1]
    when "+"
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left + right
    when "-"
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left - right
    when "*"
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left * right
    when '/'
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left / right
    when "%"
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left % right
    when '**'
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left**right
    when '=='
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left == right
    when '!='
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left != right
    when "<"
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left < right
    when "<="
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left <= right
    when ">="
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left >= right
    when ">"
        left = evaluate(tree[1], env)
        right = evaluate(tree[2], env)
        left > right
    when "func_call" # 関数の対応
        p evaluate(tree[2], env)
    when 'stmts' # 複文の対応
        i = 1
        last = nil
        while !tree[i].nil?
            last = evaluate(tree[i], env)
            i+= 1
        end
    last
    when 'var_assign' # 変数を代入する
        env[tree[1]] = evaluate(tree[2], env)
    when 'var_ref' # 変数を参照する
        env[tree[1]]
    else
        p("error")
        pp(tree)
        raise("unknown node") #プログラムの動作を停止する
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
# インタプリタの実行を開始する時には何の変数も定義されていない
env = {}
answer = evaluate(tree, env)