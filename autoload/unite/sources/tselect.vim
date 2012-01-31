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

function! s:source.hooks.on_init(args, context)
endfunction

function! s:format_tag(tag)
	return '['. a:tag.kind . '] ' . a:tag.name . '   ' . a:tag.cmd . '   ' . a:tag.filename
endfunction

function! s:source.gather_candidates(args, context)
	let l:result = []
	let l:expr = get(a:args, 0, '') " FIXME: defaults to last used tag

	let l:taglist = taglist(l:expr)
	for l:tag in l:taglist
		let l:item = {
			\ 'word': s:format_tag(l:tag),
			\ 'source': 'tselect',
			\ 'kind': 'tag_list',
			\ 'action__tag_cmd': l:tag.cmd,
			\ 'action__tag_filename': l:tag.filename
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
