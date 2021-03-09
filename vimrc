set      nocompatible
filetype plugin indent on " 开启文件类型检测
syntax   on               " 开启语法高亮

set nofoldenable          " 默认关闭代码折叠

set backspace=indent,eol,start  " 智能回删
set whichwrap+=h,l,<,>,[,]      " 光标循环
set virtualedit=block,onemore   " 允许光标出现在最后一个字符的后面

set number                " 显示行号          nu
set relativenumber        " 显示相对行号      rnu
set ruler                 " 显示标尺信息

set expandtab             " Tab 替换为空格    et
set smartindent           " 智能缩进          si

set softtabstop=2         " Tab 缩进单位      sts
set shiftwidth=2          " 自动缩进单位      sw
set encoding=utf-8        " UTF-8 编码
set t_Co=256              " 开启 256 色（若终端支持）
set nowrap                " 禁止折行

set ignorecase            " 搜索忽略大小写    ic
set incsearch             " 搜索时实时高亮    is
set hlsearch              " 高亮所有搜索结果  hls

" set cursorcolumn          " 高亮当前列        cuc
set cursorline            " 高亮当前行        cul

set scrolloff=5           " 屏幕顶/底部保持 5 行文本
set laststatus=2          " 显示状态栏
set noshowmode            " 不显示当前状态
set showcmd               " 显示输入的命令
set wildmenu              " Vim 命令行提示
set nobackup              " 不生成临时文件
set noswapfile            " 不生成 swap 文件
set autoread              " 自动加载外部修改
set autowrite             " 自动保存
set confirm               " 弹出文件未保存确认

set history=1024
set undofile
set undodir=~/.vim/.undo
if !isdirectory($HOME . "/.vim/.undo")
  call mkdir($HOME . "/.vim/.undo", "p")
endif

set timeoutlen=700        " Time to wait for a command
let mapleader=','         " Change the mapleader


" -------------------------------------------------
" EXTEND SETTINGS
" -------------------------------------------------
"  Close relative number in INSERT mode
augroup relative_numbser
  autocmd!
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber
augroup end

" -------------------------------------------------
" PLUGINS
" -------------------------------------------------
call plug#begin('~/.vim/bundle')

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': 'NERDTreeToggle' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
if executable('fzf')
  Plug 'junegunn/fzf'
else
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
endif
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'         " 启动页
Plug 'roman/golden-ratio'         " 自动控制窗口大小
Plug 'junegunn/vim-easy-align'    " 对齐插件，强迫症福音
Plug 'junegunn/vim-slash'         " 优化搜索，移动清除搜索高亮
Plug 'gorodinskiy/vim-coloresque' " 颜色预览
Plug 'jiangmiao/auto-pairs'       " 符号自动补全
Plug 'tpope/vim-surround'         " 自动增加、替换配对符
Plug 'tomtom/tcomment_vim'        " 添加注释
Plug 'ryanoasis/vim-devicons'     " Vim Dev Icons
Plug 'tpope/vim-repeat'           " 增强 . 命令
Plug 'arcticicestudio/nord-vim'   " nord 配色

call plug#end()

silent! colorscheme nord

" -------------------------------------------------
" KEY MAPPING
" -------------------------------------------------
" Shortcut for Moving in INSERT mode
imap <C-A> <Home>
imap <C-E> <End>
imap <C-B> <Left>
imap <C-F> <Right>

" Navigation Between Windows
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-H> <C-W>h
nnoremap <C-L> <C-W>l

" Buffer Jump
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bp<CR>

" Prev Tab
nnoremap <S-H> gT
" Next Tab
nnoremap <S-L> gt

" New Tab
nnoremap <Leader>t :tabnew<CR>
" Close Tab
nnoremap <Leader>w :tabclose<CR>

" :W to save file by sudo
command W w !sudo tee % > /dev/null

" Which key
nnoremap <silent> <leader> :WhichKey ','<CR>

" FZF
nnoremap <C-F>      :Files<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>fc :Colors<CR>
nnoremap <Leader>fh :History<CR>
nnoremap <Leader>fl :Lines<CR>
nnoremap <Leader>fm :Commands<CR>

" NERDTree
nnoremap <C-E>     :NERDTreeToggle<CR>
nnoremap <Leader>e :NERDTreeToggle<CR>

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Which key
let g:which_key_map =  {}
let g:which_key_sep = '→'
let g:which_key_use_floating_win = 0
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" FZF
let g:fzf_layout = { 'down': '~35%' }

" EasyAlign
let g:easy_align_delimiters = {
      \ '>': { 'pattern': '>>\|=>\|>' },
      \ '/': {
      \     'pattern':         '//\+\|/\*\|\*/',
      \     'delimiter_align': 'l',
      \     'ignore_groups':   ['!Comment'] },
      \ ']': {
      \     'pattern':       '[[\]]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ ')': {
      \     'pattern':       '[()]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ 'd': {
      \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
      \     'left_margin':  0,
      \     'right_margin': 0
      \   }
      \ }

" NERDTree
let NERDTreeChDirMode=2
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let NERDTreeShowLineNumbers=1
let g:NERDTreeWinSize=35
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1         " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name

" airline
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
