require "minruby"


# 演算結果を返す関数
def evaluate(tree, genv, lenv)
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
    when "func_def" # 関数を定義している
        # tree[2]は「仮引数名の配列」、tree[3]は「関数本体」を意味する
        genv[tree[1]] = ["user_defined", tree[2], tree[3]]
    when "func_call" # 関数の対応
        args = []
        i = 0
        while tree[i + 2]
            args[i] = evaluate(tree[i + 2], genv, lenv)
            i = i + 1
        end
        mhd = genv[tree[1]]
        if mhd[0] == "builtin"
            # 「本物のRubyの関数」を処理する関数(minrubyパッケージの組み込み関数)
            minruby_call(mhd[1], args)
        else
            new_lenv = {}
            # mhd[1]には仮引数名の配列が入っている
            params = mhd[1]
            i = 0
            # argsに入っている実引数の配列を順番に変数の環境lenvへと入れている
            while
                new_lenv[params[i]] = args[i]
                i = i + 1
            end
        # mhd[2]に入っている関数本体を評価
        evaluate(mhd[2], genv, new_lenv)
        end
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
            evaluate(tree[3], genv, lenv)
        end
    when "while"
        while evaluate(tree[1], genv, lenv)
            evaluate(tree[2], genv, lenv)
        end
    when "while2"
        evaluate(tree[2], genv, lenv)
        while evaluate(tree[1],genv, lenv)
            evaluate(tree[2], genv, lenv)
        end
    when "ary_new"
        ary = []
        i = 0
        while tree[i + 1]
            ary[i] = evaluate(tree[i + 1], genv, lenv)
            i = i + 1
        end
        ary
    when "ary_ref"
        # aryは配列を表す式が表す配列、idxはインデックスを表す式が表すインデックス
        ary = evaluate(tree[1], genv, lenv)
        idx = evaluate(tree[2], genv, lenv)
        ary[idx]
    when "ary_assign"
        ary = evaluate(tree[1], genv, lenv)
        idx = evaluate(tree[2], genv, lenv)
        val = evaluate(tree[3], genv, lenv)
        ary[idx] = val
    when "hash_new"
        hsh = {}
        i = 0
        while tree[i + 1]
            key = evaluate(tree[i + 1], genv, lenv)
            val = evaluate(tree[i + 2], genv, lenv)
            hsh[key] = val
            i = i + 2
        end
        hsh
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

# ③ 計算の木を実行する
# 関数名の環境
genv = {
    "p" => ["builtin", "p"],
    "raise" => ["builtin", "raise"],
    "require" => ["builtin", "require"],
    "minruby_parse" => ["builtin", "minruby_parse"],
    "minruby_load" => ["builtin", "minruby_load"],
    "minruby_call" => ["builtin", "minruby_call"],
}
# 変数名の環境
lenv = {}
# 抽象構文木と環境を指定して実行開始
evaluate(tree, genv, lenv)