#              minute         0-59
#              hour           0-23
#              day of month   1-31
#              month          1-12 (or names, see below)
#              day of week    0-7 (0 or 7 is Sun, or use names)

25 16 * * * /dfs3/som/rao_col/maltx/scripts/bids/DicomTransfer.sh > /dev/null 2>&1 
25 16 * * * /dfs3/som/rao_col/maltx/scripts/bids/EprimeTransfer.sh > /dev/null 2>&1 
25 16 * * * /dfs3/som/rao_col/maltx/scripts/bids/PictureTransfer.sh > /dev/null 2>&1 
