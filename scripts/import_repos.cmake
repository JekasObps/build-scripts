###
#   Import git repository 
###
function(IMPORT_REPO name git_url git_tag)
include(FetchContent)
    FetchContent_Declare(
        ${name}
        GIT_REPOSITORY ${git_url}
        GIT_TAG ${git_tag}
    )

    FetchContent_MakeAvailable(${name})
endfunction(IMPORT_REPO)
