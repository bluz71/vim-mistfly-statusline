function! moonfly_statusline#shortFilePath()
    if &buftype == "terminal"
        return expand("%:t")
    else
        let l:path = expand("%:f")
        if len(l:path) == 0
            return ""
        else
            return pathshorten(fnamemodify(expand("%:f"), ":~:."))
        endif
    endif
endfunction

" The following Git branch functionality derives from:
"   https://github.com/itchyny/vim-gitbranch
"
" MIT Licensed Copyright (c) 2014-2017 itchyny
"
function! moonfly_statusline#gitBranch() abort
    if get(b:, "gitbranch_pwd", "") !=# expand("%:p:h") || !has_key(b:, "gitbranch_path")
        call moonfly_statusline#gitDetect()
    endif

    if has_key(b:, "gitbranch_path") && filereadable(b:gitbranch_path)
        let l:branchDetails = get(readfile(b:gitbranch_path), 0, "")
        if l:branchDetails =~# "^ref: "
            return substitute(l:branchDetails, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', "", "")
        elseif l:branchDetails =~# '^\x\{20\}'
            return l:branchDetails[:6]
        endif
    endif

    return ""
endfunction

function! moonfly_statusline#gitDetect() abort
    unlet! b:gitbranch_path
    let b:gitbranch_pwd = expand("%:p:h")
    let l:dir = moonfly_statusline#gitDir(b:gitbranch_pwd)

    if l:dir !=# ""
        let l:path = l:dir . "/HEAD"
        if filereadable(l:path)
            let b:gitbranch_path = l:path
        endif
    endif
endfunction

function! moonfly_statusline#gitDir(path) abort
    let l:path = a:path
    let l:prev = ""

    while l:path !=# prev
        let l:dir = path . "/.git"
        let l:type = getftype(l:dir)
        if l:type ==# "dir" && isdirectory(l:dir . "/objects") 
                    \ && isdirectory(l:dir . "/refs") 
                    \ && getfsize(l:dir . "/HEAD") > 10
            " Looks like we found a '.git' directory.
            return l:dir
        elseif l:type ==# "file"
            let l:reldir = get(readfile(l:dir), 0, '')
            if l:reldir =~# "^gitdir: "
                return simplify(l:path . "/" . l:reldir[8:])
            endif
        endif
        let l:prev = l:path
        " Go up a directory searching for a '.git' directory.
        let path = fnamemodify(l:path, ":h")
    endwhile

    return ""
endfunction
