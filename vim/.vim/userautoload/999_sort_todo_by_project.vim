" TodoをProject別、期限順にソートする関数
" タスクブロック（メインタスクとそのサブタスク）を保持したままソートする

function! SortTodoByProject() range
    " 選択範囲の行を取得
    let start_line = a:firstline
    let end_line = a:lastline
    
    " タスクブロックを解析して構造化
    let task_blocks = []
    let current_block = []
    let current_project = ''
    
    for line_num in range(start_line, end_line)
        let line = getline(line_num)
        
        " 空行やセクション見出しはスキップ
        if line =~ '^\s*$' || line =~ '^#'
            continue
        endif
        
        " メインタスク（インデントが最小）かどうかを判定
        let indent_level = len(matchstr(line, '^\s*'))
        let is_main_task = (indent_level == 0 || (len(current_block) == 0))
        
        " プロジェクト名を抽出（+で始まる文字列）
        let project_match = matchstr(line, '+\w\+')
        
        if is_main_task && len(current_block) > 0
            " 前のブロックを保存
            call add(task_blocks, {'project': current_project, 'lines': current_block})
            let current_block = []
        endif
        
        if project_match != ''
            let current_project = project_match
        endif
        
        call add(current_block, line)
    endfor
    
    " 最後のブロックを追加
    if len(current_block) > 0
        call add(task_blocks, {'project': current_project, 'lines': current_block})
    endif
    
    " プロジェクト名でソート
    call sort(task_blocks, 'CompareTaskBlocks')
    
    " ソート結果を元の場所に書き戻し
    let line_num = start_line
    for block in task_blocks
        for line in block.lines
            call setline(line_num, line)
            let line_num += 1
        endfor
    endfor
    
    echo "Todoをプロジェクト別にソートしました！"
endfunction

" 期限を抽出する関数
function! ExtractDueDate(line)
    let due_match = matchstr(a:line, 'due:\d\{4\}-\d\{2\}-\d\{2\}')
    if due_match != ''
        return substitute(due_match, 'due:', '', '')
    else
        return '9999-12-31'  " 期限なしは最後に配置
    endif
endfunction

" 期限を比較用の数値に変換
function! DateToNumber(date_str)
    if a:date_str == '9999-12-31'
        return 99991231
    endif
    return str2nr(substitute(a:date_str, '-', '', 'g'))
endfunction

" タスクブロック比較関数（プロジェクト＋期限）
function! CompareTaskBlocks(block1, block2)
    let project1 = a:block1.project
    let project2 = a:block2.project
    
    " まずプロジェクトで比較
    if project1 != project2
        " プロジェクト名がない場合は最後に配置
        if project1 == '' && project2 == ''
            return 0
        elseif project1 == ''
            return 1
        elseif project2 == ''
            return -1
        else
            return project1 == project2 ? 0 : project1 > project2 ? 1 : -1
        endif
    endif
    
    " 同じプロジェクト内では期限で比較
    let due1 = ExtractDueDate(a:block1.lines[0])
    let due2 = ExtractDueDate(a:block2.lines[0])
    let date_num1 = DateToNumber(due1)
    let date_num2 = DateToNumber(due2)
    
    return date_num1 - date_num2
endfunction

" より精密なバージョン：サブタスクのインデントを考慮＋期限ソート
function! SortTodoByProjectAndDue() range
    let start_line = a:firstline
    let end_line = a:lastline
    
    let task_blocks = []
    let current_block = []
    let current_project = ''
    let base_indent = -1
    
    for line_num in range(start_line, end_line)
        let line = getline(line_num)
        
        " 空行やセクション見出しはスキップ
        if line =~ '^\s*$' || line =~ '^#'
            continue
        endif
        
        let indent_level = len(matchstr(line, '^\s*'))
        
        " 新しいメインタスクの開始を検出
        let is_new_main_task = 0
        if base_indent == -1
            " 最初のタスク
            let base_indent = indent_level
            let is_new_main_task = 1
        elseif indent_level <= base_indent && len(current_block) > 0
            " 同じまたはより小さいインデント = 新しいメインタスク
            let is_new_main_task = 1
        endif
        
        if is_new_main_task && len(current_block) > 0
            " 前のブロックを保存
            call add(task_blocks, {'project': current_project, 'lines': current_block})
            let current_block = []
        endif
        
        " プロジェクト名を抽出
        let project_match = matchstr(line, '+\w\+')
        if project_match != '' && (is_new_main_task || current_project == '')
            let current_project = project_match
        endif
        
        call add(current_block, line)
        
        if is_new_main_task
            let base_indent = indent_level
        endif
    endfor
    
    " 最後のブロックを追加
    if len(current_block) > 0
        call add(task_blocks, {'project': current_project, 'lines': current_block})
    endif
    
    " プロジェクト名＋期限でソート
    call sort(task_blocks, 'CompareTaskBlocks')
    
    " ソート結果を書き戻し
    let line_num = start_line
    for block in task_blocks
        for line in block.lines
            call setline(line_num, line)
            let line_num += 1
        endfor
    endfor
    
    echo "プロジェクト＋期限ソート完了！ (" . len(task_blocks) . "ブロック処理)"
endfunction

" プロジェクトのみソート（期限は考慮しない）
function! SortTodoByProjectOnly() range
    let start_line = a:firstline
    let end_line = a:lastline
    
    let task_blocks = []
    let current_block = []
    let current_project = ''
    let base_indent = -1
    
    for line_num in range(start_line, end_line)
        let line = getline(line_num)
        
        if line =~ '^\s*$' || line =~ '^#'
            continue
        endif
        
        let indent_level = len(matchstr(line, '^\s*'))
        let is_new_main_task = 0
        
        if base_indent == -1
            let base_indent = indent_level
            let is_new_main_task = 1
        elseif indent_level <= base_indent && len(current_block) > 0
            let is_new_main_task = 1
        endif
        
        if is_new_main_task && len(current_block) > 0
            call add(task_blocks, {'project': current_project, 'lines': current_block})
            let current_block = []
        endif
        
        let project_match = matchstr(line, '+\w\+')
        if project_match != '' && (is_new_main_task || current_project == '')
            let current_project = project_match
        endif
        
        call add(current_block, line)
        
        if is_new_main_task
            let base_indent = indent_level
        endif
    endfor
    
    if len(current_block) > 0
        call add(task_blocks, {'project': current_project, 'lines': current_block})
    endif
    
    " プロジェクト名のみでソート（期限は無視）
    call sort(task_blocks, 'CompareTaskBlocksProjectOnly')
    
    let line_num = start_line
    for block in task_blocks
        for line in block.lines
            call setline(line_num, line)
            let line_num += 1
        endfor
    endfor
    
    echo "プロジェクトのみソート完了！"
endfunction

" プロジェクトのみ比較関数
function! CompareTaskBlocksProjectOnly(block1, block2)
    let project1 = a:block1.project
    let project2 = a:block2.project
    
    if project1 == '' && project2 == ''
        return 0
    elseif project1 == ''
        return 1
    elseif project2 == ''
        return -1
    else
        return project1 == project2 ? 0 : project1 > project2 ? 1 : -1
    endif
endfunction

" キーマップの設定
" プロジェクト＋期限でソート
vnoremap <leader>spd :call SortTodoByProjectAndDue()<CR>
nnoremap <leader>spda :%call SortTodoByProjectAndDue()<CR>

" プロジェクトのみでソート
vnoremap <leader>sp :call SortTodoByProjectOnly()<CR>
nnoremap <leader>spa :%call SortTodoByProjectOnly()<CR>

" 期限のテスト表示用関数（デバッグ用）
function! ShowTaskDueDates() range
    let start_line = a:firstline
    let end_line = a:lastline
    
    for line_num in range(start_line, end_line)
        let line = getline(line_num)
        if line =~ '^\s*- \['
            let due_date = ExtractDueDate(line)
            let project = matchstr(line, '+\w\+')
            echo printf("Line %d: Project=%s, Due=%s", line_num, project, due_date)
        endif
    endfor
endfunction
