#' pmid2bibtexR
#'
#' This function allows the user to get BibTeX format from PMID using Entrez from biopython.
#' @param pmid list of pubmed PMID
#' @param myemail Bio.Entrez needs e-mail address of user.
#' @param myapikey Pubmed allows only 3 requests per second without API Key. Default to None. 10 requests per second with API Key. See the details: https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities/
#'
#' @param n_author Number of Authors to see in BibTeX format. Default to "all"
#' @examples
#' pmid <- c(21146710, 20364295)
#' bib <- pmid2bibtexR(pmid, myemail = "user@@example.com", myapikey = NULL, n_author = "all")
#' @export
#' @import reticulate

pmid2bibtexR <- function(pmid, myemail = "user@example.com", myapikey = NULL, n_author = "all"){
  source_python(paste(system.file(package="pmid2bibtexR"), "pmid2bibtexR.py", sep="/"))
  bib <- pmid2bibtexR(pmid, myemail= myemail, myapikey = myapikey, n_author = n_author)
  return(bib)
}
