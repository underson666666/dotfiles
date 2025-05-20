" クリップボードの画像をファイルに保存し、リンクを挿入するプラグイン

" gVimを前提にしているのでWindows以外は読み込ませない
if !has('win32')
  finish
endif

if exists('g:loaded_vim_screenshot')
  finish
endif
let g:loaded_vim_screenshot = 1

" デフォルト設定
if !exists('g:screenshot_save_path')
  let g:screenshot_save_path = expand('~/Documents/VimScreenshots')
endif

if !exists('g:screenshot_format')
  let g:screenshot_format = 'png'
endif

if !exists('g:screenshot_prefix')
  let g:screenshot_prefix = 'screenshot'
endif

if !exists('g:screenshot_markdown')
  let g:screenshot_markdown = 1
endif

" スクリーンショット保存ディレクトリの作成
function! s:EnsureSavePathExists()
  if !isdirectory(expand(g:screenshot_save_path))
    call mkdir(expand(g:screenshot_save_path), 'p')
  endif
endfunction

" クリップボードから画像を保存し、パスを挿入する
function! s:PasteScreenshot()
  call s:EnsureSavePathExists()

  " タイムスタンプを生成
  let l:timestamp = strftime('%Y%m%d-%H%M%S')
  let l:filename = g:screenshot_prefix . '-' . l:timestamp . '.' . g:screenshot_format
  let l:fullpath = expand(g:screenshot_save_path) . '/' . l:filename

  " PowerShellを使ってクリップボードの画像を保存
  let l:ps_cmd = 'powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $img = [System.Windows.Forms.Clipboard]::GetImage(); if ($img -ne $null) { $img.Save(''' . l:fullpath . ''', [System.Drawing.Imaging.ImageFormat]::' . toupper(g:screenshot_format[0]) . tolower(g:screenshot_format[1:]) . '); Write-Output ''OK'' } else { Write-Output ''ERROR'' }"'

  let l:result = system(l:ps_cmd)

  if l:result =~# 'OK'
    " 相対パスを取得（可能な場合）
    " let l:cwd = getcwd()
    " let l:relfullpath = l:fullpath
    " let l:cwd_pattern = escape(l:cwd, '\')
    " if l:fullpath =~# '^' .  l:cwd_pattern
    "   let l:relfullpath = strpart(l:fullpath, len(l:cwd) + 1)
    " endif
    " 挿入するパスを生成
    " g:screenshot_save_pathの値をそのまま使用（展開しない）
    let l:insert_path = g:screenshot_save_path

    " パスの区切り文字を\に統一
    let l:insert_path = substitute(l:insert_path, '/', '\', 'g')

    " 完全なパスを生成
    let l:insert_fullpath = l:insert_path . '\' . l:filename

    " フォーマットに従ってテキストを生成
    if g:screenshot_markdown
      " let l:insert_text = '![Screenshot](' . substitute(l:relfullpath, '\', '/', 'g') . ')'
      let l:insert_text = '![Screenshot](' . l:insert_fullpath . ')'
    else
      let l:insert_text = substitute(l:relfullpath, '\', '/', 'g')
    endif

    " テキストを挿入
    execute "normal!  o" . l:insert_text . "\<Esc>"

    echo "スクリーンショットを保存しました: " .  l:fullpath
  else
    echoerr "クリップボードに画像がないか、処理中にエラーが発生しました。"
  endif
endfunction

  " コマンドを設定
  command! -nargs=0 PasteScreenshot call s:PasteScreenshot()

" デフォルトのキーマッピング（ユーザーが設定していない場合）
if !exists('g:screenshot_no_mappings') || !g:screenshot_no_mappings
  nnoremap <silent> <Leader>ps :PasteScreenshot<CR>
  inoremap <silent> <C-g><C-p> <C-o>:PasteScreenshot<CR>
endif
