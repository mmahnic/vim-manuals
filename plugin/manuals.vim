
" ShowManual can be called with a key or with a command.
"  with key
"     - expand cword or cWORD or let the plugin do it (w1 = '')
"     - pass possible range
"     - plugins have to account for w1='' and should extract the word
"       themselves
"     - the position has to be restored afterwards (ShowManual can do that)
"  with command
"     - enter word
"     - enter additional parameters (-k, ...)
"
" The extractor function should get the information, what will be done with
" the result next - what kind of result does the displayer require so that it
" can prepare the results accordingly. ie. the type ('buffer', 'array', ...)
" should be in VxlibManual_Display, not in VxlibManual_Getters.
"    - get a getter
"    - get the displayer for the getter type
"    - get the expected input-type for displayer
"    - pass the input-type when calling the getter
"
" TODO: define the command that calls ShowManual
if !vxlib#plugin#StopLoading('manuals-showmanual')
   call vxlib#plugin#CheckSetting('g:manuals_help_buffer', '"*Manual*"')
   nmap <silent> <unique> <Plug>VxManText :call manuals#core#ShowManual(v:count,'','t')<cr>
   vmap <silent> <unique> <Plug>VxManText :<C-U>call manuals#core#ShowManual(v:count,visualmode(),'t')<cr>
   nmap <silent> <unique> <Plug>VxManKeyword :call manuals#core#ShowManual(v:count,'','k')<cr>
   vmap <silent> <unique> <Plug>VxManKeyword :<C-U>call manuals#core#ShowManual(v:count,visualmode(),'k')<cr>
   nmap <silent> <unique> <Plug>VxManGrep :call manuals#core#ShowManual(v:count,'','g')<cr>
   vmap <silent> <unique> <Plug>VxManGrep :<C-U>call manuals#core#ShowManual(v:count,visualmode(),'g')<cr>
   nmap <silent> <unique> <Plug>VxManMenu :call manuals#core#ShowManual(v:count,'','m')<cr>
   vmap <silent> <unique> <Plug>VxManMenu :<C-U>call manuals#core#ShowManual(v:count,visualmode(),'m')<cr>
endif

if !vxlib#plugin#StopLoading('manuals-maps')
   nmap K <Plug>VxManText
   vmap K <Plug>VxManText
   nmap <leader>kk <Plug>VxManKeyword
   vmap <leader>kk <Plug>VxManKeyword
   nmap <leader>kg <Plug>VxManGrep
   vmap <leader>kg <Plug>VxManGrep
   nmap <leader>km <Plug>VxManMenu
   vmap <leader>km <Plug>VxManMenu
endif
