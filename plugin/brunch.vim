if exists('g:loaded_brunch') || &cp || v:version < 700
  finish
endif
let g:loaded_brunch = 1

function! s:SetOptDefault(opt,val)
  if !exists("g:".a:opt)
    let g:{a:opt} = a:val
  endif
endfunction

" Set defaults
call s:SetOptDefault("brunch_path_app", 'app')
call s:SetOptDefault("brunch_path_test", 'test/tests')
call s:SetOptDefault("brunch_ext_script", 'coffee')
call s:SetOptDefault("brunch_ext_stylesheet", 'styl')
call s:SetOptDefault("brunch_ext_template", 'hbs')


" Detect if we are inside a brunch project. A brunch project should have an
" app/ folder, a package.json and a config.[coffee|js].
function! s:Detect()
  if isdirectory(g:brunch_path_app) && filereadable('package.json') && filereadable('config.' . g:brunch_ext_script)
    runtime! autoload/brunch.vim
  endif
endfunction

call s:Detect()
