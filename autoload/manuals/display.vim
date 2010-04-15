" vim:set fileencoding=utf-8 sw=3 ts=8 et:vim
"
" Author: Marko Mahnič
" Created: March 2010
" License: GPL (http://www.gnu.org/copyleft/gpl.html)
" This program comes with ABSOLUTELY NO WARRANTY.

if vxlib#plugin#StopLoading('#au#vxlib#manuals_d')
   finish
endif

" =========================================================================== 
" Local Initialization - on autoload
" =========================================================================== 
" call vxlib#python#prepare() Note: This will be called by vimuiex when used
exec vxlib#plugin#MakeSID()
" =========================================================================== 

" Displayers

" Display text
function! vxlib#manuals_d#Echo(rslt)
   for line in a:rslt[1]
      echo line . "\n"
   endfor
endfunc


" Select a choice from list
function! vxlib#manuals_d#InputList(rslt)
   let choices = []
   let i = 0
   for chc in a:rslt[1][0:&lines-3]
      call add(choices, (i + 1) . '. ' . a:rslt[1][i])
      let i += 1
   endfor
   
   let sel = inputlist(choices)
   if sel == '' | return -1 | endif
   let nsel = 0 + sel
   if nsel < 1 || nsel > len(choices)
      return -1
   endif
   return nsel - 1
endfunc


" Use an existing QuickFixList.
" Doesn't return anything, the QuickFixList is a self-contained displayer.
function! vxlib#manuals_d#QuickFixList(rslt)
   copen
endfunc


" Display text
function! vxlib#manuals_d#OpenPreview(rslt)
   let lines = a:rslt[1]
   let pos = getpos(".")
   let win = winnr()
   pedit ***Manual***
   silent! wincmd P
   if ! &previewwindow
      call setpos(".", pos)
      return
   endif
   exec "resize " . &lines / 2
   b ***Manual***
   setl buftype=nofile
   setl noreadonly
   norm ggVGd
   call setline(1, lines)
   norm gg
   setl readonly
   exec win . "wincmd w"
   call setpos(".", pos)
endfunc


" Display text
" TODO: title&cmd might be additional parameters
" TODO: currently using VxPopup (list of items); need to implement 'textbox' in vimuiex
" TODO: if type contains 'b', load items from a buffer
function! vxlib#manuals_d#OpenVxText(rslt)
   let popopt = {}
   call vimuiex#vxlist#VxPopup(a:rslt[1], 'Manual-Text', popopt)
endfunc

function! s:VxcbInitOpenGrepResults(pyListVar)
   " Items that start with number and colon are NOT title items; others are
   exec 'python ' . a:pyListVar . '.setTitleItems(r"^\s*\d+:", 0)'
   exec 'python ' . a:pyListVar . '.hasTitles = True'
endfunc

" Select a choice from a grep or keyword list
" TODO: add handlers for two types of lists: keywrods and grep results
"    keywords: should rerun the search on a single keyword to get text
"    grep results: should jump to result
" TODO: Get the title from the caller
function! vxlib#manuals_d#OpenVxList(rslt)
   let popopt = {}
   if a:rslt[0] =~ 'h'
      let popopt['init'] = s:SNR . 'VxcbInitOpenGrepResults'
      let popopt['current'] = 1
   endif
   let slctd = vimuiex#vxlist#VxPopup(a:rslt[1], 'Manual-List', popopt)
   if len(slctd) < 1
      return -1
   endif
   return slctd[0]
endfunc

" Select a choice from a menu
" TODO: Get the title from the caller
function! vxlib#manuals_d#OpenVxMenu(rslt)
   let popopt = {}
   let slctd = vimuiex#vxlist#VxPopup(a:rslt[1], 'Menu', popopt)
   if len(slctd) < 1
      return -1
   endif
   return slctd[0]
endfunc


" =========================================================================== 
" Global Initialization - Processed by Plugin Code Generator
" =========================================================================== 
finish

" id=display-function
" Types of display:
"    - text
"    - list of keywords (one will be selected used in next search)
"    - list of grep results (one will be selected an displayed)
"    - menu (select a getter to execute)
"    @see: <url:manuals.vim#r=flagdefs>
"
" * Function for Menu
"   Must return the index of the selected item.
"   The index will be used by ShowManual to execute the selected getter.
"   If index is less than 0, ShowManual will end.
"
"   Alternative: the function gets a callback function to call when an item
"   is selected. ShowManual doesn't process the functions result. The function
"   will execute the selected getter.
"
" * Function for List of keywords
"   Must return the index of the selected item.
"   The index will be used by ShowManual to find the text for the item.
"   (The getter may provide a function to extract the keyword from an item).
"
"   Alternative: the function gets a callback function to call when an item
"   is selected. ShowManual doesn't process the functions result. The function
"   will execute a getter (TODO: which one?).
"
" * Function for Grep results
"   Must return the index of the selected item.
"   The index will be used by ShowManual to find the text for the item.
"   (The getter should provide the list of items in standard format: something
"   like '[I' or grep).
"
"   Alternative: the function gets a callback function to call when an item
"   is selected. ShowManual doesn't process the functions result. The function
"   will process the item an display the text.
"
"   Alternative: the displayer is self-contained and ignores the parameters
"   from ShowManual. Examples: qfixlist, locationlist, VxOccur-ShowResults.
"
" * Function for text
"   Displays the recieved text.
"   Doesn't need to return anything.
"
" Types of input 
"    - l: array (list) of strings
"    - b: ordinary buffer
"    - q, o: qfixlist, locationlist
"
" The displayer must define the types of input it can handle, in order of
" preference. The getters can inspect this order to prepare the data in the
" desired format. If a getter doesn't provide a format supported by the
" displayer, ShowManual may convert the getters result into displayers format.

" <PLUGINFUNCTION id="vxlib#var-mandisplaylist">
if !exists("g:VxlibManuals_NewDisplayers")
   let g:VxlibManuals_NewDisplayers = []
endif
" </PLUGINFUNCTION>
" <PLUGINFUNCTION id="vxlib#addtextdisplay" name="VxMan_AddTextDisplay">
function! s:VxMan_AddTextDisplay(name, dispfn, datatypes)
   call add(g:VxlibManuals_NewDisplayers, ['t', a:name, a:dispfn, a:datatypes])
endfunc
" </PLUGINFUNCTION>
" <PLUGINFUNCTION id="vxlib#addmenudisplay" name="VxMan_AddMenuDisplay">
function! s:VxMan_AddMenuDisplay(name, dispfn)
   call add(g:VxlibManuals_NewDisplayers, ['m', a:name, a:dispfn, ''])
endfunc
" </PLUGINFUNCTION>
" <PLUGINFUNCTION id="vxlib#addlistdisplay" name="VxMan_AddListDisplay">
function! s:VxMan_AddListDisplay(name, dispfn, datatypes)
   call add(g:VxlibManuals_NewDisplayers, ['k', a:name, a:dispfn, a:datatypes])
endfunc
" </PLUGINFUNCTION>
" <PLUGINFUNCTION id="vxlib#addgrepdisplay" name="VxMan_AddGrepDisplay">
function! s:VxMan_AddGrepDisplay(name, dispfn, datatypes)
   call add(g:VxlibManuals_NewDisplayers, ['g', a:name, a:dispfn, a:datatypes])
endfunc
" </PLUGINFUNCTION>

" <VIMPLUGIN id="vxlib#showmanual_d" >
   call s:VxMan_AddMenuDisplay('choice', 'vxlib#manuals_d#InputList')

   call s:VxMan_AddTextDisplay('echo', 'vxlib#manuals_d#Echo', 'lb')
   call s:VxMan_AddTextDisplay('preview', 'vxlib#manuals_d#OpenPreview', 'bl')

   call s:VxMan_AddListDisplay('choice', 'vxlib#manuals_d#InputList', 'l')
   call s:VxMan_AddGrepDisplay('choice', 'vxlib#manuals_d#InputList', 'l')
   call s:VxMan_AddGrepDisplay('qfixlist', 'vxlib#manuals_d#QuickFixList', 'q')

   "call s:AddGrepDisplay('qfixlist', 'vxlib#manuals_d#QFixList', 'qo')

   if s:PluginExists('vimuiex#vxlist', 'autoload/vimuiex/vxlist.vim')
      call s:VxMan_AddMenuDisplay('vimuiex', 'vxlib#manuals_d#OpenVxMenu')

      call s:VxMan_AddTextDisplay('vimuiex', 'vxlib#manuals_d#OpenVxText', 'lb')

      call s:VxMan_AddListDisplay('vimuiex', 'vxlib#manuals_d#OpenVxList', 'l')
      call s:VxMan_AddGrepDisplay('vimuiex', 'vxlib#manuals_d#OpenVxList', 'l')
   endif

   if s:PluginExists('tlib', 'plugin/02tlib.vim')
      call s:VxMan_AddListDisplay('tlib', 'vxlib#manuals_d#OpenTlibList', 'bl')
      call s:VxMan_AddGrepDisplay('tlib', 'vxlib#manuals_d#OpenTlibList', 'bl')
   endif
" </VIMPLUGIN>

