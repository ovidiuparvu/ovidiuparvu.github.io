---
layout: post
title: Vim cheatsheet
comments: true
tags: [vim,editor,cheatsheet]
---

A vim cheatsheet created while reading <a href="https://pragprog.com/titles/dnvim2/practical-vim-second-edition">Practical Vim, Second Edition</a>, is given below.


# Undo/redo

`.` - Repeats last change (including what happened from the moment one enters the Insert mode until one returns to the Normal mode)  
`;` - Repeat last search that the `f` command performed  
`,` - Repeat last search that the `f` command performed in the reverse direction  
`n` - Repeat last search  
`N` - Repeat last search in reverse  
`&` - Repeat last substitution  
`@x` - Repeat sequence of changes recorded  in register x (using qx{changes}q)  
`@:` - Repeat the last Ex command  

`u` - Undo last change  
`<C-r>` - Redo last change  


# Jumping

`0` - Jump to beginning of line  
`$` - Jump to EOL  
`^` - Jump to beginning of non-whitespace line contents  
`f/F{char}` - Scan line for next/previous character {char} and jump to it  
`t/T{char}` - Scan line for next/previous character {char} and jump immediately before it  
`/pattern<CR>` - Jump to next <pattern> match  
`?pattern<CR>` - Jump to previous <pattern> match  
`<C-r><C-w>` - Autocomplete the search field using the remainder of the current preview match  

`<C-]>` - Jump to definition (if ctags is configured)  

`zz` - Redraw the screen with the current line in the vertical middle of the window  


# Modes

`i` - Enter Insert mode  
`r` - Enter Replace mode for a single character  
`R` - Enter Replace mode  
`<C-g>` - Toggle between Visual and Select mode  
`v` - Enter character-wise Visual mode  
`V` - Enter line-wise Visual mode  
`<C-v>` - Enter block-wise Visual mode  
`gv` - Reselect the last visual selection  
`:` - Enter command line mode  

`q/` - Open command-line window  


# Buffers, windows and tabs

`:ls` - List all buffers that have been loaded into memory  
`:args` - Populate or list contents of the argument list  
`:w[rite]` - Write the contents of the buffer to disk  
`:w !sudo tee % >/dev/null` - Write the contents of the buffer to disk using sudo permissions  
`:e[dit]!` - Re-read from disk the file corresponding to the current buffer  
`:wa[ll]` - Write all modified buffers to disk  
`:qa[ll]` - Close all windows, discarding changes without warning  

`<C-w>v` - Split window vertically  
`<C-w>s` - Split window horizontally  
`<C-w>w` - Cycle between open windows  
`<C-w>h` - Focus the window to the left  
`<C-w>j` - Focus the window below  
`<C-w>k` - Focus the window above  
`<C-w>l` - Focus the window to the right  
`<C-w>c` - Close the active window  
`<C-w>o` - Only leave the active window open  
`<C-w>=` - Equalize width and height of all windows  

`:tabe[dit] {filename}` - Open {filename} in a new tab  
`<C-w>T` - Move the current window into its own tab  
`:tabc[lose]` - Close the current tab page and all of its windows  
`:tabo[nly]` - Keep the active tab page, close all others  
`:tabn[ext] {N}` - Switch to tab page number {N} ({N}gt in normal mode)  
`:tabn[ext] {N}` - Switch to next tab page (gt in normal mode)  
`:tabp[revious]` - Switch to the previous tab page (gT in normal mode)  

`:edit %<Tab>` - % symbol is a shorthand for the filepath of the active buffer  
`:edit %:h<Tab>` - The :h modifier removes the filename while preserving the rest of the path  
`:find {filename}` - Open a file by its filename (without fully qualifying it with the absolute path)  
`:edit .` - Open file explorere for current working directory  
`:Explore` - Open file explorer for the directory of the active buffer  

`<C-g>` - Echo the name and status of the current file  


# Marks

`m{a-zA-Z}` - Create a mark at the current cursor location with the designated letter  
`'{mark}` - Jump to the line where the mark was set  
`` `{mark}`` - Jump to the cursor location of where the mark was set  


# Commands

`:vim[grep][!] /{pattern}/[g][j] {file} ...` - Project-wide search  
`:copen` - Open quickfix window  
`:cfdo {cmd}` - Run {cmd} against all files in the quickfix window  

`:[range] global[!] /{pattern}/ {cmd}` - Run Ex command {cmd} against all lines in [range] matching {pattern}  
`:[range] vglobal/v[!] /{pattern}/ {cmd}` - Run Ex command {cmd} against all lines in [range] that do not match {pattern}  

# Registers

`"{register}` - Reference a particular register  
`"_` - Black hole register  
`""` - Unnamed register  
`"0` - yank register  
`:reg "0` - Inspect the contents of the yank register  
`"+` - System clipboard  
`"*` - Selection register  
`"=` - Expression register  
`"%` - Name of the current file  
`"#` - Name of the alternate file  
`".` - Last inserted text  
`":` - Last Ex command  
`"/` - Last search pattern  
`<C-r>{register}` - Paste contents of {register} register  


# Macros

`q{register}` - Start recording into {register} register  
`q{uppercase register}` - Append to the {register} register  
`q` - Stop recording  
`@{register}` - Execute the contents of the {register} register  
`@@` - Repeat macro invoked most recently  
`:put {register}` - Paste the contents of the {register} register into the buffer  


# Jump list

`:jumps` - List contents of jump list  
`<C-o>` - Jump back  
`<C-i>` - Jump forward  
`[count]G` - Jump to line number  
`/pattern<CR>/?pattern<CR>/n/N` - Jump to next/previous occurrence of pattern  
`%` - Jump between opening and closing sets of parentheses  
`(/)` - Jump to start of previous/next sentence  
`{/}` - Jump to start of previous/next paragraph  
`H/M/L` - Jump to top/middle/bottom of screen  
`gf` - Jump to file name under the cursor  
`<C-]>` - Jump to definition of keyword under the cursor  


# Change list

`:changes` - Open the change list  
`g,` - Jump to next change in the change list  
`g;` - Jump to the previous change in the change list  
`gi` - Resume from last position from which we exited Insert mode  


# Automatic marks

```` `` ```` - Position before the last jump within the current file  
``` `. ``` - Position of last change  
``` `^ ``` - Location of last insertion  
``` `[ ``` - Start of last change or yank  
``` `] ``` - End of last change or yank  
``` `< ``` - Start of last visual selection  
``` `> ``` - End of last visual selection  


# Text objects

Vim's text objects consist of two characters, the first of which is always either i (i.e. inside) or a (i.e. around).

`i/a{)}]>'"`}` - inside/around {)}]>'"`}  
`i/a{t}` - inside/around tags  
`i/a{w}` - inside/around words  
`i/a{s}` - inside/around sentences  
`i/a{p}` - inside/around paragraphs  


# Compound commands

`C == c$` (change until EOL)  
`s == cl` (change letter)  
`S == ^C` (jump to beginning of non-whitespace line contents and change until EOL)  
`I == ^i`  
`A == $a`  
`o == A<CR>`  
`O == ko`  

# Motions

`j` - Down one real line  
`gj` - Down one display line  
`k` - Up one real line  
`gk` - Up one display line  
`0` - The first character of real line  
`g0` - The first character of display line  
`^` - The first nonblank character of real line  
`g^` - The first nonblank character of display line  
`$` - The end of real line  
`g$` - The end of display line  
`w` - Forward to start of next word  
`b` - Backward to start of current/previous word  
`e` - Forward to end of current/next word  
`ge` - Backward to end of previous word  


# Operators

`c` - Change  
`d` - Delete  
`y` - Yank into register  
`g~` - Swap case  
`gu` - Make lowercase  
`gU` - Make uppercase  
`>` - Shift right  
`<` - Shift left  
`=` - Autoindent  
`!` - Filter {motion} lines through an external program  


# Autocomplete

`<C-n>` - Invoke generic keyword autocompletion  
`<C-x><C-n>` - Invoke current buffer keyword autocompletion  
`<C-x><C-i>` - Invoke included file keyword autocompletion  
`<C-x><C-]>` - Invoke tags file keyword autocompletion  
`<C-x><C-k>` - Invoke dictionary lookup autocompletion  
`<C-x><C-l>` - Invoke whole line autocompletion  
`<C-x><C-f>` - Invoke filename autocompletion  
`<C-x><C-o>` - Invoke omni-completion  


# Autocomplete pop-up menu commands

`<C-n>` - Use the next match  
`<C-p>` - Use the previous match  
`<Down>` - Select the next match from the word list  
`<Up>` - Select the previous match from the word list  
`<C-y>` - Accept the currently selected match  
`<C-e>` - Exit and revert to the originally typed text  
`<C-h>` - Delete one character from current match  
`<C-l>` - Add one character from current match  
`{char}` - Stop completion and insert {char}  


# Insert mode

`<C-h>` - Delete back one character (like backspace)  
`<C-w>` - Delete back one word  
`<C-u>` - Delete back to start of line  
`<C-o>` - Switch to Insert Normal mode  
`<C-r>{register}` - Insert contents of register {register}  
`<C-r>=` - Access the expression register  
`<C-v>{code}` - Insert character using its numeric code.  
`<C-v>u{code}` - Insert Unicode character  
`<C-v>{nondigit}` - Insert nondigit literally  
`<C-k>{char1}{char2}` - Insert character represented by {char1}{char2} digraph  


# Visual mode

`o` - Go to the other end of highlighted text  

# Command line mode

`:[range]delete [x]` - Delete specified lines [into register x]  
`:[range]yank [x]` - Yank specified lines [into register x]  
`:[line]put [x]` - Put text from register x after the specified line  
`:[range]copy {address}` - Copy the specified lines to below the line specified by {address}. Shorthand - :t  
`:[range]move {address} `- Move the specified lines to below the line specified by {address}. Shorthand - :m  
`:[range]join` - Join the specified lines  
`:[range]normal {commands}` - Execute Normal mode {commands} on each specified line  
`:[range]substitute/{pattern}/{string}/[flags]` - Replace occurrences of {pattern} with {string} on each specified line  
`:[range]global/{pattern}/[cmd]` - Execute the Ex command [cmd] on all specified lines where the {pattern} matches  
`:shell` - Start an interactive shell session from vim  
`:read !{cmd}` - Put the output from {cmd} into our current buffer  
`:[range]write !{cmd}` - Pass the contents of the lines from the current buffer as standard input to the external command {cmd}  
`:[range]!{filter}` - Filter the specified [range] through external program {filter}  
`:source {file}` - Run all the Ex commands from {file} against the current buffer  
`<C-d>` - Show list of possible (auto-)completions  
`<C-r><C-w>` - Copy word under cursor and insert it at the command-line prompt  
`<C-f>` - Switch fom command-line mode to the command-line window  
`q/` - Open the command-line window with history of searches  
`q:` - Open the command-line window with history of Ex commands  


# Patterns

`\v` switch at the start of a search pattern enables the very magic search mode, which causes all subsequent characters to take on a special meaning.  
`\V` switch at the start of a search pattern  enables the verbatim search mode.  
`\x` character class stands for [0-9A-Fa-f].  
`\zs`, `\ze` - for cropping a match  
`/{pattern}/e` - Search and place the cursor at the end of any matches rather than at the start  


# Ranges - {start},{end}

`{start}` and `{end}` are addresses.


# Addresses - {address}

They can be specified using a line number, a mark or a pattern.

Special address symbols:
`0` - Virtual line before first line of file  
`1` - First line of file  
`.` - Current line  
`$` - Last line of file   
`%` - All lines in the current file  
`'m` - Line containing mark m  
`'<` - First line of visual selection  
`'>` - Last line of visual selection  

Offsets: Addresses can include offsets.  
`{address}+n`


# Modes

- Normal
- Insert
- Replace (like Insert but overwrites existing text)
- Visual (character-wise, block-wise, line-wise)
- Select (like Visual but selected text will be replaced when typing)
- Command line


# Tabs and Spaces options:

- `tabstop`: Number of spaces that a <Tab> counts for
- `softtabstop`: Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>
- `shiftwidth`: Number of spaces to use for each indent in Normal mode
- `expandtab`: Insert spaces instead of <Tab>


# Uncategorized

- The Dot Formula: Use one keystroke to move and one keystroke to execute
- Change in vim: Everything that happens from when we enter Insert mode until we return to Normal mode.
    Cursor keys (e.g. up, down) reset the change.
- Action = operator + motion.
- When an operator command is invoked in duplicate, it acts upon the current line.
- Install exhuberant-ctag Debian package for using ctags on Linux.


# Plugins to consider:

`commentary.vim` - Adds command for (un)commenting lines of code in all languages supported by Vim.  
`unimpaired.vim` - Mappings for scrolling through the argument, quickfix, location, tag and buffer list.  
`vim-visual-star-search` - Make it easy to search for the selected text  
`vim-abolish` - Supercharged substitute command  


# Config to consider

`set history=2000` - length of vim command history, which is persisted across sessions  
`set wildmenu` - operate command-line completion in an enhanced mode  
`set wildmode=full` - complete the next full match  
`cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'` - when we type %% on vim's c: command-line prompt, it automatically expands to the path of the active buffer  
`set hlsearch` - highlight search matches  
`set incsearch` - Enable incremental searching  
`set smartcase` - Vim will attempt to predict out case sensitivity intentions  
`nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>` - Mute search highlighting when redrawing screen  
`filtetype plugin on` - Enable the file-type detection plugin which enables to customize your config based on the type of the file in the current buffer  

