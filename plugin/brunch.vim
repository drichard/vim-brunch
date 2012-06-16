function! s:sub(str,pat,rep)
  return substitute(a:str,'\v\C'.a:pat,a:rep,'')
endfunction

function! s:GetType(filename)
  if a:filename =~ '^app/models/'
    return 'model'
  elseif a:filename =~ '^app/views/'
    return 'view'
  endif

endfunction

function! s:PathForType(type, name)
  let type = a:type
  let name = a:name

  if type ==# 'model'
    return 'app/models/' . name . '.coffee'
  elseif type ==# 'view'
    return 'app/views/' . name . '_view.coffee'
  elseif type ==# 'template'
    return 'app/views/templates/' . name . '.hbs'
  elseif type ==# 'stylesheet'
    return 'app/views/styles/' . name . '.styl'
  endif
endfunction

function! s:OpenFile(path)
  if filereadable(a:path)
    execute "edit " . a:path
    return 1
  else 
    return 0
  endif
endfunction

function! s:Bmodel(...)
  if a:0 == 0
    let current = expand('%')
    let type = s:GetType(current)
    let path = s:PathForType(type)
  else
    let file = a:1
    let path = "app/models/" . file . ".coffee"
  endif

  if s:OpenFile(path)
    echo 'kay'
  else
    echo "No model found: " . file
  endif
endfunction


command! -buffer  -nargs=? Bmodel :call s:Bmodel(<f-args>)

