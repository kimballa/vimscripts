set nowritebackup
set nobackup
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
set backspace=eol,indent,start
set whichwrap=b,s,<,>,~,[,]
syntax on
set background=dark
set textwidth=100
"set list
"set listchars=tab:»·,trail:·
set title

" Searches: highlight matches, and be case insensitive;
" unless they contain at least one capital letter.
set hlsearch
set ignorecase
set smartcase

au BufRead,BufNewFile *.scala set filetype=scala
au BufRead,BufNewFile *.scala set syntax=scala

" for eclim
set nocompatible
filetype plugin on
silent !maybe-start-eclimd&

" Use first level of the package name for grouping in Eclim imports
let g:EclimJavaImportPackageSeparationLevel = 1

" Set up tags like I want them.
" In priority order, search current project, then all source in ~/src.
" Requires my 'gitroot' bash script

" Find the git root, if there is one, and strip any leading/trailing whitespace.
let curGitRoot = system("gitroot")
"/home/aaron/src/git"
let curGitRoot = substitute(curGitRoot, "^\\s\\+", "", "g")
let curGitRoot = substitute(curGitRoot, "[\\s]\\+$", "", "g")
let curGitRoot = substitute(curGitRoot, "\\n", "", "g")
let curGitRoot = substitute(curGitRoot, "\\r", "", "g")

let fullTagList = strlen(curGitRoot) ? curGitRoot . "/tags\\ " .
    \ system("cat " . curGitRoot . "/.taglist") . "\\ ~/src/tags" :
    \ "~/src/git/tags\\ ~/src/tags"
" 'set tags' will tokenize the spaces properly only if we use 'set'.
" Simply doing 'let &tags=...' won't properly pick up multiple tags
" files.
execute "set tags=" . fullTagList

" For the supertab program, use context completion
let g:SuperTabDefaultCompletionType = "context"

" taglist: display only tags for the current active buffer.
let g:Tlist_Show_One_File = 1

" pop open project tree with F8
nnoremap <silent> <F8> :ProjectTree<CR>

" toggle taglist with F9
nnoremap <silent> <F9> :TlistToggle<CR>

" Functions for making the screen doublewidth or normalwidth
function! aaron:doublewide()
  " 2 100-column windows plus the vertical spacer
  let &columns = 201
endfunction

function! aaron:normalwide()
  let &columns = 100
endfunction

" set to double width, and :vsp the file
function! aaron:doublevsplit(...)
  call aaron:doublewide()
  if a:0 > 0
    execute "vsplit " . a:1
  else
    execute "vsplit"
  endif
endfunction

" Function for turning on "serious mode"
function! aaron:serioushackmode()
  let &columns = 132
  execute "ProjectTree"
  execute "TlistOpen"
endfunction

command! -nargs=0 -bar DoubleWidth call aaron:doublewide()
command! -nargs=0 -bar NormalWidth call aaron:normalwide()
command! -nargs=? -complete=file VSP call aaron:doublevsplit("<args>")
command! -nargs=0 -bar HackMode call aaron:serioushackmode()

" engage hackmode with F4
nnoremap <silent> <F4> :HackMode<CR>

" cycle through tag list with + and _
nnoremap <silent> + :tnext<CR>
nnoremap <silent> _ :tprev<CR>

" set '\o' to run :only
nnoremap <silent> <Leader>o :only<CR>

" I never use the 'single-char-replace' function anyway.
nnoremap <silent> r :redo<CR>

" Open the error-messages window and go to the error message associated
" with the current line.
function! aaron:pop_current_error()
  let cur_file_name = expand("%")
  let cur_line_no = line(".")
  execute "lopen"
  execute "silent! /" . cur_file_name . "|" . cur_line_no . " "
endfunction
command! -nargs=0 -bar PopCurError call aaron:pop_current_error()
nnoremap <silent> <leader>e :PopCurError<CR>

fun! aaron:StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    let _s = @/
    %s/\s\+$//e
    let @/ = _s
    call cursor(l, c)
endfun
command! -nargs=0 -bar Strip call aaron:StripTrailingWhitespaces()


