" Generic
set nocursorcolumn
set nocursorline
set mouse=a
set clipboard=unnamedplus
set termguicolors
set shiftwidth=4
set expandtab
syntax sync minlines=256
let mapleader = ","
set omnifunc=syntaxcomplete#Complete
set backspace=indent,eol,start  " more powerful backspacing
set winaltkeys=no
set ai!
set vb!
set switchbuf=useopen,usetab,newtab
set hidden
set ignorecase
set hlsearch
set incsearch
set smartcase
set smarttab
set noswapfile
set pastetoggle=<F2>
set exrc
set secure
set virtualedit=block 
set vb t_vb=
set modeline
set ffs=unix,dos,mac
set timeout ttimeoutlen=50
set nocompatible
set t_Co=256
set backupcopy=yes
colorscheme afterglow

"Key mappings
imap jj <esc>
" imap jk <esc>
map <Space> i <esc>
" map <Tab> i	<esc>

imap <M-h> <left>
imap <M-j> <down>
imap <M-k> <up>
imap <M-l> <right>
map <M-h> 5h 
map <M-j> 5j
map <M-k> 5k
map <M-l> 5l

map gk <C-w><Up>
map gj <C-w><Down>
map gh <C-w><Left>
map gl <C-w><Right>
map <C-j> <C-d>
map <C-k> <C-u>
map <C-l> :bn<cr>
map <C-h> :bp<cr>
map <C-n> :enew<CR>
map <C-M-l> :tabn<cr>
map <C-M-h> :tabp<cr>
map <C-M-n> :tabnew<CR>
map <C-p> :b#<CR>
"map <C-[> [m
"map <C-]> ]m

nnoremap j gj
nnoremap k gk
xnoremap j gj
xnoremap k gk
nnoremap grh :vertical resize -5<cr>
nnoremap grk :resize +5<cr>
nnoremap grj :resize -5<cr>
nnoremap grl :vertical resize +5<cr>
map Q :bp\|bd #<cr>

map <cr> :Files<cr>
map <leader>t :NERDTreeToggle<cr>
map <leader>f :RG<cr>
map <leader>g :Rg <C-r><C-w><cr>
map <leader>h :GFiles?<cr>
map <leader>b :Buffers<cr>
map <leader>l :Lines<cr>

"map <leader>n <esc>:cn<cr>
"map <leader>p <esc>:cp<cr>
map <leader>m <esc>:wa<cr>:make -s<cr>
map <leader>d :!kitty make debug<cr>
"map <leader>j <esc>:w<cr>:bn!<cr>
"map <leader>k <esc>:w<cr>:bp!<cr>
vmap <leader>c <esc>"+y
nmap <leader>v <esc>"+p
nmap <leader>w <esc>:update<cr>
nmap <leader>q <esc>:q<cr>
map <leader>/ <esc>:nohlsearch<cr>
inoremap <C-v> <C-o>:set paste<cr><C-r>+<C-o>:set paste!<cr>


" Sneak (m = move)
let g:sneak#use_ic_scs = 1
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
map m <Plug>Sneak_s
map M <Plug>Sneak_S


"folding settings
set foldmethod=manual   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "


" Statusline
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

" default the statusline to green when entering Vim
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15
 

" File-related
let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
let python_highlight_all=1
syntax on
filetype plugin indent on

au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
au BufNewFile,BufRead *.cl setf opencl


" FZF
set rtp+=~/.fzf
" let $FZF_DEFAULT_COMMAND = 'rg --files --hkdden'
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg -F --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
   let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)


" Commenting blocks of code
augroup commenting_blocks_of_code
  autocmd!
  autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
  autocmd FileType sh,ruby,python   let b:comment_leader = '# '
  autocmd FileType conf,fstab       let b:comment_leader = '# '
  autocmd FileType tex              let b:comment_leader = '% '
  autocmd FileType mail             let b:comment_leader = '> '
  autocmd FileType vim              let b:comment_leader = '" '
  autocmd FileType lua,haskell      let b:comment_leader = '-- '
augroup END
noremap <silent> <leader>cc :<C-B>silent <C-E>:keeppatterns s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> <leader>cu :<C-B>silent <C-E>:keeppatterns s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>


" VS code specific / COC specific
function s:reveal(direction, resetCursor)
  call VSCodeExtensionNotify('reveal', a:direction, a:resetCursor)
endfunction

if exists('g:vscode')
  nmap <C-l> :call VSCodeNotify('workbench.action.nextEditor')<cr>
  nmap <C-h> :call VSCodeNotify('workbench.action.previousEditor')<cr>
  nmap <C-j> :call VSCodeNotify('editorScroll', { 'by': 'line', 'to': 'down', 'value': 10})<cr>10j
  nmap <C-k> :call VSCodeNotify('editorScroll', { 'by': 'line', 'to': 'up', 'value': 10})<cr>10k
  nnoremap <C-t> :call VSCodeNotify('workbench.action.terminal.toggleTerminal')<cr>
  nnoremap <C-b> :call VSCodeNotify('workbench.action.toggleSidebarVisibility')<cr>
  nnoremap <C-w> :call VSCodeNotify('workbench.action.closeActiveEditor')<cr>
  nnoremap Q :call VSCodeNotify('workbench.action.closeActiveEditor')<cr>
  nmap <Esc> <Cmd>call VSCodeNotify('notebook.cell.quitEdit')<CR>

  nnoremap gj :call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
  xnoremap gj :call VSCodeNotify('workbench.action.focusBelowGroup')<CR>
  nnoremap gk :call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
  xnoremap gk :call VSCodeNotify('workbench.action.focusAboveGroup')<CR>
  nnoremap gh :call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
  xnoremap gh :call VSCodeNotify('workbench.action.focusLeftGroup')<CR>
  nnoremap gl :call VSCodeNotify('workbench.action.focusRightGroup')<CR>
  xnoremap gl :call VSCodeNotify('workbench.action.focusRightGroup')<CR>


  nmap <cr> :call VSCodeNotify('workbench.action.quickOpen')<cr>
  nmap <leader>w :call VSCodeNotify('workbench.action.files.save')<cr>
  "nnoremap gd :call VSCode Notify('editor.action.revealDefinitionAside')<cr>
  "nnoremap gD :call VSCodeNotify('editor.action.peekDefinition')<cr>
  "nnoremap gF :call VSCodeNotify('editor.action.peekDeclaration')<cr>
  "nnoremap gO :call VSCodeNotify('workbench.action.gotoSymbol')<cr>
  "nnoremap gr :call VSCodeNotify('editor.action.referenceSearch.trigger')<cr>
  nnoremap K :call VSCodeNotify('editor.action.showHover')<cr>
  nmap <leader>0 :call VSCodeNotify('jupyter.restartkernel')<cr>
else
  " COC
  if exists(":CocInfo")
      set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
  endif

  autocmd FileType python let b:coc_root_patterns = ['env', '.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']
  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
 	\ pumvisible() ? "\<C-n>" :
 	\ <SID>check_back_space() ? "\<TAB>" :
 	\ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gI <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gn <Plug>(coc-rename)

  map <C-LeftMouse> <LeftMouse><Plug>(coc-definition)
  map <M-LeftMouse> <LeftMouse><Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Jupyter
  let g:cell = "^# \\?%%"
  nmap <leader>co o# %%<cr><esc>
  nmap <leader>cO O# %%<cr><esc>

  function! SearchAndJump(pattern, direction, defaultAction)
    let l:line = search(a:pattern, a:direction)
    if l:line != 0
      silent execute "normal! " . l:line . "G"
    else
      silent execute "normal! " . a:defaultAction
    endif
  endfunction
  nnoremap <silent> { :call SearchAndJump(g:cell, 'b', '{')<cr>
  nnoremap <silent> } :call SearchAndJump(g:cell, '', '}')<cr>

  function! Cell()
      let g:saved_cursor = getpos('.')
      normal! l
      let l:startPos = search(g:cell, 'b')
      let l:endPos = search(g:cell)
      if l:startPos > 0 && l:endPos > 0
	call cursor(l:startPos, 0)
	normal! v
	call cursor(l:endPos - 1, 0)
	normal! $
      endif
  endfunction

  nnoremap <silent>       <leader>r<cr> :MoltenInit<cr>
  nnoremap <silent> <C-CR> :call Cell()<cr>:<C-u>MoltenEvaluateVisual<cr>:call setpos('.', g:saved_cursor)<cr>
  nnoremap <silent> <S-CR> :call Cell()<cr>:<C-u>MoltenEvaluateVisual<cr>:call search(g:cell)<cr>
  inoremap <silent> <C-CR> <esc>:call Cell()<cr>:<C-u>MoltenEvaluateVisual<cr>:call setpos('.', g:saved_cursor)<cr>
  inoremap <silent> <S-CR> <esc>:call Cell()<cr>:<C-u>MoltenEvaluateVisual<cr>:call search(g:cell)<cr>
  nnoremap <silent>       <leader>rr :MoltenEvaluateLine<CR>
  xnoremap <silent>       <leader>r  :<C-u>MoltenEvaluateVisual<CR>
  nnoremap <silent>       <leader>re :MoltenReevaluateCell<CR>
  nnoremap <silent>       <leader>rd :MoltenDelete<CR>
  nnoremap <silent>       <leader>r0 :MoltenRestart<CR>
  nnoremap <silent>       <leader>rc :MoltenInterrupt<CR>
  nnoremap <silent>       <leader>rg :MoltenGoto<CR>
  nnoremap <silent>       <leader>rw :MoltenSave<CR>
  nnoremap <silent>       <leader>rl :MoltenLoad<CR>
  nnoremap <silent>       <leader>rn :MoltenNext<CR>
  nnoremap <silent>       <leader>rp :MoltenPrev<CR>
  nnoremap <silent>       <leader>ro :MoltenShowOutput<CR>
  nnoremap <silent>       <C-M-o> :noautocmd MoltenEnterOutput<CR>
  nnoremap <silent>       go :noautocmd MoltenEnterOutput<CR>
  nnoremap <silent>       gi :MoltenImagePopup<CR>
  nnoremap <silent>       gb :MoltenOpenInBrowser<CR>

  nmap <leader>cp :CopilotChatOpen<cr>
  
endif

map <esc> <esc>
