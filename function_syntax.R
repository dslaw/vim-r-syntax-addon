#!/usr/bin/env Rscript

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
    collapsed <- paste(c(vim_syntax, functions), collapse = ' ')
    return(collapsed)
}



# Leave off included datasets (`dataset` package)
# This includes packages not covered by the function "builtins"
start_packages <- c('base', 'graphics', 'grDevices',
                    'methods', 'stats', 'utils')

# Ensure packages are loaded
out <- sapply(start_packages, require, quietly = TRUE,
              character.only = TRUE)

base <- sort(format_output(
                filter_operators(
                    Filter(check_function,
                        function_names(start_packages)))))

write(paste0(c('" Builtins', base), collapse = '\n'),
    file = 'r.vim')

