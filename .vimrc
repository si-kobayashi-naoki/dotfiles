<<<<<<< HEAD
"vimrc
=======
"configuration of dein.vim
if &compatible
  set nocompatible
endif
>>>>>>> 1e770bb (updated configuration)

"----------------------------------------------------------------------------
"configuration
"----------------------------------------------------------------------------
"init{{{
set encoding=utf-8
scriptencoding utf-8
"appearance
set number
set display=lastline
set pumheight=10
set statusline=%y\ %r%h%w%-0.37f%m%=%{coc#status()}%{get(b:,'coc_current_function','')}%{ObsessionStatus('[$:loading]','[$:paused]')}%{fugitive#statusline()}
set laststatus=2
set ambiwidth=double
set completeopt-=preview
set lazyredraw
set shortmess+=c
set signcolumn=yes
"buffer
set hidden
"backup
set backup
set backupdir=~/.local/share/nvim/backup 
set undofile
set undodir=~/.local/share/nvim/undo
"clipboard
set clipboard+=unnamedplus
"diff
set diffopt=internal,filler,algorithm:histogram,indent-heuristic
"indent
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set breakindent
"search
set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase
"cmdline completion
set wildoptions=pum
"backspace for deletion
set backspace=indent,eol,start
"visual select expansion
set virtualedit=block
"mouse
set mouse=a
"ctags
set tags=.tags;~
"git
set nofixeol
"remenber last cursor position
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g`\"" | endif
augroup END
"etc
set autoread
set updatetime=750
"}}}
"keymap{{{
"normal
nnoremap <C-g> 1<C-g>
nnoremap <silent> <Esc><Esc> :noh<CR>
nnoremap Y y$
nnoremap x "_x
nmap <silent> go :<C-u>call append(expand('.'), '')<Cr>j
nnoremap j gj
nnoremap k gk
nnoremap gh ^
nnoremap gl $
"insert
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>^
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
"visual
vnoremap * y/<C-R>"<CR>
"command
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-k> <C-E><C-U>
cabbrev Q q
cabbrev Qa qa
cabbrev q1 q!
cabbrev qa1 qa!
"window
nnoremap <silent>+ 3<C-w>+
nnoremap <silent>_ 3<C-w>-
nnoremap <silent>= 3<C-w>>
nnoremap <silent>- 3<C-w><
nnoremap <C-w>f :vertical rightbelow wincmd f<CR>
nnoremap <C-w>gf :rightbelow wincmd f<CR>
nnoremap <silent> <C-w>] :vertical rightbelow wincmd ]<CR><C-g>
nnoremap <silent> <C-w><C-]> :rightbelow wincmd ]<CR><C-g>
"custom
"quick open vimrc
nnoremap <silent> <Space>, :edit ~/.vimrc<CR>
"[sub],[SUB] as prefix
nnoremap [sub] <Nop>
nmap s [sub]
nnoremap [SUB] <Nop>
nmap S [SUB]
"[sub]+any
nnoremap [sub]s :%s///gI<Left><Left><Left><Left>
nnoremap [sub]* *:%s/<C-r>///gI<Left><Left><Left>
nnoremap <silent> [sub]n :bnext<CR>
nnoremap <silent> [sub]p :bprev<CR>
"[SUB]+any
"<Leader>+any
nnoremap <silent> <Leader>w :BD<CR>
nnoremap <silent> <Leader>q :CleanEmptyBuffers<CR>
nnoremap <silent> <Leader>Q :BufDel<CR>
nnoremap <silent> <Leader>b :call ScrollBind()<CR>
nnoremap <Leader>dw :windo diffthis<CR>
vnoremap <Leader>dl :Linediff<CR>
nnoremap <Leader>db :DiffOrig<CR>
"}}}
"functions{{{
"DeleteHiddenBuffers = delete hidden buffer
function DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
command! BufDel call DeleteHiddenBuffers()
"CleanEmptyBuffers = delete empty buffers
function! s:CleanEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")')
    if !empty(buffers)
        exe 'bw ' . join(buffers, ' ')
    endif
endfunction
command! CleanEmptyBuffers call s:CleanEmptyBuffers()
"DiffOrig = show modified from last change
command DiffOrig tabedit % | rightb vert new | set buftype=nofile | read ++edit # | 0d_| diffthis | wincmd p | diffthis
"ScrollBind = scrollbind both window
function! ScrollBind(...)
  let l:curr_bufnr = bufnr('%')
  let g:scb_status = ( a:0 > 0 ? a:1 : !exists('g:scb_status') || !g:scb_status )
  if !exists('g:scb_pos') | let g:scb_pos = {} | endif

  let l:loop_cont = 1
  while l:loop_cont
    setl noscrollbind
    if !g:scb_status && has_key( g:scb_pos, bufnr('%') )
      call setpos( '.', g:scb_pos[ bufnr('%') ] )
    endif
    execute 'wincmd w'
    let l:loop_cont = !( l:curr_bufnr == bufnr('%') )
  endwhile

  if g:scb_status
    let l:loop_cont = 1
    while l:loop_cont
      let g:scb_pos[ bufnr('%') ] = getpos( '.' )
      normal! gg
      setl scrollbind
      execute 'wincmd w'
      let l:loop_cont = !( l:curr_bufnr == bufnr('%') )
    endwhile
  else
    let g:scb_pos = {}
  endif
endfunction
"}}}
"tab{{{
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
function! s:my_tabline()
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2
"prefix
nnoremap    [Tab]   <Nop>
nmap    t [Tab]
"jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tab]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
"new,new(to next),clone,close(only),next(last),previous(first),tag,path,move
nnoremap <silent> [Tab]t :tablast <bar> tabnew<CR>
nnoremap <silent> [Tab]<C-t> :tabnew<CR>
nnoremap <silent> [Tab]T :tabe %<CR>
nnoremap <silent> [Tab]w :tabclose<CR>
nnoremap <silent> [Tab]o :tabonly<CR>
nnoremap <silent> [Tab]n :tabnext<CR>
nnoremap <silent> [Tab]N :tabl<CR>
nnoremap <silent> [Tab]p :tabprevious<CR>
nnoremap <silent> [Tab]P :tabfir<CR>
nnoremap <silent> [Tab]<C-]> <C-w><C-]><C-w>T<C-g>
nnoremap <silent> [Tab]f <C-w>gf
nnoremap <silent> [Tab]m :wincmd T<CR>
nnoremap <silent> [Tab]h :tabm -1<CR>
nnoremap <silent> [Tab]l :tabm +1<CR>
nnoremap <silent> [Tab]H :tabm 0<CR>
nnoremap <silent> [Tab]L :tabm $<CR>
"}}}

"----------------------------------------------------------------------------
"plugin settings
"----------------------------------------------------------------------------
"dein{{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let s:toml = '~/.dein.toml'
  let s:lazy_toml = '~/.dein_lazy.toml'
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
"}}}
"fzf{{{
let g:fzf_tags_command = 'ctags -R -f .tags'
command! -bang -nargs=* FRg call 
  \ fzf#vim#grep
  \   ('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! -bang -nargs=* Files call
  \ fzf#vim#files(<q-args>,
  \            <bang>0 ? fzf#vim#with_preview('up:60%')
  \                    : fzf#vim#with_preview('right:50%:hidden', '?'),
  \            <bang>0)
nnoremap <silent> [sub]l :Buffers<CR>
nnoremap <silent> [sub]f :Files<CR>
nnoremap <silent> [sub]g :FRg<CR>
nnoremap <silent> [sub]G :Rg<CR>
nnoremap <silent> [sub]t :Tags<CR>
nnoremap <silent> [sub]o :BTags<CR>
nnoremap <silent> [sub]m :Marks<CR>
nnoremap <silent> [sub]w :Windows<CR>
nnoremap <silent> [sub]. :BLines<CR>
nnoremap <silent> [sub]/ :Lines<CR>
nnoremap <silent> [sub]y :History<CR>
nnoremap <silent> [sub]: :History:<CR>
nnoremap <silent> [sub]? :Commands<CR>
nnoremap <silent> [sub]h :Helptags<CR>
"}}}
"coc.nvim{{{
set pyxversion=3
"functions
function! s:show_documentation()
  if &filetype == 'vim' || &filetype == 'conf'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
function! s:go_definition()
  if &filetype == 'help'
    execute 'tag '.expand('<cword>')
  else
    call CocAction('jumpDefinition')
  endif
endfunction
"keymaps
nnoremap [coc] <Nop>
nmap <Space>c [coc]
"general
nnoremap <silent> [coc]c :CocCommand<CR>
nnoremap <silent> [coc]l :CocList<CR>
nnoremap <silent> [coc], :CocConfig<CR>
nnoremap <silent> [coc]. :view ~/.cache/dein/repos/github.com/neoclide/coc.nvim_release/data/schema.json \| setlocal nomodifiable<CR>
"diagnostic
nmap <silent> [a <Plug>(coc-diagnostic-prev)
nmap <silent> ]a <Plug>(coc-diagnostic-next)
"inoremap <silent><expr> <C-l> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-l> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"
"reference
nnoremap <silent> K :call <SID>show_documentation()<CR>
nnoremap <silent> <C-]> :call <SID>go_definition()<CR>
nnoremap <silent> [Tab]<C-]> :call CocActionAsync('jumpDefinition','tabe')<CR>
nmap <silent> <C-\> <Plug>(coc-references)
"formatting
nmap <Leader>r <Plug>(coc-rename)
nmap <leader>f  <Plug>(coc-format)
vmap <leader>f  <Plug>(coc-format-selected)
"Coc autocmds
augroup LspClient
  autocmd!
  autocmd BufEnter coc://document nnoremap <buffer> q <C-w>c
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END
"coc-extensions
"coc-explorer
nnoremap <silent> <Space>n :CocCommand explorer<CR>
"}}}
"others{{{
"anzu
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
"vim-trip
nmap <silent> g<C-a> <Plug>(trip-increment-ignore-minus)
nmap <silent> g<C-x> <Plug>(trip-decrement-ignore-minus)
"edgemotion
nmap ]b <Plug>(edgemotion-j)
nmap [b <Plug>(edgemotion-k)
"undotree
nnoremap <silent> <Space>u :MundoToggle<CR>
"vista
nnoremap <silent> <Space>t :Vista!!<CR>
let g:vista_default_executive = 'coc'
let g:vista_finder_alternative_executives = ['ctags']
let g:vista_blink = [0,0]
let g:vista_top_level_blink = [0,0]
let g:vista_sidebar_width = 35
let g:vista_echo_cursor_strategy = 'floating_win'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer_enable_icon = 1
let g:vista#renderer#icons = {
\  "namespace": "{}",
\  "class": "@",
\  "function": "𝒇",
\  "method": "@𝒇",
\  "variable": "𝑥",
\  "field": "@𝑥",
\  "interface": "I",
\  "constant": "&",
\}
"quickhl
nmap <Space>h <plug>(quickhl-manual-this)
vmap <Space>h <plug>(quickhl-manual-this)
nmap <Space>H <plug>(quickhl-manual-reset)
"git:fugitive;fzf;GitGutter;git-messenger
nnoremap [git] <Nop>
nmap <Space>g [git]
nnoremap <silent> [git]s :Git<CR>
nnoremap <silent> [git]d :Gvdiff<CR>
nnoremap <silent> [git]m :GFiles?<CR>
nnoremap <silent> [git]v :GitGutterPreviewHunk<CR><C-w>b
nnoremap <silent> [d :GitGutterPrevHunk<CR>
nnoremap <silent> ]d :GitGutterNextHunk<CR>
nnoremap <silent> [git]b :Git blame<CR>
nnoremap <silent> [git]c :BCommits<CR>
nnoremap <silent> [git]l :Commits<CR>
nnoremap <silent> [git]L :GV<CR>
nnoremap <silent> [git]i :GitMessenger<CR>
augroup Git
    autocmd!
    autocmd BufEnter *.fugitiveblame nmap <buffer> q gq
augroup END
"vim-obsession;{create/halt-recording},destroy
nnoremap <silent> <Leader>o :Obsession<CR>
nnoremap <silent> <Leader>O :Obsession!<CR>
"indentLine
let g:indentLine_fileTypeExclude = ['txt','text','help','man','fzf','json']
"lexima
autocmd Filetype txt,text let b:lexima_disabled = 1
"}}}

<<<<<<< HEAD
"----------------------------------------------------------------------------
"finalize
"----------------------------------------------------------------------------
"{{{
filetype plugin indent on
syntax on
"autocmds
augroup vimrc
    autocmd!
    autocmd Filetype vim setlocal keywordprg=:help
    autocmd Filetype vim setlocal foldmethod=marker
    autocmd Filetype make setlocal noexpandtab
    autocmd FileType help,diff,Preview,ref* nnoremap <buffer> q <C-w>c
    autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 iskeyword+=?
    autocmd Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.xaml setfiletype xml
    autocmd BufNewFile,BufRead *.csv setfiletype csv
    autocmd BufNewFile,BufRead *.m setfiletype objc
    autocmd Filetype objc let b:match_words = '@\(implementation\|interface\):@end'
    autocmd BufNewFile,BufRead *.json setlocal conceallevel=0
    autocmd ColorScheme * highlight Normal ctermbg=none
    autocmd ColorScheme * highlight LineNr ctermbg=none
augroup END
"neoivm bug(watching will fixed)
augroup secure_modeline_conflict_workaround
  autocmd!
  autocmd FileType help setlocal nomodeline
augroup END
"colorscheme
let g:gruvbox_contrast_dark='hard'
colorscheme gruvbox
"highlight
highlight HighlightWords ctermfg=black ctermbg=yellow
match HighlightWords /TODO\|NOTE\|MEMO/
"highlight Search ctermfg=0 ctermbg=11 guifg=Blue guibg=Yellow
highlight DiffAdd    cterm=bold ctermfg=10 ctermbg=22
highlight DiffDelete cterm=bold ctermfg=10 ctermbg=52
highlight DiffChange cterm=bold ctermfg=10 ctermbg=17
highlight DiffText   cterm=bold ctermfg=10 ctermbg=21
highlight NonText cterm=bold ctermfg=248 guifg=248
highlight SignColumn ctermbg=0
"yaml max line length (colorcolumn on over 80 char)
highlight ColorColumn ctermbg=233 guifg=233
"}}}
=======
"personal
set autoindent
set nobackup
set noundofile
set number
syntax on

"enable backspace to delete those
set backspace=indent,eol,start
>>>>>>> 1e770bb (updated configuration)
