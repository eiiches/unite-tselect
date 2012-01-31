"=============================================================================
" FILE: tag_list.vim
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
	\ 'name': 'tag_list',
	\ 'default_action': 'open',
	\ 'action_table': {},
	\ 'parents': ['openable']
	\ }

function! s:convert_cmd(cmd)
	" The ex-command 'cmd' can be either an ex search pattern, a
	" line number or a line number followed by a byte number.

	let l:cmd = a:cmd
	let l:cmd = substitute(l:cmd, '/^', '/^\\C', 'g')
	let l:cmd = substitute(l:cmd,  '\*',  '\\\*', 'g')
	let l:cmd = substitute(l:cmd,  '\[',  '\\\[', 'g')
	let l:cmd = substitute(l:cmd,  '\]',  '\\\]', 'g')

	return l:cmd
endfunction

function! s:jump_cmd(cmd)
	silent! execute s:convert_cmd(a:cmd)
endfunction

let s:kind.action_table.open = {
	\ 'description': 'jump to this tag',
	\ 'is_selectable': 0,
	\ 'is_quit': 1
	\ }
function! s:kind.action_table.open.func(candidate)
	silent edit
		\ +call\ s:jump_cmd(a:candidate.action__tag_cmd)
		\ `=a:candidate.action__tag_filename`
endfunction

let s:kind.action_table.preview = {
	\ 'description': 'preview this tag',
	\ 'is_selectable': 0,
	\ 'is_quit': 0
	\ }
function! s:kind.action_table.preview.func(candidate)
	silent pedit
		\ +call\ s:jump_cmd(a:candidate.action__tag_cmd)
		\ `=a:candidate.action__tag_filename`
endfunction

function! unite#kinds#tag_list#define()
	return s:kind
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
