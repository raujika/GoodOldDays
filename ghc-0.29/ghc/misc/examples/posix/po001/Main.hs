import LibPosix

main =
    getParentProcessID >>= \ ppid ->
    getProcessID >>= \ pid ->
    putStr "Parent Process ID: " >>
    putText ppid >>
    putStr "\nProcess ID: " >>
    putText pid >>
    putStr "\nforking ps uxww" >>
    putText ppid >>
    putChar '\n' >>
    forkProcess >>= \ child ->
    case child of
	Nothing -> executeFile "ps" True ["uxww" ++ show ppid] Nothing
	Just x -> doParent x pid

doParent cpid pid =
    getProcessStatus True False cpid >>
    putStr "\nChild finished.  Now exec'ing ps uxww" >>
    putText pid >>
    putChar '\n' >>
    executeFile "ps" True ["uxww" ++ show pid] Nothing
