function! kaigyo#formatexpr()
  let target_text = getline(v:lnum)
  let tempname = tempname()
  call writefile([target_text], tempname)
  let budoux_path = expand('<sfile>:p:h') . '/node_modules/.bin/budoux'
  let segments = system('cat ' . tempname . ' | ' . budoux_path)
  call delete(tempname)

  let memo = ''
  let result = []

  for segment in split(segments)
    if strdisplaywidth(memo) + strdisplaywidth(segment) > &tw
      call add(result, memo)
      let memo = ''
    endif
    let memo = memo . segment
  endfor
  call add(result, memo)
  normal dd
  call append(v:lnum - 1, result)
  call cursor(v:lnum + len(result) - 1, 1000)
endfunction
