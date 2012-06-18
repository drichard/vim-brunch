" better substitute function
function! s:sub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

" Returns the modules's name extracted from the path
function! s:GetName(path)
  let path = matchlist(a:path, '\v([\a-z_]{-})(_controller)?(_view)?(_test)?\.')
  if empty(path)
    return a:path
  else
    return path[1]
  endif
endfunction

" Returns the path for a type with the module name.
function! s:PathForType(type, name, path)
  let type = a:type
  let name = a:name

  if type ==# 'model'
    return g:brunch_path_app . '/models/' .name. '.' .g:brunch_ext_script
  elseif type ==# 'view'
    return g:brunch_path_app . '/views/' .name. '_view.' .g:brunch_ext_script
  elseif type ==# 'controller'
    return g:brunch_path_app . '/controllers/' .name. '_controller.' .g:brunch_ext_script
  elseif type ==# 'template'
    return g:brunch_path_app . '/views/templates/' .name. '.' .g:brunch_ext_template
  elseif type ==# 'style'
    return g:brunch_path_app . '/views/styles/' .name. '.' .g:brunch_ext_stylesheet
  elseif type ==# 'test'
    " Replace app/ with test/ and add _test to each file name.
    let path = s:sub(a:path, g:brunch_path_app, g:brunch_path_test)
    let path = s:sub(path, '\.', '_test\.') 
    return path
  endif
endfunction


" Finds the path of a file of the specific type (model, view, ...).
" Optional argument: the module name otherwise the name will be resolved
" from the current buffer.
function! s:FindBrunchFile(type, ...)
  " name/path given?
  if a:0 == 0
    let path = expand('%')
  else
    let path = a:1
  endif

  let name = s:GetName(path)
  return s:PathForType(a:type, name, path)
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
    for type in ['model', 'view', 'controller', 'template', 'style', 'test']
      execute "command! -bang -nargs=? B" .mode.type. " :call s:Edit(<bang>0, s:FindBrunchFile('" .type. "', <f-args>), '" .mode. "')"
    endfor

    " config, index action
    execute "command! -nargs=0 B" .mode. "config :call s:Edit(0, 'config.' . g:brunch_ext_script, '" .mode. "')"
    execute "command! -nargs=0 B" .mode. "index  :call s:Edit(0, g:brunch_path_app . '/assets/index.html', '" .mode. "')"
  endfor
endfunction


" Adds command interface to common brunch commands.
function! s:BrunchCommands()
  command! -nargs=*   Build     :echo system("brunch build " . <q-args>)
  command! -nargs=*   Bgenerate :echo system("brunch generate " . <q-args>)
  command! -nargs=*   Bdestroy  :echo system("brunch destroy " . <q-args>)
  command! -nargs=*   Btests    :echo system("brunch test " . <q-args>)
endfunction

call s:NavCommands()
call s:BrunchCommands()
