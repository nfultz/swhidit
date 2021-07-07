# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

hello <- function() {
  print("Hello, world!")
}


packageMeta <- function(package_names=.packages()) {
  fields <- c("Package", "Title", "Author", "Version", "Packaged", "Built", "Repository", "RemoteType", "RemoteHost", "RemoteRepo", "RemoteUsername", "RemoteSha")

  as.data.frame(installed.packages(fields = fields)[package_names, fields])
}

getSwhids <- function(meta, repo=c("CRAN", "github")) {

  meta[["bibtexkey"]] <- ""
  meta[["origin_url"]] <- ""
  meta[["swhid"]] <- ""


  CRAN <- intersect(repo, "CRAN")
  github <- intersect(repo, "github")

  for(i in 1:nrow(meta)) {
    if(meta[i, "Repository"] %in% CRAN) {
      origin_url <- paste0("https://cran.r-project.org/package%3D", meta[i, "Package"])
      bibtexkey <- paste0("cran:", meta[i, "Package"])
    } else if (meta[i, "RemoteType"] %in% github){
      origin_url <- paste0("https://github.com/", meta[i, "RemoteUsername"], "/", meta[i, "RemoteRepo"])
      bibtexkey <- paste0("gh:",meta[i, "RemoteUsername"], "/", meta[i, "RemoteRepo"])
    } else {
      next
    }
    meta[i, "origin_url"] <- origin_url
    meta[i, "bibtexkey"] <- bibtexkey

    archive_url <- paste0("https://archive.softwareheritage.org/browse/origin/directory/?origin_url=", origin_url)
    try({
      u <- url(archive_url)

      lines <- readLines(u)
      swhid <- grep("swh.webapp.setBrowsedSwhObjectMetadata", lines, value = TRUE)
      #swhid <- gsub("^[^{]*|[^}]*$", "", swhid)
      swhid <- regmatches(swhid, regexec('"object_id": "([0-9a-f]*)"',swhid, perl = TRUE))[[1]][2]

      meta[i, "swhid"] <- swhid

      close(u)
    })
  }

  meta
}


writeBib <- function(meta, out=NULL) {

  entries <- vector("list", nrow(meta))

  for(i in 1:nrow(meta)) {

    if(meta[i, "bibtexkey"] == "") {
      entries[[i]] <- ""
      next
    }

    entries[[i]] <- sprintf(
      #Along gutter for nicer indentation in output

'
@softwareversion {%s,
  version = {%s},
  author = {%s},
  title = {%s},
  date = {%s},
  swhid = {swh:1:dir:%s;
	   origin=%s},
	url = {%s}
}
',
      meta[i, "bibtexkey"], meta[i, "Version"], meta[i, "Author"], meta[i, "Title"], as.Date(meta[i, "Packaged"]),  meta[i, "swhid"], meta[i, "origin_url"], meta[i, "origin_url"]
      )

  }

  if(is.character(out)) {
    out <- file(out, open="w")
    on.exit(close(out))
  }

  if(!is.null(out)) {
    for(e in entries){
      writeLines(e, out)
    }
  }

  invisible(entries)
}

swhidit <- function(package_names=.packages(), repos=c("CRAN", "github"), out="swhids.bib") {

  meta <- packageMeta(package_names)
  meta <- getSwhids(meta, repos)

  writeBib(meta, out)

}




