"=============================================================================
" FILE: tag_jump.vim
" AUTHOR: Eiichi Sato <sato.eiichi@gmail.com>
" Last Modified: 30 Jan 2012
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:kind = {
	\ 'name': 'tag_jump',
	\ 'default_action': 'open',
	\ 'action_table': {},
	\ 'parents': ['openable']
	\ }

let s:kind.action_table.open = {
	\ 'description': 'jump to this tag',
	\ 'is_selectable': 0,
	\ 'is_quit': 1
	\ }
function! s:kind.action_table.open.func(candidate)
	execute 'silent! tselect' a:candidate.action__tselect
	execute a:candidate.action__number.'tfirst'
endfunction

function! unite#kinds#tag_jump#define()
	return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
