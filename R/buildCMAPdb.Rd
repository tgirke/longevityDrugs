\name{buildCMAPdb}
\alias{buildCMAPdb}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
buildCMAPdb(rerun)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{rerun}{
%%     ~~Describe \code{rerun} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (rerun) 
{
    if (rerun == TRUE) {
        getDmap <- function(url) {
            download.file(url, "dmap.zip")
            unzip("dmap.zip", exdir = ".")
            file.rename("DMAP V2.csv", "dmap.csv")
            unlink("dmap.zip")
            tmp <- readLines("dmap.csv")
            tmp2 <- gsub(">,<", "\t", tmp)
            tmp2 <- gsub(">,", "\t", tmp2)
            tmp2 <- gsub(",<", "\t", tmp2)
            tmp2 <- gsub("^<", "", tmp2)
            tmp2 <- gsub(">$", "", tmp2)
            writeLines(tmp2, "dmap2.txt")
            dmap <- read.delim("dmap2.txt", quote = "")
            dmap <- dmap[!duplicated(dmap$SOURCE_DRUG), ]
            write.table(dmap, "dmap_unique.txt", row.names = FALSE, 
                quote = FALSE, sep = "\t")
            unlink(c("dmap.csv", "dmap2.txt"))
        }
        getDmap(url = "http://discern.uits.iu.edu:8340/PAGER/application/download/DMAP\%20V2.zip")
        dmap <- read.delim("dmap_unique.txt", quote = "")
        dmap <- dmap[!duplicated(tolower(dmap$SOURCE_DRUG)), 
            ]
        row.names(dmap) <- tolower(dmap$SOURCE_DRUG)
        download.file("http://www.broadinstitute.org/cmap/cmap_instances_02.xls", 
            "cmap_instances_02.xls")
        library(gdata)
        cmap <- read.xls("cmap_instances_02.xls")[1:6100, ]
        cmap <- cmap[!duplicated(tolower(cmap$cmap_name)), ]
        row.names(cmap) <- tolower(cmap$cmap_name)
        df <- data.frame(cmap, dmap[row.names(cmap), ])
        sum(!is.na(df$SOURCE_DRUG))
        sum(is.na(df$SOURCE_DRUG))
        unlink("cmap_instances_02.xls")
        unlink("dmap_unique.txt")
        smipath <- system.file("extdata/cmap_support", "smilesMatches.csv", 
            package = "longevityDrugs")
        smipath <- "../inst/extdata/cmap_support/smilesMatches.csv"
        smiMA <- read.csv(smipath)
        row.names(smiMA) <- tolower(smiMA$cmap_name)
        bothDF <- cbind(df, smiMA[rownames(df), ])
        dim(bothDF[as.integer(bothDF[, "match_distance"]) == 
            0, ])
        library(ChemmineR)
        library(ChemmineOB)
        smi <- as.character(bothDF$smiles)
        names(smi) <- as.character(bothDF$cmap_name)
        smi <- as(smi, "SMIset")
        sdfset <- smiles2sdf(smi)
        datablock(sdfset) <- bothDF
        standardFeatures <- function(sdfInput) {
            data.frame(propOB(sdfInput), Ncharges = sapply(bonds(sdfInput, 
                type = "charge"), length), as.data.frame(groups(sdfInput, 
                type = "countMA")), as.data.frame(rings(sdfInput, 
                upper = 8, type = "count", arom = TRUE)))
        }
        conn <- initDb("cmap.db")
        ids <- loadSdf(conn, sdfset, fct = standardFeatures)
        print("Move cmap.db to 'inst/extdata/ of package and rebuild it.'")
    }
    else {
        print("To rebuild database, set 'rerun=TRUE'.")
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
