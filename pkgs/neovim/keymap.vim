let mapleader = ' '

let s:modes = ['n', 'v', 'i', 'c', 't']

function! s:rawMap(mode, extra, trigger, prefix, keys, suffix)
    let extra = a:extra

    " Remove all spaces
    let trigger = substitute(a:trigger, ' ', '', 'g')

    if IsString(a:keys)
        let bindTo = a:prefix . a:keys . a:suffix
    elseif IsFunction(a:keys)
        let name = AnonFunc({ -> a:prefix . a:keys() . a:suffix })

        let extra  .= '<expr> '
        let bindTo  = name . '()'
    endif

    exec a:mode . 'noremap ' . extra . trigger . ' ' . bindTo
endfunction

function! Map(opts, trigger, command)
    let opts = Opts(a:opts)
    let extra = Maybe(opts.Has('b'), '<buffer> ')

    let wrapper = {
                \ 'n': [ ':',             "\<CR>"        ],
                \ 'v': [ "\<C-c>:",       "\<CR>gv"      ],
                \ 'i': [ "\<C-o>:",       "\<CR>"        ],
                \ 'c': [ "\<C-c>:",       "\<CR>:\<C-p>" ],
                \ 't': [ "\<C-\>\<C-n>:", "\<CR>i"       ],
                \ }

    for m in opts.Intersecting(s:modes)
        let silent = Maybe(m !=# 'c', '<silent> ')

        let prefix = wrapper[m][0]
        let suffix = wrapper[m][1]

        call s:rawMap(m, silent . extra, a:trigger, prefix, a:command, suffix)
    endfor
endfunction

function! MapLeader(opts, trigger, command)
  " Document in which_key_map
  if IsString(a:command)
    " Create mapping of form g:which_key_map['a']['b']
    let components = split(a:trigger, ' ')
    let final_index = components[-1]
    let index_path = CreateDicts('g:which_key_map', components[:-2])

    " Execute g:which_key_map['a']['b']['c'] = a:command
    call CreateIfNotExists(DictIndex(index_path, final_index), a:command)
  endif

  call Map(a:opts, '<leader> ' . a:trigger, a:command)
endfunction

function! MapKeys(opts, trigger, keys)
    let opts = Opts(a:opts)
    let extra = Maybe(opts.Has('b'), '<buffer> ')

    for m in opts.Intersecting(s:modes)
        call s:rawMap(m, extra, a:trigger, "\<C-\>\<C-n>", a:keys, '')
    endfor
endfunction

call Map('n', '<leader>', "WhichKey '<space>'")
call which_key#register('<space>', 'g:which_key_map')

call Map('nvic', '<Left>',  'echo "You must never use arrow keys!"')
call Map('nvic', '<Right>', 'echo "You must never use arrow keys!"')
call Map('nvic', '<Up>',    'echo "You must never use arrow keys!"')
call Map('nvic', '<Down>',  'echo "You must never use arrow keys!"')

call Map('n', '<C-s>', 'w')

call MapLeader('n', 'H',   'split')
call MapLeader('n', 'V',   'vsplit')
call MapLeader('n', '1',   'only')
call MapLeader('n', 'q',   'close')
call MapLeader('n', 'n',   'enew')
call MapLeader('n', 's',   'wall')
call MapLeader('n', 'b k', 'bdelete!')
call MapLeader('n', '%',   'source ' . g:VimrcDirReal . '/init.vim')
call MapLeader('n', 'o',   'silent! !tmux new-window -c %:p:h')
call MapLeader('n', 'c c', 'make')

call MapKeys('n', '<leader> .', ':e %:p:h/')
call MapKeys('n', '<leader> :', 'q:')
call MapKeys('n', 'D',         '0d$')

function! g:BigText()
    " Run figlet on line
    let output = system('figlet', getline('.'))
    let lines = split(output, "\n")

    " Last line is always empty because of trailing newline
    call remove(lines, -1)

    " Append figlet text
    call append(line('.'), lines)

    " Comment out
    exec '.,.+' . len(lines) . 'Commentary'

    " Delete current line
    normal! "_dd
endfunction

call MapLeader('n', 'b t', 'call BigText()')

" Move left/right easier
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <M-h> <C-Left>
cnoremap <M-l> <C-Right>
