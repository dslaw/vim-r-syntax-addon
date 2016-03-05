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

base <- format_output(
            sort(filter_operators(
                Filter(check_function,
                    function_names(start_packages)))))

write(paste0(c('" Builtins', base), collapse = '\n'),
    file = 'r.vim')


# Parallel - ships with R
included <- c('parallel')

out <- sapply(included, require, quietly = TRUE,
              character.only = TRUE)

incl <- format_output(
            sort(filter_operators(
                Filter(check_function,
                    function_names(included)))))

write(paste0(c('\n" Included packages', incl), collapse = '\n'),
    file = 'r.vim', append = TRUE)


# Additional packages
pkgs <- c('devtools', 'dplyr', 'ggplot2', 'lubridate',
          'packrat', 'reshape2', 'stringr', 'testthat')

out <- sapply(pkgs, require, quietly = TRUE, character.only = TRUE,
              warn.conflicts = FALSE)

additional <- sort(
                filter_operators(
                    Filter(check_function,
                        function_names(pkgs))))

additional <- setdiff(additional, c(base, incl))
additional <- paste0(additional, collapse = ' ')

write('\n" Additional packages', file = 'r.vim', append = TRUE)
write(paste0(c( 'r link rFunctionExtra Typedef', additional), collapse = ' '),
      file = 'r.vim', append = TRUE)


# Import package - used as a namespace
write(paste0(c('\n" Import package',
               'syn keyword rPreProc import'), collapse = '\n'),
      file = 'r.vim', append = TRUE)

