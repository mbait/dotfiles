" Begin .vimrc
"colorscheme delek
colorscheme desert256
"colorscheme desert

set nocompatible
set autowrite

set sessionoptions=buffers,curdir,folds,resize,tabpages
set encoding=utf-8
set laststatus=2
set number
set showcmd

set incsearch
set nohlsearch
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0
highlight lCursor guifg=NONE guibg=Cyan

set nobackup
set nowritebackup
set grepprg=grep\ -nr

set autoindent
set ts=4
set sw=4

" Plugins' options
let VCSCommandGitDiffOpt='--no-prefix' 
let g:netrw_browsex_viewer="xdg-open"
let g:gs_indent_log=0

hi CursorLine cterm=NONE ctermbg=242
"hi CursorLine cterm=reverse

"au WinLeave * set nocursorline nocursorcolumn
"au WinEnter * set cursorline cursorcolumn
"set cursorline cursorcolumn

au WinEnter * set cursorline
au WinLeave * set nocursorline
set cursorline

set spelllang=en,ru_RU

"vmap <F2> y:call system("xlicp -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
"nmap <F3> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p

"map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
map <F4> :vsplit<CR><C-W>l:grep <C-R><C-W> *<CR>:copen<CR>
map <F5> :make<CR>
map <F6> :make<CR>:cwindow<cr><cr>
map <silent> <leader>sc :set spell<CR>
map <silent> <leader>ns :set nospell<CR>
"imap [ []<LEFT>
"imap ( ()<LEFT>
"imap { {}<LEFT>
imap <C-L> <C-O>a
"map <F9> :exec ":!./$(find -type f -executable | head -1)".<CR><CR>

" autoload vim settings from cwd
"if !exists('s:loaded_local_vimrc')
"	exe 'silent! source '.getcwd().'/.vim/vimrc'
"	let s:loaded_local_vimrc=1
"endif
"set exrc
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype on
filetype indent on

runtime! ftplugin/man.vim
" End .vimrc
