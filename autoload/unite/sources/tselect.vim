"=============================================================================
" FILE: tselect.vim
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

let s:source = {
	\ 'name': 'tselect',
	\ 'description': 'candidates from :tselect',
	\ 'hooks': {}
	\ }

" {{{ tselect parser

function! s:parse_tselect_line_is_entry(line, columns)
	let l:number = s:parse_tselect_entry_get_number(a:line, a:columns)
	return l:number != 0
endfunction

function! s:parse_tselect_entry_get_is_current(line, columns)
	return a:line[a:columns.current] == '>'
endfunction

function! s:parse_tselect_entry_get_number(line, columns)
	try
		return eval(a:line[a:columns.current + 1 : a:columns.number + 1])
	catch
		return 0
	endtry
endfunction

function! s:parse_tselect_entry_get_priority(line, columns)
	return a:line[a:columns.priority : a:columns.kind - 1]
endfunction

function! s:parse_tselect_entry_get_kind(line, columns)
	return a:line[a:columns.kind : a:columns.tag - 1]
endfunction

function! s:parse_tselect_entry_get_tag(line, columns)
	return a:line[a:columns.tag : a:columns.file - 1]
endfunction

function! s:parse_tselect_entry_get_file(line, columns)
	return a:line[a:columns.file:]
endfunction

function! s:parse_tselect_entry(line, columns)
	return {
		\ 'is_current': s:parse_tselect_entry_get_is_current(a:line, a:columns),
		\ 'number': s:parse_tselect_entry_get_number(a:line, a:columns),
		\ 'kind': s:parse_tselect_entry_get_kind(a:line, a:columns),
		\ 'priority': s:parse_tselect_entry_get_priority(a:line, a:columns),
		\ 'tag': s:parse_tselect_entry_get_tag(a:line, a:columns),
		\ 'file': s:parse_tselect_entry_get_file(a:line, a:columns),
		\ 'lines': []
		\ }
endfunction

function s:parse_tselect_header(line)
	return {
		\ 'current': 0,
		\ 'number': match(a:line, '#', 0),
		\ 'priority': match(a:line, 'pri', 0),
		\ 'kind': match(a:line, 'kind', 0),
		\ 'tag': match(a:line, 'tag', 0),
		\ 'file': match(a:line, 'file', 0)
		\ }
endfunction

function! s:parse_tselect(str)
	let l:result = []

	" convert to list
	let l:strlist= split(a:str, '\n')

	" split into header and entries
	let l:header = l:strlist[0]
	let l:entries = l:strlist[1:-2]

	" header columns, used to split entry
	let l:columns = s:parse_tselect_header(l:header)

	let l:i = 0
	let l:item = {}
	while l:i < len(l:entries)
		if s:parse_tselect_line_is_entry(l:entries[l:i], columns)
			if !empty(l:item)
				call add(l:result, l:item)
				let l:item = {}
			endif
			let l:item = s:parse_tselect_entry(l:entries[l:i], columns)
		else
			if has_key(l:item, 'lines')
				call add(l:item.lines, l:entries[l:i])
			endif
		endif
		let l:i += 1
	endwhile
	if !empty(l:item)
		call add(l:result, l:item)
		let l:item = {}
	endif

	return l:result
endfunction

" }}}

function! s:source.hooks.on_init(args, context)
endfunction

function! s:source.gather_candidates(args, context)
	let l:result = []

	let l:expr = get(a:args, 0, '')
	redir => l:tselect
	execute 'silent! tselect' l:expr
	redir END

	let l:candidates = s:parse_tselect(l:tselect)
	for l:candidate in l:candidates
		let l:title = printf('%d %s %s %s %s', l:candidate.number, l:candidate.priority, l:candidate.kind, l:candidate.tag, l:candidate.file)
		for l:line in l:candidate.lines
			let l:title .= '     ' . l:line
		endfor
		let l:item = {
			\ 'word': l:title,
			\ 'source': 'tselect',
			\ 'kind': 'tag_jump',
			\ 'action__tselect': l:expr,
			\ 'action__number': l:candidate.number
			\ }
		call add(l:result, l:item)
	endfor

	return l:result
endfunction

function! unite#sources#tselect#define()
	return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
