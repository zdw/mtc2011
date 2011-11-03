on run argv
    tell application "Mail"
        set theMessage to make new outgoing message with properties {visible:true, subject:item 1 of argv, content:item 2 of argv}
        tell theMessage
            make new to recipient at end of to recipients with properties {name:item 3 of argv, address:item 4 of argv}
        end tell
        tell content of theMessage
            make new attachment with properties {file name:item 5 of argv} at after last paragraph
        end tell
     end tell
 end run
