" The particularly useful features of eclim, bound to hot-keys.

" Handle missing imports
nnoremap <silent> <buffer> <leader>i :JavaImport<cr>
nnoremap <silent> <buffer> <leader>I :JavaImportMissing<cr>

" Create a template in a new buffer for abstract/missing interface methods.
nnoremap <silent> <buffer> <leader>a :JavaImpl<cr>

" Search
nnoremap <silent> <buffer> <leader>j :JavaSearchContext<cr>

" Reformat text
nnoremap <silent> <buffer> <leader>f :JavaFormat<cr>

" Add getter/setter
nnoremap <silent> <buffer> <leader>g :JavaGet<cr>
nnoremap <silent> <buffer> <leader>s :JavaSet<cr>

""" Some macros of mine to insert things that are handy.
""" These assume eclim is available.


" Add a slf4j logger to the current class.
function! aaron:addlogger()

  let l = line(".")
  let c = col(".")

  " Get the current filename, chop off the '.java' and everything through the last '/'.
  let filename = expand('%')
  let filename = substitute(filename, "\.java$", "", "g")
  let classname = substitute(filename, "^.*/", "", "g")

  " Ensure that the appropriate classes are imported.
  call eclim#java#import#InsertImports(['org.slf4j.Logger'])
  call eclim#java#import#InsertImports(['org.slf4j.LoggerFactory'])

  " Move to the line immediately following the class definition.
  execute '1'
  execute '/class ' . classname
"  execute '/{'
"  execute '-'

  " Insert the log definition.
  if strlen(classname) > 10
    let logstr = '  private static final Logger LOG = LoggerFactory.getLogger('
        \ . "\n" . '      ' . classname . '.class.getName());' . "\n"
  else
    let logstr = '  private static final Logger LOG = LoggerFactory.getLogger('
        \ . classname . '.class.getName());' . "\n"
  endif
  put=logstr

  call cursor(l, c)
endfunction

command! -nargs=0 -bar AddLogger call aaron:addlogger()
nnoremap <silent> <buffer> <leader>L :AddLogger<cr>


" Creates a new buffer and dumps an equals() method for the current class
" into it. Checks class type, referential equality on all fields, etc.
function! aaron:addequals()

  " Get the current filename, chop off the '.java' and everything through the last '/'.
  " That's our class name.
  let filename = expand('%')
  let filename = substitute(filename, "\.java$", "", "g")
  let className = substitute(filename, "^.*/", "", "g")

  " Create a new temporary buffer.
  execute 'new'
  set buftype=nofile
  set bufhidden=hide
  setlocal noswapfile

"  search("private .*", "w")

  let body = "  @Override\n"
  let body = body . "  public boolean equals(Object otherObj) {\n"
  let body = body . "    if (otherObj == this) {\n"
  let body = body . "      return true;\n"
  let body = body . "    } else if (null == otherObj) {\n"
  let body = body . "      return false;\n"
  let body = body . "    } else if (!otherObj.getClass().equals(getClass())) {\n"
  let body = body . "      return false;\n"
  let body = body . "    }\n"
  let body = body . "    " . className . " other = (" . className . ") otherObj;\n"
  let body = body . "    // TODO: Add per-field tests here.\n"
  let body = body . "    return true;\n"
  let body = body . "  }\n"
  put=body
endfunction

command! -nargs=0 -bar AddEquals call aaron:addequals()
nnoremap <silent> <buffer> <leader>E :AddEquals<cr>

" Strip trailing whitespace when you save a file.
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    let _s = @/
    %s/\s\+$//e
    let @/ = _s
    call cursor(l, c)
endfun

autocmd BufWritePre *.java :call <SID>StripTrailingWhitespaces()

