" vim:set fileencoding=utf-8 sw=3 ts=8 et:vim
"
" Author: Marko Mahnič
" Created: March 2012
" License: GPL (http://www.gnu.org/copyleft/gpl.html)
" This program comes with ABSOLUTELY NO WARRANTY.

if vxlib#plugin#StopLoading('#au#manuals#init')
   finish
endif

function! manuals#init#AddGetter(getterdef)
   if !exists("g:VxlibManuals_NewGetters")
      let g:VxlibManuals_NewGetters = []
   endif
   call add(g:VxlibManuals_NewGetters, a:getterdef)
endfunc

function! manuals#init#AddContexts(contexts, getters)
   if !exists("g:VxlibManuals_NewContexts")
      let g:VxlibManuals_NewContexts = []
   endif
   call add(g:VxlibManuals_NewContexts, [a:contexts, a:getters])
endfunc

function! s:addDisplayer(paramList)
   if !exists("g:VxlibManuals_NewDisplayers")
      let g:VxlibManuals_NewDisplayers = []
   endif
   call add(g:VxlibManuals_NewDisplayers, a:paramList)
endfunc 

function! manuals#init#AddTextDisplay(name, dispfn, datatypes)
   call s:addDisplayer(['t', a:name, a:dispfn, a:datatypes])
endfunc

function! manuals#init#AddMenuDisplay(name, dispfn)
   call s:addDisplayer(['m', a:name, a:dispfn, ''])
endfunc

function! manuals#init#AddListDisplay(name, dispfn, datatypes)
   call s:addDisplayer(['k', a:name, a:dispfn, a:datatypes])
endfunc

function! manuals#init#AddGrepDisplay(name, dispfn, datatypes)
   call s:addDisplayer(['g', a:name, a:dispfn, a:datatypes])
endfunc

