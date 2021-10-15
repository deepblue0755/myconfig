cabbrev qa  <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
cabbrev qa! <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
cabbrev wqa  <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
cabbrev wqa! <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
cabbrev wq <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
cabbrev wq! <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
cabbrev q <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
cabbrev q! <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'echo' : 'q')<CR>
noremap <C-C> :e<Cr>
