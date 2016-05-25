\name{buildCMAPdb}
\alias{buildCMAPdb}
\title{
Build structure database (e.g. CMAP)
}
\description{
Function to build SQLite database containing small molecule structures, properties
and annotations.
}
\usage{
buildCMAPdb(rerun)
}
\arguments{
  \item{rerun}{
Set \code{rerun=TRUE} to build database.
}
}
\details{
...
}
\value{
\code{SQLite database}
}
\references{
ChemmineR: https://www.bioconductor.org/packages/release/bioc/html/ChemmineR.html
}
\author{
Thomas Girke
}

\examples{

## Build database
buildCMAPdb(rerun=FALSE) # Set to TRUE

## Load database
mypath <- system.file("extdata", "cmap.db", package="longevityDrugs")
conn <- initDb(mypath)

## Query database
results <- getAllCompoundIds(conn)
sdfset <- getCompounds(conn, results, keepOrder=TRUE)
sdfset
as.data.frame(datablock2ma(datablock(sdfset)))[1:4,]
myfeat <- listFeatures(conn)
feat <- getCompoundFeatures(conn, results, myfeat)
feat[1:4,]
}
\keyword{ utilities }
