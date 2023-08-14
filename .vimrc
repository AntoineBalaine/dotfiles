call plug#begin()
  Plug 'https://gitlab.com/yorickpeterse/vim-paper.git'
  Plug 'chrisbra/csv.vim'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  Plug 'rking/ag.vim'
  Plug 'junegunn/fzf'
  Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
  Plug 'francoiscabrol/ranger.vim'
  Plug 'tpope/vim-surround'
  Plug 'Raimondi/delimitMate'
  Plug 'preservim/nerdcommenter'
  Plug 'puremourning/vimspector'
  Plug 'tpope/vim-fugitive'
  Plug 'preservim/nerdtree'
  Plug 'sheerun/vim-polyglot'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'inkarkat/vim-AdvancedSorters'
call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => pazams opinionated- ‘d is for delete’ & ‘ leader-d is for cut’ (shared clipboard register mode)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" if you are using the yankring plugin, there could be some conflicts.
" to make the most of these suggested mappings,
" make sure to delete any keys mapped below from the following line at yankring.vim
" (i.e. delete 'x' and 'D'):
" let g:yankring_n_keys = 'Y D x X'
nnoremap D "_D
nnoremap d "_d

nnoremap C "_C
nnoremap c "_c
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
  nnoremap <leader>d "+d
  nnoremap <leader>D "+D
  vnoremap <leader>d "+d
  nnoremap <leader>c "+c
  nnoremap <leader>C "+C
  vnoremap <leader>c "+c

else
  set clipboard=unnamed
  nnoremap <leader>d "*d
  nnoremap <leader>D "*D
  vnoremap <leader>d "*d

  nnoremap <leader>c "*c
  nnoremap <leader>C "*C
  vnoremap <leader>c "*c
endif

set listchars=tab:\┊\
set list

set breakindent
set breakindentopt=shift:1
"set number
:set number relativenumber
set mouse=a
filetype plugin indent on

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

nmap <C-f> :NERDTreeToggle<CR>

" Add integrate use of ctrl+arrowkeys
map  <Esc>[1;5A <C-Up>
map  <Esc>[1;5B <C-Down>
map  <Esc>[1;5D <C-Left>
map  <Esc>[1;5C <C-Right>
cmap <Esc>[1;5A <C-Up>
cmap <Esc>[1;5B <C-Down>
cmap <Esc>[1;5D <C-Left>
cmap <Esc>[1;5C <C-Right>

map  <Esc>[1;2D <S-Left>
map  <Esc>[1;2C <S-Right>
cmap <Esc>[1;2D <S-Left>
cmap <Esc>[1;2C <S-Right>

" Add move line up & down
" Normal mode
nnoremap <C-Down> :m .+1<CR>==
nnoremap <C-Up> :m .-2<CR>==
" Visual mode
vnoremap <C-Down> :m '>+1<CR>gv=gv
vnoremap <C-Up> :m '<-2<CR>gv=gv

nnoremap <C-Left> b
nnoremap <C-Right> w



"Mappings for vimspector
let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
"nmap <F5> <Plug>VimspectorContinue
set nocompatible "override vi behaviours"
set ww+=<,>
"syntax enable
filetype plugin on

"Set spellchecker
"set spell
set spelllang=fr
set incsearch
set hls
set tags=./tags;/,tags;/           " search tags files efficiently
set path+=**                       " recursively search in subfolders for autocompletion search
set wildmenu                       " better command line completion, shows a list of matches
" make the tags to allow jumping to function defs
command! MakeTags !ctags -R .     
" resize panes by +/- 5
nnoremap <C-t> :vertical resize -5<cr>
nnoremap <C-s> :resize +5<cr>
nnoremap <C-r> :resize -5<cr>
nnoremap <C-m> :vertical resize +5<cr>
"nnoremap <C-n> :vertical resize +5<cr>
" map visual block mode to q (originally meant for macros)
"nnoremap q <c-v>

"solve tmux accidentally removing lines
if &term =~ '^screen'
" tmux will send xterm-style keys when its xterm-keys option is on
execute "set <xUp>=\e[1;*A"
execute "set <xDown>=\e[1;*B"
execute "set <xRight>=\e[1;*C"
execute "set <xLeft>=\e[1;*D"
endif

" get Coc to insert line on <CR> press between brackets & parenthesis
 inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

"syntax enable
syntax off

highlight Comment cterm=italic
