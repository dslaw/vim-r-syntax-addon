#!/usr/bin/env Rscript


argv <- commandArgs(trailingOnly = TRUE)

source('utils.R')

# Leave off included datasets (`dataset` package)
# This includes packages not covered by the function "builtins"
start_packages <- c('base', 'graphics', 'grDevices',
                    'methods', 'stats', 'utils')

# Parallel - ships with R but is not loaded at startup
included_packages <- c('parallel')

# Ensure packages are loaded
out <- sapply(c(start_packages, included_packages), require,
              quietly = TRUE, character.only = TRUE)

base <- format_output(
            sort(filter_operators(
                Filter(check_function,
                    function_names(start_packages)))))

base_formatted <- paste0(c('" Builtins', base), collapse = '\n')
#write(base_formatted, file = 'r.vim')

incl <- format_output(
            sort(filter_operators(
                Filter(check_function,
                    function_names(included_packages)))))

incl_formatted <- paste0(c('" Included packages', incl), collapse = '\n')
#write(incl_formatted, file = 'r.vim', append = TRUE)


# Additional packages
pkgs <- c('devtools', 'dplyr', 'ggplot2', 'lubridate', 'logging',
          'packrat', 'reshape2', 'stringr', 'testthat')

out <- sapply(pkgs, require, quietly = TRUE, character.only = TRUE,
              warn.conflicts = FALSE)

additional <- sort(
                filter_operators(
                    Filter(check_function,
                        function_names(pkgs))))

additional <- setdiff(additional, c(ssplit(base), ssplit(incl)))
additional <- paste0(additional, collapse = ' ')

additional_formatted <- paste0(c('syn keyword rFunctionAddon', additional),
                               collapse = ' ')
additional_text <- paste0(c('" Additional packages',
                            'hi def link rFunctionAddon Typedef',
                            additional_formatted),
                          collapse = '\n')

#write('\n" Additional packages', file = 'r.vim', append = TRUE)
#write('hi def link rFunctionAddon Typedef', file = 'r.vim', append = TRUE)
#write(paste0(c('syn keyword rFunctionAddon', additional), collapse = ' '),
#      file = 'r.vim', append = TRUE)


# Import package - used as a namespace
import <- c('\n" Import package', 'syn match rPreProc "import:\\{2,3}\\(from\\|here\\|into\\)"')
write(paste0(import, collapse = '\n'), file = 'r.vim', append = TRUE)

