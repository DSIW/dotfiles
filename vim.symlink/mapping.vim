" vim: set foldmarker={{{,}}} foldlevel=0 foldmethod=marker tabstop=4 shiftwidth=4:

" Deactivate the help dialoge {{{
imap <F1> <ESC>
nmap <F1> <ESC>
vmap <F1> <ESC>
" }}}
"---------------------------------------------------------
" Useful mappings
"---------------------------------------------------------
" Fold all regions except the visually selected one:
vnoremap ,h :<c-u>1,'<lt>-fold<bar>'>+,$fold<CR>

"nmap <F7> :call ToggleFoldByCurrentSearchPattern()<CR>

" mapping of CTRL-] to ALT-\ for jumping in vim help files
map \\ <C-]>

" don't mess up vim, when inserting with the mouse
"set pastetoggle=<F10>

" You are too fast and keep pressing `shift' if you type :w, try following
":command! -bang W w<bang>
command! -bang -bar -nargs=? -complete=file -range=% W <line1>,<line2>w<bang> <args>
command! -bang Wq wq<bang>
command! -bang Q q<bang>
" disallow opening the commandline window which by default is bound to
" q: (I tend to usually mean :q)
" The commandline window is still accessible using q/ or q?
noremap q: :q

" In help files, map Enter to follow tags
au BufWinEnter *.txt if(&ft =~ 'help')| nmap <buffer> <CR> <C-]> |endif

" execute the command in the current line (minus the first word, which
" is intended to be a shell prompt and needs to be $) and insert the
" output in the buffer
nmap ,e 0wy$:r!<cword><CR>
nmap ,E 0wwy$:r!<cword><CR>

" for editing a file with other users, this will insert my name and
" the date, when I edited
nmap ,cb odsiw, <ESC>:r!LC_ALL='' date<CR>kJo-

if exists("*pumvisible")
    inoremap <expr> <Down> pumvisible() ? "\<lt>Down>" : "\<lt>C-O>gj"
    inoremap <expr> <Up> pumvisible() ? "\<lt>Up>" : "\<lt>C-O>gk"
else
   inoremap <Down> <C-O>gj
   inoremap <Up> <C-O>gk
endif

if version > 700
" turn spelling on by default:
" set spell
" toggle spelling with F12 key:
    map <F12> :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>
endif

" WINDOWS {{{
    " Maps to make handling windows a bit easier
    "
    noremap <silent> <C-h> :wincmd h<CR>
    noremap <silent> <C-j> :wincmd j<CR>
    noremap <silent> <C-k> :wincmd k<CR>
    noremap <silent> <C-l> :wincmd l<CR>
    noremap <silent> ,= :wincmd =<CR>
    noremap <silent> ,sb :wincmd p<CR>
    noremap <silent> <C-F9>  :vertical resize -10<CR>
    noremap <silent> <C-F10> :resize -10<CR>
    noremap <silent> <C-F11> :resize +10<CR>
    noremap <silent> <C-F12> :vertical resize +10<CR>
    noremap <silent> ,s8 :vertical resize 83<CR>
    noremap <silent> ,cj :wincmd j<CR>:close<CR>
    noremap <silent> ,ck :wincmd k<CR>:close<CR>
    noremap <silent> ,ch :wincmd h<CR>:close<CR>
    noremap <silent> ,cl :wincmd l<CR>:close<CR>
    noremap <silent> ,cw :close<CR>
    "noremap <silent> ,ml <C-W>L
    "noremap <silent> ,mk <C-W>K
    "noremap <silent> ,mh <C-W>H " same in ShowMarks
    "noremap <silent> ,mj <C-W>J
    noremap <silent> <C-7> <C-W>>
    noremap <silent> <C-8> <C-W>+
    noremap <silent> <C-9> <C-W>+
    noremap <silent> <C-0> <C-W>>

    " ,q to toggle quickfix window (where you have stuff like GitGrep)
    " ,oq to open it back up (rare)
    nmap <silent> ,qc :cclose<CR>
    nmap <silent> ,qo :copen<CR>

    " Create window splits easier. The default
    " way is Ctrl-w,v and Ctrl-w,s. I remap
    " this to vv and ss
    nnoremap <silent> vv <C-w>v
    nnoremap <silent> ss <C-w>s
    nnoremap <silent> ,wo :ZoomWin<CR>
" }}}

" VIMRC {{{
" Edit the vimrc file
nnoremap <silent> ,ev :e ~/.vimrc<CR>
nnoremap <silent> ,sv :so ~/.vimrc<CR>
nmap ,em :e ~/.vim/mapping.vim<CR>
" }}}

" Motions {{{
nmap <C-0> g0
nmap <C-4> g$
vmap <C-0> g0
vmap <C-4> g$
" }}}

" Copy & Paste {{{
"vmap <C-c> "+y
"nmap <C-p> "+p
" }}}

" Disable Arrow-Keys {{{
" noremap  <Up> ""
" noremap! <Up> <Esc>
" noremap  <Down> ""
" noremap! <Down> <Esc>
" noremap  <Left> ""
" noremap! <Left> <Esc>
" noremap  <Right> ""
" noremap! <Right> <Esc>
" }}}
"---------------------------------------------------------
" From Derek
"---------------------------------------------------------
" Toggle paste mode
nmap <silent> ,p :set invpaste<CR>:set paste?<CR>

" cd to the directory containing the file in the buffer
nmap <silent> ,cd :lcd %:h<CR>
nmap <silent> ,md :!mkdir -p %:p:h<CR>

" Turn off that stupid highlight search
nmap <silent> ,n :set invhls<CR>:set hls?<CR>

" put the vim directives for my file editing settings in
nmap <silent> ,vi
      \ ovim:set ts=4 sts=4 sw=4:<CR>vim600:fdm=marker fdl=1 fdc=0:<ESC>

" Show all available VIM servers
"nmap <silent> ,ss :echo serverlist()<CR>

" The following beast is something i didn't write... it will return the
" syntax highlighting group that the current "thing" under the cursor
" belongs to -- very useful for figuring out what to change as far as
" syntax highlighting goes.
nmap <silent> <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
      \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name")
      \ . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
      \ . ">"<CR>

" set text wrapping toggles
nmap <silent> ,w :set invwrap<CR>:set wrap?<CR>

" Run the command that was just yanked
nmap <silent> ,rc :@"<cr>

" Map CTRL-E to do what ',' used to do
"nnoremap <c-e> ,
"vnoremap <c-e> ,

" Buffer commands
noremap <silent> ,bd :bd<CR>

" Make horizontal scrolling easier
nmap <silent> <C-o> 10zl
nmap <silent> <C-i> 10zh

" Shortcut to rapidly toggle `set list`
nmap ,l :set list!<CR>

" Highlight all instances of the current word under the cursor
"nmap <silent> ^ :setl hls<CR>:let @/="<C-r><C-w>"<CR>

" Search the current file for what's currently in the search {{{
" register and display matches
nmap <silent> ,gs
      \ :vimgrep /<C-r>// %<CR>:ccl<CR>:cwin<CR><C-W>J:set nohls<CR>

" Search the current file for the word under the cursor and display matches
nmap <silent> ,gw
      \ :vimgrep /<C-r><C-w>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:set nohls<CR>

" Search the current file for the WORD under the cursor and display matches
nmap <silent> ,gW
      \ :vimgrep /<C-r><C-a>/ %<CR>:ccl<CR>:cwin<CR><C-W>J:set nohls<CR>
" }}}

" Swap two words
"nmap <silent> gw :s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR>`'
nmap <silent> sw "xdiwdwep"xp
"nmap <silent> sw dawwP
"nmap <silent> sw dawelp

" Underline the current line with '='
nmap <silent> ,ul :t.\|s/./=/g\|set nohls<cr>

" Delete all buffers
nmap <silent> ,da :exec "1," . bufnr('$') . "bd"<cr>

" better undo {{{
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>
inoremap <BS> <C-G>u<BS>
inoremap <Del> <C-G>u<Del>
" }}}

" Visually select the text that was last edited/pasted
nmap gV `[v`]
"fold a method/function
nmap ,zm /}<CR>zf%<ESC>:nohlsearch<CR>
"change text in "" to the copied text
nmap <leader>c" vi"d"+P
"set hardwrapping
nmap <leader>wh set fo=at
"set softwrapping
nmap <leader>ws set fo=

" Split line (opposite to S-J joining line)
" Pressing `Enter' inserts a new line
" only if buffer is modifiable (e.g. not in help or quickfix window)
if (&ma)
    " nmap <buffer> <CR> i<CR><ESC>
    nnoremap <leader><CR> gEa<CR><ESC>ew
endif


" AutoClose
"au Filetype markdown,octopress nmap <leader>iuw i[xepa("+P
"au Filetype markdown,octopress nmap <leader>iuW i[xEpa("+P
"au Filetype markdown,octopress vmap <leader>iu s[lxhf]hxa("+Pl
" DelimitMate
au Filetype markdown,octopress nmap <leader>iuw ysw]ela(<C-R>+<ESC>
au Filetype markdown,octopress nmap <leader>iuW ysW]Ea(<ESC>"+p
au Filetype markdown,octopress vmap <leader>iu s]f]a(<C-R>+<ESC>
au Filetype markdown,octopress nmap <leader>up O**Update vom <ESC>:r!getDateVersion -d<CR>kJA:** **<ESC>i

nnoremap ze zMzo
nnoremap zE zMzO
