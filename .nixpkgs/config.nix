{
  packageOverrides = pkgs: with pkgs; {
    myNeovim = neovim.override {
      configure = {
        customRC = ''
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_fmt_options = "-local=gopkg.in/launchdarkly,github.com/launchdarkly"
let g:deoplete#sources#go#gocode_binary = "$GOPATH/bin/gocode"

let g:deoplete#sources#rust#racer_binary="/home/blake/.cargo/bin/racer"
let g:deoplete#sources#rust#rust_source_path="/home/blake/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"
let g:rustfmt_autosave = 1

" auto-format Terraform on save
let g:terraform_fmt_on_save=1

" jump to last edited position in file instead of always starting at the top
" line, leftmost column
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \| exe "normal! g'\"" | endif

filetype plugin indent on
syntax enable

se nu

set nomodeline

" enter spaces when tab is pressed:
set expandtab

" do not break lines when line length increases
set textwidth=0
" user 4 spaces to represent a tab
set tabstop=8
set softtabstop=4

" number of space to use for auto indent
" you can use >> or << keys to indent current line or selection
" in normal mode.
set shiftwidth=4

se autoindent
se backspace=indent,eol,start
se complete-=i
se smarttab

se laststatus=2
se ruler
se showcmd

se hlsearch incsearch

se splitbelow splitright

se wrapmargin=0
se linebreak
se tw=80

se nojoinspaces

nmap w :w<CR>
nmap q :q<CR>
" nmap <Tab> <C-w><C-w>
nmap <F5> :!go test<CR>

" Move between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"" move between tabs
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tk  :tabprev<CR>
nnoremap tl  :tablast<CR>

" Clear highlighting by pressing ENTER
nnoremap <silent> <CR> :noh<CR><CR>

" Remap : to ;
nnoremap ; :

" colors zenburn
se colorcolumn=100
set ic

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

au FileType python setl ts=4 sw=4 et

"Git and fugitive.
map <C-G>s :Gstatus<CR>
map <C-G>c :Gcommit<CR>

"Make cntrl-p not show pyc files
set wildignore+=*.pyc

let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](target)|(Godeps)|(build)$',
	\ }


"" Python settings
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"" Pymode customizations
let g:pymode_folding = 0
let g:pymode_lint = 0
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

"" Use the following for large python projects which cause vim to hang
"" otherwise
" let g:pymode_rope = 0
" let g:pymode_rope_lookup_project = 0

"" Go settings
au BufRead,BufNewFile *.go noremap grn :GoRename<CR>


au BufRead,BufNewFile *.frugal setlocal ft=thrift

"" syntastic customizations

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 120
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=White
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
    se nofoldenable " disable folding
 "   let g:pymode_rope_goto_definition_bind = "gd"

    autocmd FileType haskell set tabstop=8
    autocmd FileType haskell set expandtab
    autocmd FileType haskell set softtabstop=4
    autocmd FileType haskell set shiftwidth=4
    autocmd FileType haskell set shiftround
augroup END

autocmd FileType ruby nmap gd :CtrlPTag<cr>

"" Go settings
au Bufread,BufNewFile *.go noremap grn :GoRename<CR>

au BufRead,BufNewFile *.frugal setlocal ft=thrift

" ctrl+p optimization
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

if has('nvim')
  " ESC puts terminal into normal mode
  tnoremap <Esc> <C-\><C-n>
  " M-[ lets us send literal esc to terminal programs
  tnoremap <M-[> <Esc>
  " C-v ESC lets us send literal esc to terminal programs
  tnoremap <C-v><Esc> <Esc>

  " Use nvr as git editor to prevent nested vim windows
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
  autocmd FileType gitcommit set bufhidden=delete
endif

" Open Grep results in quickfix window
autocmd QuickFixCmdPost *grep* cwindow
" command! -bar -nargs=1 Ggrep silent grep <q-args> | redraw! | cw

" Disable autocomplete for plaintext files
" au BufRead,BufNewFile,BufEnter README.md :AcpDisable
" autocmd BufLeave README.*,*.txt :AcpEnable
" TODO: do this for deoplete

" update find/replace live
:set inccommand=nosplit

" Use deoplete
let g:deoplete#enable_at_startup = 1

call deoplete#enable()

" Disable scratch window for autocomplete
set completeopt-=preview
	'';
	packages.myVimPackage = with pkgs.vimPlugins; {
	  start = [ ctrlp deoplete-nvim deoplete-go fugitive deoplete-rust vim-highlightedyank ];
	};
      };
    };
  };
}
