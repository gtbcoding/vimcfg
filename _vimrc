" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
" Plugin file system explorer https://github.com/preservim/nerdtree
Plug 'preservim/nerdtree'

" Plugin outside ~/.vim/plugged with post-update hook
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'

" For HashiCorp tools
Plug 'hashivim/vim-terraform', {'for': 'terraform'}

" Language Server / Auto Completion / Snippets
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" Auto-complete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" For Ruby / Rails Development
Plug 'tpope/vim-rails', {'for': ['ruby', 'eruby']}

" Syntax
Plug 'mrk21/yaml-vim'
Plug 'elzr/vim-json'

" Git
Plug 'tpope/vim-fugitive'

" Editing
Plug 'mattn/emmet-vim'
Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'benjifisher/matchit.zip'
Plug 'mileszs/ack.vim'
Plug 'Raimondi/delimitMate'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'simnalamburt/vim-mundo'

" Initialize plugin system
call plug#end()

" Key Mappings
nnoremap <C-g>b :Buffers <CR>
nnoremap <C-g>w :Windows <CR>
nnoremap <C-g>g :Ag <CR>
nnoremap <C-g>r :Ag <C-r>"<CR>
nnoremap <leader><leader> :Commands<CR>
nnoremap <C-p> :call FzfOmniFiles()<CR>
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" <C-_> equal <C-/> https://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle

fun! FzfOmniFiles()
    let is_git = system('git status')
    if v:shell_error
        :Files
    else
        :GitFiles
    endif
endfun

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Enable mouse cursor
:set mouse=a

" Show line number
set nu

" Display underline on the line under cursor
set cursorline

"------------------------------------------------------------
" Plugins
"------------------------------------------------------------
"------------------------------
" vim-lsp
"------------------------------
" Auto enable vim-lsp plugin during startup
let g:lsp_auto_enable = 1

" Enables echo/floating window of diagnostic error for the current line to status
let g:lsp_diagnostics_echo_cursor = 1
" let g:lsp_diagnostics_float_cursor = 1

" Delay milliseconds to echo/floating window of diagnostic error for the current line to status
let g:lsp_diagnostics_echo_delay = 200
" let g:lsp_diagnostics_float_delay = 500

" Enable support for document diagnostics
let g:lsp_diagnostics_enabled = 1

" Enables signs for diagnostics
let g:lsp_diagnostics_signs_error = {'text': '✖'}
let g:lsp_diagnostics_signs_warning = {'text': '●'}
let g:lsp_diagnostics_signs_hint = {'text': '?'}
let g:lsp_diagnostics_signs_information = {'text': 'i'}

" Enables signs for code actions
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_document_code_action_signs_hint = {'text': 'A>'}

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/.vim/vim-lsp.log')

" Keep the focus in current window
" let g:lsp_preview_keep_focus = 1

" Opens preview windows as floating
let g:lsp_preview_float = 1

" Preview closes on cursor move
let g:lsp_preview_autoclose = 1

" Enable support for completion insertText property
let g:lsp_insert_text_enabled = 1

" Enable support for completion textEdit property
let g:lsp_text_edit_enabled = 1

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal completefunc=lsp#complete
  " set formatexpr=LanguageClient_textDocument_rangeFormatting()
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  " Key bindings
  nmap <buffer> <C-]> <plug>(lsp-definition)
  nmap <buffer> <leader>gd <plug>(lsp-definition)
  nmap <buffer> <leader>gt :tab LspDefinition<CR>
  nmap <buffer> <leader>gh <plug>(lsp-hover)
  nmap <buffer> <leader>gi <plug>(lsp-implementation)
  nmap <buffer> <leader>gr <plug>(lsp-references)
  nmap <buffer> <F2> <plug>(lsp-rename)

  nmap <buffer> <leader>sc <plug>(lsp-document-diagnostics)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> <leader>sn <plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>sN <plug>(lsp-previous-diagnostic)
  nmap <buffer> <leader>sp <plug>(lsp-previous-diagnostic)

  nmap <buffer> <leader>sa <plug>(lsp-code-action)

  " Scroll current displayed floating/popup window with specified count
  inoremap <buffer> <expr><C-f> lsp#scroll(+4)
  inoremap <buffer> <expr><C-d> lsp#scroll(-4)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre <buffer> call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

  " autocmd BufWritePre <buffer> call execute('LspCodeActionSync source.organizeImports')
  " autocmd BufWritePre <buffer> LspDocumentFormatSync
augroup END

" let g:lsp_settings = {
" \  'gopls': {'disabled': v:true}
" \}

let g:lsp_settings_root_markers = [
      \ 'go.mod',
      \ '.git',
      \ '.git/',
      \ '.svn',
      \ '.hg',
      \ '.bzr'
      \ ]

" Close preview window
autocmd CompleteDone * pclose


" Tabs key binding
augroup Tabs
    " Key binding: ,tc - New tab
    nmap <localleader>tc :tabnew<CR>
    " Key binding: ,te - Open new tab and edit
    nmap <localleader>te :tabedit<SPACE>
    " Key binding: ,tx - New tab and browser
    nmap <localleader>tx :tabedit .<CR>
    " Key binding: ,tf - Jump to first tab
    nmap <localleader>tf :tabfirst<CR>
    " Key binding: ,tl - Jump to last tab
    nmap <localleader>tl :tablast<CR>
    " Key binding: ,tn - Jump to next tab
    nmap <localleader>tn :tabnext<CR>
    " Key binding: ,tp - Jump to previous tab
    nmap <localleader>tp :tabprevious<CR>
    " Key binding: ,tm - Move tab
    nmap <localleader>tm :tabmove<SPACE>
    " Key binding: ,th - Open help in new tab
    nmap <localleader>th :tab help<CR>
augroup END

"------------------------------
" Nerd Commenter
"------------------------------
let NERDSpaceDelims = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

" Default not folding all
set foldlevel=99
set foldmethod=syntax

" Set ruby lsp
let g:lsp_settings_filetype_ruby = ['solargraph']

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
