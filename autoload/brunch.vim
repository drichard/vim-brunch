" Convenience shortcuts to file extensions
let s:ext_script    = '.' . g:brunch_ext_script
let s:ext_template  = '.' . g:brunch_ext_template
let s:ext_style     = '.' . g:brunch_ext_stylesheet

let s:name_delim    = g:brunch_name_delim

" better substitute function
function! s:sub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat, a:rep,'')
endfunction

" Returns the modules's name extracted from the path
" E.g. 'app/views/event_view.coffee' becomes 'event'
function! s:GetName(path)
  let path = matchlist(a:path, '\v([\a-z_\-]{-})([_-]controller)?([_-]view)?([_-]test)?\.')
  if empty(path)
    return a:path
  else
    return path[1]
  endif
endfunction

" Returns the path for a type with the module name.
"
" type  - ['model', 'view', 'controller', 'template', 'style']
" name  - A String as the name, e.g. 'todo_list'
function! s:PathForType(type, name)
  let type = a:type
  let name = a:name

  if type ==# 'model'
    return g:brunch_path_app . '/models/' . name . s:ext_script
  elseif type ==# 'view'
    return g:brunch_path_app . '/views/' . name . s:name_delim . 'view' . s:ext_script
  elseif type ==# 'controller'
    return g:brunch_path_app . '/controllers/' . name . s:name_delim . 'controller' . s:ext_script
  elseif type ==# 'template'
    return g:brunch_path_app . '/views/templates/' . name . s:ext_template
  elseif type ==# 'style'
    return g:brunch_path_app . '/views/styles/' . name . s:ext_style
  endif
endfunction

" Finds the path for a brunch test. When no argument is given it takes the
" path of the current buffer as the target. Due to the ambigous nature of
" commands like `:Btest application` the function has to do some amount of
" best guessing. Are you looking for the test for the application model? or
" the application file in the base directory? etc.
"
" optional argument - file name, e.g. 'user_controller'
function! s:FindBrunchTest(...)
  let noArgs = a:0 == 0

  if noArgs
    " Replace app/ with test/ and add _test to each file name.
    let path = expand('%')
    let path = s:sub(path, g:brunch_path_app, g:brunch_path_test)
    let path = s:sub(path, '\.', s:name_delim . 'test\.')
    return path
  else
    " name was given, try to find a corresponding file
    let name = a:1
    " controllers are easy to resolve
    if name =~ s:name_delim . 'controller'
      let path = g:brunch_path_test . '/controllers/' . name . s:name_delim . 'test' . s:ext_script
    " and so are views
    elseif name =~ s:name_delim . 'view'
      let path = g:brunch_path_test . '/views/' . name . s:name_delim . 'test' . s:ext_script
    else
      " Let's try to find a path to the test elsewhere
      for dir in [ '/models/', '/lib', '/' ]
        let path = g:brunch_path_test . dir . name . s:name_delim . 'test' . s:ext_script
        if filereadable(path)
          break
        endif
      endfor

    endif
    return path
  endif
endfunction


" Finds the path of a file of the specific type (model, view, ...).
"
" Optional argument - The module name otherwise the name will be resolved from
" the current buffer.
function! s:FindBrunchType(type, ...)
  let noArgs = a:0 == 0

  " name/path given?
  if noArgs
    let name = s:GetName(expand('%'))
  else
    let name = a:1
  endif

  return s:PathForType(a:type, name)
endfunction

" Opens a file for editing in the current buffer.
"
" bang  - true if file does not have to exist yet
" path  - the path to the file
" mode  - 'v', 's' or '' for vsplit, split or normal edit
function! s:Edit(bang, path, mode)
  if a:bang || filereadable(a:path)
    if a:mode ==? ''
      let openMethod = 'edit '
    elseif a:mode ==? 'v'
      let openMethod = 'vsplit '
    elseif a:mode ==? 's'
      let openMethod = 'split '
    endif
    execute openMethod . a:path
    return 1
  else 
    echo "File not found: " . a:path
    return 0
  endif
endfunction

" Adds commands for file navigation in brunch.
function! s:NavCommands()
  " Add three open commands for each type: normal, horizontal split, vertical
  " split
  for mode in ['', 'V', 'S']
    " all types
    execute "command! -bang -nargs=? -complete=custom,s:CompleteModels      B" .mode. "model      :call s:Edit(<bang>0, s:FindBrunchType('model', <f-args>), '" .mode. "')"
    execute "command! -bang -nargs=? -complete=custom,s:CompleteViews       B" .mode. "view       :call s:Edit(<bang>0, s:FindBrunchType('view', <f-args>), '" .mode. "')"
    execute "command! -bang -nargs=? -complete=custom,s:CompleteControllers B" .mode. "controller :call s:Edit(<bang>0, s:FindBrunchType('controller', <f-args>), '" .mode. "')"
    execute "command! -bang -nargs=? -complete=custom,s:CompleteTemplates   B" .mode. "template   :call s:Edit(<bang>0, s:FindBrunchType('template', <f-args>), '" .mode. "')"
    execute "command! -bang -nargs=? -complete=custom,s:CompleteStyles      B" .mode. "style      :call s:Edit(<bang>0, s:FindBrunchType('style', <f-args>), '" .mode. "')"
    "
    " test
    execute "command! -bang -nargs=? -complete=custom,s:CompleteScripts     B" .mode. "test :call s:Edit(<bang>0, s:FindBrunchTest(<f-args>), '" .mode. "')"

    " config, index
    execute "command! -nargs=0 B" .mode. "config :call s:Edit(0, 'config' . s:ext_script, '" .mode. "')"
    execute "command! -nargs=0 B" .mode. "index  :call s:Edit(0, g:brunch_path_app . '/assets/index.html', '" .mode. "')"
  endfor
endfunction


" Adds command interface to common brunch commands.
function! s:BrunchCommands()
  command! -nargs=*   Build     :echo system("brunch build "    . <q-args>)
  command! -nargs=*   Bgenerate :echo system("brunch generate " . <q-args>)
  command! -nargs=*   Bdestroy  :echo system("brunch destroy "  . <q-args>)
  command! -nargs=*   Btests    :echo system("brunch test "     . <q-args>)
endfunction


" AutoCompletion
function! s:CompleteScripts(A, L, P)
  return s:CompleteFiles(g:brunch_path_app, s:ext_script)
endfunction

function! s:CompleteModels(A, L, P)
  return s:CompleteFiles(g:brunch_path_app . '/models', s:ext_script)
endfunction

function! s:CompleteViews(A, L, P)
  return s:CompleteFiles(g:brunch_path_app . '/views', s:ext_script, s:name_delim . 'view')
endfunction

function! s:CompleteControllers(A, L, P)
  return s:CompleteFiles(g:brunch_path_app . '/controllers', s:ext_script, s:name_delim . 'controller')
endfunction

function! s:CompleteStyles(A, L, P)
  return s:CompleteFiles(g:brunch_path_app . '/views/styles', s:ext_style)
endfunction

function! s:CompleteTemplates(A, L, P)
  return s:CompleteFiles(g:brunch_path_app . '/views/templates', s:ext_template)
endfunction

" Filters files recursively based on path, extension and optional substitution.
"
" path      - the base path to start searching
" ext       - the filename extension
" optional  - a regex for a part of the filename that should be removed
"
" Returns a String of filenames for custom autocompletion.
function! s:CompleteFiles(path, ext, ...)
  let paths = split(globpath(a:path, '**/*' . a:ext), '\n')
  let filenames = map(paths, "fnamemodify(v:val, ':t:r')")

  if a:0 == 1
    let filenames = map(filenames, "s:sub(v:val, '" . a:1 ."', '')")
  endif

  return join(filenames, "\n")
endfunction

" Init commands.
call s:NavCommands()
call s:BrunchCommands()
