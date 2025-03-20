#' pmid2bibtexR
#'
#' This function allows the user to get BibTeX format from PMID using Entrez from biopython.
#' @param pmid list of pubmed PMID
#' @param n_author Number of Authors to see in BibTeX format. Default to "all"
#' @examples
#' pmid <- c(21146710, 20364295)
#' bib <- pmid2bibtexR(pmid, n_author = "all")
#' @export
#' @import XML httr

pmid2bibtexR <- function(pmid = c(20364295, 21146710), n_author = "all"){
  bib <- ""
  for(i in pmid){
    pub_info <- httr::content(GET(paste0("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=",i,"&retmode=xml")),encoding = "UTF-8")
    pub_info <- xmlParse(pub_info)
    Year <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//PubMedPubDate[@PubStatus='accepted']//Year"))
    PMID <- i
    Journal <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//ISOAbbreviation"))
    Volume <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//Volume"))
    Issue <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//Issue"))
    ArticleTitle <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//ArticleTitle"))
    StartPage <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//StartPage"))
    EndPage <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//EndPage"))
    Pages <- paste0(StartPage,"-",EndPage)
    DOI <- xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//ELocationID"))

    if(n_author == "all"){
      Author <- paste(paste(xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//LastName")),xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//Initials")) ), collapse = ", ")
    } else if(!n_author == "all" & is.numeric(n_author)& n_author > 0){
      if(length(xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//LastName"))) > n_author){
        Author <- paste(paste(paste(xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//LastName"))[1:n_author],xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//Initials"))[1:n_author]), collapse = ", "), ", et al.")
      } else if(length(xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//LastName"))) == n_author){
        Author <- paste(paste(xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//LastName"))[1:n_author],xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//Initials"))[1:n_author]), collapse = ", ")
      } else {
        Author <- paste(paste(xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//LastName")),xmlValue(getNodeSet(pub_info, "/PubmedArticleSet//Initials")) ), collapse = ", ")
      }
    }

    bib = paste0(bib,"@Article{pmid",PMID,",\n \tAuthor={",Author,"},\n \tTitle={",ArticleTitle,"},\n \tJournal={",Journal,"},\n \tYear={",Year)
    tryCatch({
      bib = paste0(bib,"},\n \tVolume={",Volume)
    }, error = function(e) e)
    tryCatch({
      bib = paste0(bib,"},\n \tNumber={",Issue)
    }, error = function(e) e)
    tryCatch({
      bib = paste0(bib,"},\n \tPage={",Pages)
    }, error = function(e) e)
    bib =paste0(bib,"},\n \tPMID={",PMID,"}\n}\n")
  }
  return(bib)
}
