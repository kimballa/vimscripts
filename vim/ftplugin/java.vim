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
  " Get the current filename, chop off the '.java' and everything through the last '/'.
  let filename = expand('%')
  let filename = substitute(filename, "\.java$", "", "g")
  let classname = substitute(filename, "^.*/", "", "g")
  
  " Ensure that the appropriate classes are imported.
  call eclim#java#import#InsertImports(['org.slf4j.Logger', 'org.slf4j.LoggerFactory'])

  " Move to the line immediately following the class definition.
  execute '1'
  execute '/class ' . classname
  execute '/{'
  execute '-'

  " Insert the log definition.
  if strlen(classname) > 10
    let logstr = "  private static final Logger LOG = LoggerFactory.getLogger(" 
        \ . "\n" . classname . ".class.getName());"
  else
    let logstr = "  private static final Logger LOG = LoggerFactory.getLogger(" 
        \ . classname . ".class.getName());"
  endif
  put=logstr
endfunction

command! -nargs=0 -bar AddLogger call aaron:addlogger()
nnoremap <silent> <buffer> <leader>L :AddLogger<cr>

