#!/usr/bin/env Rscript

# Leave off included datasets (`dataset` package)
# This includes packages not covered by the function "builtins"
start_packages <- c('base', 'graphics', 'grDevices',
                    'methods', 'stats', 'utils')

out <- sapply(start_packages, require, quietly = TRUE,
              character.only = TRUE)

# Get functions from builtin packages
pkg_search <- sapply(start_packages, function(pkg)
                     paste0('package:', as.character(pkg)))
functions <- lapply(pkg_search, ls)
functions <- unlist(functions, recursive = TRUE)

# Remove operator s3 methods, including LHS assignment
# ex: "+.Date", "[[<-.data.frame"
# Hidden objects are also removed ex: ".mapply"
operator <- grepl('^[^a-zA-Z]', functions)
functions <- functions[!operator]

# Remove keywords already defined in `r.vim`
syntax_def <- c(# rStatement
                'break', 'next', 'return',
                # rConditional
                'if', 'else',
                # rRepeat
                'for', 'in', 'repeat', 'while',
                # rConstant
                'T', 'F', 'LETTERS', 'letters', 'month.abb', 'month.name', 'pi', 'R.version.string',
                # rPreProc
                'library', 'require', 'attach', 'detach', 'source',
                # rType
                'array', 'category', 'character', 'complex', 'double', 'function',
                'integer', 'list', 'logical', 'matrix', 'numeric', 'vector', 'data.frame'
                )
functions <- functions[!(functions %in% syntax_def)]

# Create single line for syntax file
vim_syntax <- 'syn keyword rFunction'
collapsed <- paste(c(vim_syntax, functions), collapse = ' ')
write(collapsed, file = 'r.vim')

