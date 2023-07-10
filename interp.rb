require "minruby"


# 演算結果を返す関数
def evaluate(tree, venv, lenv)
    case tree[0]
    when "lit"
        tree[1]
    when "+"
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left + right
    when "-"
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left - right
    when "*"
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left * right
    when '/'
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left / right
    when "%"
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left % right
    when '**'
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left**right
    when '=='
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left == right
    when '!='
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left != right
    when "<"
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left < right
    when "<="
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left <= right
    when ">="
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left >= right
    when ">"
        left = evaluate(tree[1], genv, lenv)
        right = evaluate(tree[2], genv, lenv)
        left > right
    when "func_call" # 関数の対応
        p evaluate(tree[2], genv, lenv) 
    when 'stmts' # 複文の対応
        i = 1
        last = nil
        while tree[i]
            last = evaluate(tree[i], genv, lenv)
            i = i + 1
        end
    last
    when 'var_assign' # 変数を代入する
        lenv[tree[1]] = evaluate(tree[2], genv, lenv)
    when 'var_ref' # 変数を参照する
        lenv[tree[1]]
    when "if"
        if evaluate(tree[1], genv, lenv)
            evaluate(tree[2], genv, lenv)
        else
            # else節が存在する場合にのみ実行する処理
            # 右辺の条件がfalseの場合に左辺の式を評価する「後置unless(unless修飾子)」
            evaluate(tree[3], genv, lenv) unless tree[3].nil?
        end
    when "while"
        while evaluate(tree[1], genv, lenv)
            evaluate(tree[2], genv, lenv)
        end
    when "while2"
        evaluate(tree[2], genv, lenv)
        while evaluate(tree[1],venv, lenv)
            evaluate(tree[2], genv, lenv)
        end
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
# 環境の初期状態
genv = { "p" => ["builtin", "p"]}
lenv = {}
# 抽象構文木と環境を指定して実行開始
evaluate(tree, venv, lenv)