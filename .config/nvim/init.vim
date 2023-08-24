" Get the defaults that most users want.
source /usr/share/vim/vim90/defaults.vim

set nobackup		" do not keep a backup file

if has('persistent_undo')
	set undofile	" keep an undo file (undo changes after closing)
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
	set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
	au!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
	packadd! matchit
endif

" Editor preferences
set number

set expandtab
set colorcolumn=81
set tabstop=4
set shiftwidth=4

set clipboard=unnamedplus
set background=dark
set mouse=


" VimPlug
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
	Plug 'junegunn/seoul256.vim'
	Plug 'junegunn/vim-easy-align'

" Group dependencies, vim-snippets depends on ultisnips
	Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
	Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using git URL
	Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Plugin options
	Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }

" Added packages
	Plug 'dense-analysis/ale'

call plug#end()

" Allow ALE to autoimport completion entries from LSP servers
let g:ale_completion_autoimport = 1

try
	source .exrc
catch
	" Oh look, so anyway
endtry

let g:netrw_sort_sequence = ""

nnoremap <S-t>		:tabnew<CR>
nnoremap <S-f>		:Ex<CR>
nnoremap g<Left>	:tabprevious<CR>
nnoremap g<Right>	:tabnext<CR>
