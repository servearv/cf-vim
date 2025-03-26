" cf-vim.vim - Codeforces integration for Vim
" This plugin encapsulates Codeforces-related commands and mappings.
" It expects a global variable g:cf_workdir (set in your vimrc) to define
" the working directory for Codeforces tasks. If not defined, it defaults to ~/acads/cp.

if exists("g:loaded_cf_vim")
  finish
endif
let g:loaded_cf_vim = 1

" Use user-provided cf_workdir if available, else default
if !exists("g:cf_workdir")
  let g:cf_workdir = '~/acads/cp'
endif
let s:cf_workdir = expand(g:cf_workdir)

" -----------------------------------------------------------------------------
" Compilation and Execution Mappings
" These mappings compile and run the current file using g++ with various options.
noremap <F8> <ESC> :w <CR> :!g++ -fsanitize=address -std=c++17 -DONPC -O2 -o %< % && ./%< < inp<CR>
inoremap <F8> <ESC> :w <CR> :!g++ -fsanitize=address -std=c++17 -DONPC -O2 -o "%<" "%" && "./%<" < inp<CR>

noremap <F9> <ESC> :w <CR> :!g++ -fsanitize=address -std=c++17 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< <CR>
inoremap <F9> <ESC> :w <CR> :!g++ -fsanitize=address -std=c++17 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< <CR>

noremap <F10> <ESC> :w <CR> :!g++ -fsanitize=address -std=c++17 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< < inp<CR>
inoremap <F10> <ESC> :w <CR> :!g++ -fsanitize=address -std=c++17 -Wall -Wextra -Wshadow -DONPC -O2 -o "%<" "%" && "./%<" < inp<CR>

" -----------------------------------------------------------------------------
" Disable Copilot for files under cf_workdir
" This uses the user-defined cf_workdir rather than a hard-coded path.
execute 'autocmd BufRead,BufNewFile ' . s:cf_workdir . '/* let g:copilot_enabled = v:false'

" -----------------------------------------------------------------------------
" Auto-load 'inp' Buffer in a vsplit on the right
" If a file is opened and it is the only buffer (and not the inp file),
" then open the 'inp' file from cf_workdir in a vertical split to the right.
augroup cf_open_inp
  autocmd!
  autocmd BufReadPost,BufNewFile * call s:OpenInpIfOnlyBuffer()
augroup END

function! s:OpenInpIfOnlyBuffer() abort
  " Count listed buffers
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    " Only open 'inp' if the current file is not already 'inp'
    if fnamemodify(expand('%'), ':t') != 'inp'
      execute 'rightbelow vsplit ' . s:cf_workdir . '/inp'
    endif
  endif
endfunction

