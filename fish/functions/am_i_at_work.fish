
function am_i_at_work
    if [ (uname) = "Darwin" ]
            return 0
    else
        return 2
    end
end
