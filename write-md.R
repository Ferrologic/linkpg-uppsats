library(rmarkdown)

filename <- "Filip Burlin & Lukas Carlbring C-Uppsats.Rmd" 

# Check that it's a .Rmd file.
if(!grepl(".Rmd", filename)) {
  stop("You must specify a .Rmd file.")
}

tempfile <- sub('.Rmd', '_deleteme.Rmd', filename)
mdtempfile <- sub('.Rmd', '_deleteme.md', filename)
mdfile <- sub('.Rmd', '.md', filename)

x0 <- readLines(filename)

sel <- grepl("([[:blank:]]|[[:punct:]]){1}\\${1}(.+?)\\$", x0)

x1 <- x0
x1[sel] <- gsub("(\\${1}(.+?)\\$)", "<pre>\\1<\\/pre>", x0[sel])

x2 <- paste(x1, collapse = "!@#:")

x3 <- gsub("(\\${2}(.+?)\\${2})", "<pre>\\1<\\/pre>", x2)

x4 <- strsplit(x3, split="!@#:", fixed = TRUE)

writeLines(x4[[1]], tempfile)


rmarkdown::render(tempfile, output_format = 'all', output_file = mdtempfile)



x0 <- readLines(mdtempfile)

x <- paste(x0, collapse = "!@#:")

x1 <- gsub("<pre>\\${2}", "$$", x)
x2 <- gsub("\\${2}</pre>", "$$!@#:", x1)

x3 <- gsub("(!@#:[[:space:]]*)<pre>\\${1}", " $", x2)
x4 <- gsub("\\${1}</pre>(!@#:)", "$ ", x3)
# remove space before punctuation!
x5 <- gsub("\\s+([,;:)!\\.\\?])", "\\1", x4)
x6 <- strsplit(x5, split="!@#:", fixed = TRUE)

writeLines(x6[[1]], mdfile)


unlink(mdtempfile)
unlink(tempfile)
