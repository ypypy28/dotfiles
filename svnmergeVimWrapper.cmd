@call vim -d %3 %2  -c ":botright split %4" -c ":setl showtabline=2" -c "let g:airline_statusline_ontop = 1" -c ":setl statusline=MERGED | wincmd W | setl statusline=THEIRS| wincmd W | setl statusline=MINE"
@REM don't forget to add the full path to this file in the config %APPDATA%\Subversion\config
@REM --------------
@REM [helpers]
@REM merge-tool-cmd = 
