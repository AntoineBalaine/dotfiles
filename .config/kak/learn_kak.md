+=----------------------------------------------------------------------------=+
\_ _
| | | |
| | \_\_ \_\_ _ | | ** \_** \_ \_ \_ ** \_**
| |/ / / _` | | |/ / / _ \ | | | | | '_ \ / _ \
 | < | (_| | | < | (_) | | |_| | | | | | | \_\_/
|_|\_\ \__,_| |\_|\_\ \_**/ \__,_| |_| |_| \_**|

                  Mawww's experiment for a better code editor

+=----------------------------------------------------------------------------=+

This walk-through is an introduction to Kakoune's basic editing capabilities
to help new users transition over easily from another editor, or simply
learn how to write and edit documents with style.

During the learning period, it is useful to activate an automatically displayed
contextual help for commands in normal mode: `:set -add global autoinfo normal`

In the first section, you will learn about the primitives of the editing
language to be able to get to a level of knowledge of the editor that
guarantees that you can work with it efficiently.

In the second section, for users who've gone through the basics and want to
move on to more advanced functionalities, we explain other primitives whose
role has a less dominant place in an everyday editing session, but still
prove themselves powerful when used on the right occasion.

Finally, as this document is in no way an exhaustive list of features, don't
hesitate to check out the official documentation to complement your tool-set,
ask questions to more seasoned users on IRC, and check the documentation
using the built-in `:doc` command.

+=--------------------------------=+ BASICS +=--------------------------------=+

                    =[ MODES

Hit `i`, type some stuff: you’re in insert mode.
Hit `esc`, now you’re in normal mode.

                    =[ MOVEMENT

Move the cursor with arrows, or `hjkl`,

`g` opens the `goto` utility. You can hit a second key:
`gl`: line end
`gh`: line begin

                    =[ VIEW

same composability for `view`:
`vc`: view-centered
`vt`: view-topped
`vt`: view-bottomed

Let’s try it!

                    =[ SELECTIONS

`w`: next word
`w`: extend selection to next word
`b`: back (previous) word
`B`: extend selection to back (previous) word
`e`: end of next word
`E`: extend selection to end of next word

some other selectors:
`<a-b>`: whitespace-delimited "back"
`<a-w>`: whitespace-delimited "word"
`<a-e>`: whitespace-delimited "end"

Remove my AWFULMISTAKE word, using `d` (delete) or `c` (change).
Remove my AWFULMISTAKE:123:Whitespace-delimited word, using `d` (delete) or `c` (change).

`x`: line select
`;`: unselect

`d`: remove selection

** try to remove this emoji-line **
:() :D :X :»

      =[ BASIC SELECTIONS

In Kakoune, the "cursor" is a single character selection.
`;`: collapse selection to cursor
`<a-;>`: switch anchor and cursor


                    ==[ SELECTING OBJECTS

Kakoune defines "objects" like paragraphs, sentences, or words.

`<a-i>`: select inside object
`<a-a>`: select around object
`]`: select from cursor to object end
`[`: select from object beginning to cursor

After these keys, press one of these to select the specific object:
`w`: word
`s`: sentence
`p`: paragraph
`(` or `b`: parenthesis block
`{` or `B`: braces block
`[` or `r`: brackets block
`<` or `a`: angle brackets block
`"`: double quotes
`'`: single quotes
"`": backticks

Try these examples:

Place cursor inside (this parenthesis block) and press `<a-i>(` to select inside.

Place cursor inside "these quotes" and press `<a-a>"` to select quotes too.

Place cursor here:
This is a paragraph.
Press `<a-i>p` to select the paragraph contents.

Place cursor at start of line and press `]p` to select to paragraph end.

Select each word |individually| in this sentence with `<a-a>w`.

{
  Try selecting
  this entire
  braces block
}


                    ==[ MOVEMENT SELECTIONS

Objects can be used for quick movement around the buffer:

`[`: move to beginning of object
`]`: move to end of object

After these keys, press an object type:
`p`: paragraph
`s`: sentence
`w`: word

Try moving between paragraphs:

This is paragraph one.
Press `]p` to jump to the end of this paragraph.

This is paragraph two.
Press `[p` to jump to the beginning of this paragraph.

Try with sentences: This is sentence one. This is sentence two. This is sentence three.
Place cursor in middle sentence and press `]s` to jump forward or `[s` to jump backward.

Words work too. Place cursor here and use `]w` to move forward by word or `[w` to move backward.

      =[ MULTIPLE SELECTIONS
Kakoune allows multiple selections within the same buffer.
Editing commands apply to all selections simultaneously.

Example: select these words and switch anchor/cursor:
beginning end
start finish
first last

`%`: select entire buffer
`s`: select regex pattern within selection (type the pattern, then hit enter)

Try selecting all occurrences of "select" below:
Can you select every select in this paragraph?
If you select correctly, you'll select all instances of select.
Now try to select without selecting "selection".
Small hint: you can select the whole paragraph with `<a-i>p`

                    =[ FILTERING A SELECTION

After creating multiple selections, you can filter them:

`<a-k>`: keep selections matching a regex (type pattern, hit enter)
`<a-K>`: keep selections NOT matching a regex


for example:

apple123
appleXXX
appleYYY
apple987
banana456
cherry789
watermelon321

Select all lines with `<a-i>p`, then select with `sapple[^\n]*`, then keep only lines with numbers: `<a-k>[0-9]<ret>`. Now you have only 2 cursors.
Note for regex connoisseurs: this `sapple[^\n]*` had me puzzled: why not use `sapple.*` instead? Well, Kakoune’s regex match across lines by default, so the `$` anchor won’t delimit ends of lines. The only solution left is to manually match line breaks as ends of your patterns.

HTML, CSS, JavaScript, Python, Ruby, Go, Rust, C++
Select this line, split on spaces with `<a-s>`, then keep languages with 'S': `<a-k>S<ret>`

                    Selecting an entire buffer (`%`) or parts of it (`s`) is a
                    natural and basic operation in a typical editing session,
     .---, .---,    however, there are some cases where we need to be able to
     |alt|+| k |    drop some selections arbitrarily, as opposed to trying
     `---' `---'    to select the ones we need directly. This concept becomes
                    very useful when coming up with a regular expression for
     .---, .---,    the basic selection primitive (`s`) is too tedious (if
     |alt|+| K |    even possible), that's why the editor provides us with a
     `---' `---'    "keep matching" and a "keep not matching" operations,
                    in order to respectively keep exclusively the selections
                    who match or do not match a given regular expression.

                    Example: when parsing a log file whose lines follow the
                    usual log pattern (e.g. "[1484383442] ERROR: some data"),
                    we want to be able to select all the lines individually
     .---, .---,    (`%`, `<a-s>` to split all the lines), keep those that
     |alt|+| s |    start with a bracketed time-stamp (`<a-k>^\[`), but
     `---' `---'    exclude the debug messages (`<a-K>DEBUG`). Of course,
                    it's possible to come up with a regular expression to
                    match those simple requirements, but it would take more
                    work to write it than to organically apply filters on a
                    general selection, individually.


                    =[ SELECTION DUPLICATION

        .---,       Duplicating content can be achieved using a widely
        | y |       implemented concept: yanking and pasting. Yanking the
        `---'       current selection (`y`) into the copy register allows the
        .---,       user to subsequently insert the copied text in the buffer
        | p |       (`p`).
        `---'
        .---,       Note that the default "paste" primitive will insert the
        | P |       contents of the copy register after the current selection,
        `---'       if you want copied text to be inserted before the current
                    selection then you can use the `P` key.


                    =[ DELETING / REPLACING SELECTIONS

                    Text replacement is a two-step process in Kakoune, which
        .---,       involves selecting text to be replaced, and then erasing it
        | d |       to insert the replacement text. After selections have been
        `---'       made, you can simply hit the deletion primitive (`d`), then
        .---,       either enter insert mode to write down the replacement text
        | c |       (`i`), or stay in command mode to paste the replacement
        `---'       text stored in the copy register. As deleting and entering
        .---,       insert mode can be redundant, a primitive that implements
        | R |       deletion followed by insert mode entrance was implemented:
        `---'       `c`. You can also directly replace the current selection
                    with the content of the copy register using a primitive
                    also implemented for that purpose: `R`.


                    =[ UNDO / REDO

                    Mistakes or wrong decisions can happen while editing.
        .---,       To go back to earlier states of the buffer, you can press
        | u |       the `u` key several times. On the contrary, pressing `U`
        `---'       allows traveling forward in the history tree.

                    =[ SEARCH

                    In order to move the cursor to a specific word, the search
                    command is the way to go. This functionality allows
        .---,       the user to jump to the next occurrence of a piece of text.
        | / |       Upon hitting the `/` key, a prompt reading "search"
        `---'       will pop up in the status bar in which you can type
                    your text and validate using the `<ret>` (return) key.
     .---, .---,    You'll notice that as you type, the cursor changes location
     |alt|+| / |    to automatically give you a preview of where the cursor
     `---' `---'    would be displaced to if you validated the search. However,
                    this behavior is only a preview, exiting prompt mode with
                    the `<esc>` (escape) key will leave the current position
        .---,       of the cursor unchanged. Note that you can also use a
        | n |       regular expression as input.  By default the search
        `---'       function will look for results forward, starting from
                    the current location of the cursor, but you can search
     .---, .---,    backwards using `<a-/>` (alt + `/`).
     |alt|+| n |
     `---' `---'    Jumping from one match to the other forward can be achieved
                    using the `n` key, and backwards using the `<a-n>` (alt +
                    `n`) key combination.

+=-------------------------------=+ ADVANCED +=-------------------------------=+

                    =[ SPLITTING

                    The selection primitive (`s`) is a powerful tool to select
                    chunks of data, but sometimes the format of said data isn't
        .---,       uniform enough to allow creating clear cut selections. In
        | S |       order to avoid having to write overly complicated regular
        `---'       expressions that select precisely the wanted text, the
                    splitting primitive (`S`) allows applying a delimiter to
                    the current selection, splitting it into separate chunks.

                    Example: selecting the items in a CSV-style list (e.g.,
                    "1,2,3,4") is as simple as selecting the line, then
                    splitting it using the comma separator (`S,`). Note that
                    more advanced splitting is possible, since the delimiter
                    passed to this primitive is a regular expression.


                    =[ ROTATING

                    Often used in conjunction with the splitting primitive
                    (`S`), the rotation primitive (`<a-)>`) shifts all the
                    selections clock-wise. Note that a count (described after)
                    allows the rotation to take place in sub-groups whose size
     .---, .---,    is given by the count parameter.
     |alt|+| ) |
     `---' `---'    Example: in a numbered list where all the numbers are
                    selected (e.g., `1 2 3 4 5 6 7 8 9 0`), a rotation using
                    this primitive will shift all the numbers by one selection
                    forward, while leaving the original multiple selections
                    untouched (e.g., `0 1 2 3 4 5 6 7 8 9`).


                    =[ COUNTS

.---, In order to pass a count to a primitive, simply type the
|0-9|\_. number out before hitting the primitive key/combination.
`---' |`.---, Counts allow primitives to specialize or extend their
| | g | original functionality by using it as a parameter,
| `---'    acting on their side effect.
         |`.---,
| | G | Example: in order to respectively jump or select up to a
| `---'    particular line, pass the line number to the `g`or`G`
         |`.---, primitives (e.g., `42g` or `7G`).
| | o |
| `---'    Example: creating an arbitrary amount of new lines
          `.---, above or below the current line and spawning a new selection
| O | for each of them is achieved by passing the number of lines
`---'    as a count respectively to the `o`and`O` primitives.

                    =[ REGISTERS

                    Similarly to counts, registers influence the behavior of

.---, certain primitives. They are storage structures identified
| " |_. by a single character, and are populated by primitives as a
`---'  `.---, result of a side effect. Although primitives populate a
|a-z| specific register by default, it's possible to modify which
`---'    is going to be populated upon execution using the double
                    quote (`"`) primitive, and subsequently hitting a key that
        .---,       will serve as an identifier.
        | * |
        `---' Example: the smart search primitive (`*`) uses the current
selection as a search pattern, which will be saved to the
.---, `/` register. In order to use this primitive to execute a
| " |_. .---, temporary search, one could make this primitive save the
`---'  `| _ | pattern to a different register, to preserve the default one,
`---'    e.g., `"m\*`to save the pattern to the`m`register, or even
                   `"_\*` to save the pattern to a "null" register, which does
not store anything written to it.

                    ==[ CAPTURE GROUPS

                    Although registers can pass as mere buffer metadata,
     .---, .---,    they are an integral part of an editing session. The
     |ctl|+| r |    `<c-r>` key combination allows to insert into the buffer
     `---' `---'    the value of a register, whose identifier is typed right
                    after the combination.

.---, .---, Example: inserting the name of the current buffer in insert
|ctl|+| r |_. mode can be achieved using the `%` register, which holds
`---' `---' `.---, this information: `<c-r>%`.
              | % |
              `---' Other registers that are set automatically are
the numbered registers, which hold the values of the groups
matched in the last search or select operation (`/` and
.---, .---, `s` primitives).
|ctl|+| r |_.
`---' `---' `.---, Example: when using the search primitive (`/`) with a
              |0-9| regular expression containing groups to match a list of
              `---' first and last names (e.g., `(\w+) (\w+)` on `John Doe`),
issuing `<c-r>1` would insert the first name (`John`),
and `<c-r>2` the last name (`Doe`).

                    =[ CUSTOM SELECTIONS

                    Despite the ability to select bits of data using regular
                    expressions, there are times when using them isn't enough,
                    and additional manual editing of the selections is
        .---,       needed. In order to loop through all the selections and
        | ) |       remove the current one, two primitives are available:
        `---'       respectively the parenthesis (`)`), and the alt/comma
                    key combination (`<a-,>`).
     .---, .---,
     |alt|+| , |    Example: given a list of three numbers all selected
     `---' `---'    individually, (e.g., `1 2 3`), deselecting the second
                    selection would be done by hitting the parenthesis primitive
                    (`)`) until the according selection is the current one,
                    then hitting `<a-,>` to end up with only the first
                    and third number selected.

                    However, being able to trim out some selections out
        .---,       of a bigger set isn't always convenient, as it doesn't
        | ^ |       allow more advanced constructs such as combining sets of
        `---'       multiple-selections that result from different regular
        .---,       expressions. To allow that, the save mark (`Z`) and append
        | Z |       mark (`<a-z>`) come in handy, as they respectively save
        `---'       the current selection to the mark register (`^`), and
                    show a menu that allows appending the current selection

.---, .---, to the mark register upon hitting the `a` key. That way,
|alt|+| z |\_. it becomes possible to chain and save (append) several
`---' `---' `.---, selections made using completely different methods
              | a | (select, split etc) without being forced to preserve
              `---' them at all times.
.---,
| z | Restoring a mark saved to the mark register using those
`---'       primitives can be achieved by using the restore mark
                    primitive (`z`).

                    =[ LEVERAGING SHELL COMMANDS

                    UNIX systems provide with some tools whose purpose is
                    to interact with raw data, and being a UNIX compliant
        .---,       aspiring tool itself, Kakoune allows leveraging those
        | | |       tools to modify a buffer's contents. Upon invoking the pipe
        `---'       primitive (`|`), an input field pops up which prompts for
                    a shell command, to which the selections will individually
                    be sent through the command's standard input.

                    Example: wrapping a selection can be achieved by invoking
                    the `fold` utility, e.g., `|fold -w80`. You could also want
                    to see a patch of all the modifications made to the buffer
                    since it was last saved: `%|diff -u <c-r>% -`. Note that
                    the `<c-r>%` has to be typed interactively, as it will
                    insert the name of the buffer into the command.

                    Another equally useful primitive that doesn't depend on
        .---,       the contents of the current selections is the exclamation
        | ! |       mark primitive (`!`), which simply insert the output of
        `---'       the given shell command before each selection.

                    Example: in order to insert the date of the day at the
                    beginning of the current buffer, one could use `gg`
                    followed with `!date`.

                    But not all shell-related primitives insert data into
                    the current buffer, the `$` key is in fact a way to
        .---,       apply a predicate to all selections, in order to filter
        | $ |       them out. The command passed to this primitive will be
        `---'       executed in a new shell using each individual selection for
                    context, which will either be kept if the command returned
                    a successful exit code (zero) or dropped otherwise (any
                    non-zero value).

                    Example: after selecting all the lines in a buffer and
                    splitting them individually (`%`, `<a-s>`), keeping every
                    odd-numbered line can be achieved with the following
                    sequence: `$` `[ $((kak_reg_hash)) -ne 0 ]`.


                    =[ REPEATING ACTIONS

                    ==[ PUNCTUAL INTERACTIONS

                    In order to modify text efficiently or insert redundant
                    bits of data, two primitives are available. The dot `.`
        .---,       primitive repeats the last change that was made in insert
        | . |       mode (e.g., writing down text after hitting the insert
        `---'       primitive `i`). Similarly, repeating the last selection
                    (e.g., make with the find primitive `f`) can be achieved
                    using the `<a-.>` primitive.

                    Example: to select a paragraph to append a newline
     .---, .---,    character to it and cycle through the following paragraphs
     |alt|+| . |    to repeat the same insertion an arbitrary amount of times,
     `---' `---'    one would first select the paragraph with `]p`, append a
                    newline to it `a<ret><esc>`, then repeat both operations
                    as needed with `<a-.>` and `.` respectively.

                    ==[ COMPLEX CHANGES

                    Transforming successive chunks of formatted data can
        .---,       be cumbersome when done manually, and lack hindsight
        | q |       when writing a script for that particular purpose
        `---'       non-interactively. The middle ground between the two
        .---,       solutions is to record the modifications made to one
        | Q |       chunk interactively, and replay the sequence of keys
        `---'       at will. The sequence in question is a macro: the `Q`
                    primitive will create a new one (i.e., record all the keys

.---, .---, hit henceforth until the escape key `<esc>` is hit), and
|ctl|+| r |\_. the `q` primitive will replay the keys saved in the macro.
`---' `---' `.---,
              | @ | Notes: macros can easily be translated into a proper
              `---' script, as they are saved in the `@` register, which you
can insert into a buffer using `<c-r>@`.
