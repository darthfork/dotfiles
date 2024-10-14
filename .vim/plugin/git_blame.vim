function GitBlame()
    " Get the current file path and directory
    let current_file = resolve(expand('%:p'))
    let current_dir = fnamemodify(current_file, ":h")

    " Get the start and end lines for the Git log command
    let start_line = line("v")
    let end_line = line(".")

    " Build the git log command
    let git_command = "cd " . shellescape(current_dir) .
          \ " && git log --no-merges -n 1 -L " . shellescape(start_line . "," . end_line . ":" . current_file)

    " Call systemlist with the git command
    let blame_output = systemlist(git_command)

    " Display the output in a popup window
    call setbufvar(
          \ winbufnr(popup_atcursor(blame_output, {
          \ 'padding': [1,1,1,1], 'pos': 'botleft', 'wrap': 0 })),
          \ '&filetype', 'git')
endfunction

:command! -nargs=0 GitBlame :call GitBlame()
