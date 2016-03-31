# Get object names from packages
function_names <- function(pkgs) {
    pkg_search <- paste0('package:', as.character(pkgs))
    functions <- lapply(pkg_search, ls)
    functions <- unlist(functions, recursive = TRUE)
    return(functions)
}

check_function <- function(x) {
    is.function(get(x))
}

# Remove operator s3 methods, including LHS assignment
# ex: `+.Date`, `[[<-.data.frame`
# Hidden objects are also removed ex: `.mapply`
filter_operators <- function(x) {
    operator <- grepl('^[^a-zA-Z]', x)
    objs <- x[!operator]
    return(objs)
}

# Create a single line for syntax file
format_output <- function(functions) {
    vim_syntax <- 'syn keyword rFunction'
    collapsed <- paste0(c(vim_syntax, functions), collapse = ' ')
    return(collapsed)
}

ssplit <- function(x) strsplit(x, ' ')[[1]]

