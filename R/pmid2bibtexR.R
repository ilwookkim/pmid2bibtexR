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

pmid2bibtexR <- function(pmid, myemail = "user@example.com", myapikey = NULL, n_author = "all" ){
  Bio <- import("Bio")
  ez <- Bio$Entrez
  ez$email = myemail
  bib=""
  for (i in 1:length(pmid)) {
    cited = ""
    Title = ""
    Journal = ""
    Year = ""
    Volume = ""
    Number = ""
    Pages = ""
    PMID = ""
    Author = as.list(NULL)
    tryCatch({
      if(!is.null(myapikey)){
        pubmed_entry = ez$efetch(apikey= myapikey, db="pubmed", id=paste0(round(pmid[i])), retmode="xml")
      } else {
        pubmed_entry = ez$efetch(db="pubmed", id=paste0(round(pmid[i])), retmode="xml")
        print("Run without API Key")
      }}, error = function(e) print("Error: Check the Pubmed api key"))
    if(!is.null(pubmed_entry)){
      result = ez$read(pubmed_entry)
      cited = paste0("pmid",round(pmid[i]))
      Title = result['PubmedArticle'][[1]]['MedlineCitation']['Article']['ArticleTitle']
      Journal = result['PubmedArticle'][[1]]['MedlineCitation']['Article']['Journal']['ISOAbbreviation']
      Year = result['PubmedArticle'][[1]]['MedlineCitation']['Article']['Journal']['JournalIssue']['PubDate']['Year']
      tryCatch({
        Volume = result['PubmedArticle'][[1]]['MedlineCitation']['Article']['Journal']['JournalIssue']['Volume']
      }, error = function(e) e)
      tryCatch({
        Number = result['PubmedArticle'][[1]]['MedlineCitation']['Article']['Journal']['JournalIssue']['Issue']
      }, error = function(e) e)
      tryCatch({
        Pages = result['PubmedArticle'][[1]]['MedlineCitation']['Article']['Pagination']['MedlinePgn']
      }, error = function(e) e)
      PMID = paste0(round(pmid[i]))
      author_len <- length(result['PubmedArticle'][[1]]['MedlineCitation']['Article']['AuthorList'])-1
      if(is.numeric(n_author)){
        print(paste0("n_author: ", n_author))
        if(n_author < author_len){
          Author = as.list(NULL)
          for (j in 1:n_author) {
            s=""
            s=paste0(result['PubmedArticle'][[1]]['MedlineCitation']['Article']['AuthorList'][j]['LastName']," ",result['PubmedArticle'][[1]]['MedlineCitation']['Article']['AuthorList'][j]['Initials'] )
            Author[j] <- s
          }
          Author <- paste(Author, sep = "", collapse = " and ")
          Author <- paste0(Author, " and Others")
        } else if(n_author >= author_len){
          for (j in 1:author_len) {
            s=""
            s=paste0(result['PubmedArticle'][[1]]['MedlineCitation']['Article']['AuthorList'][j]['LastName']," ",result['PubmedArticle'][[1]]['MedlineCitation']['Article']['AuthorList'][j]['Initials'] )
            Author[j] <- s
          }
          Author <- paste(Author, sep = "", collapse = " and ")
        }
      } else if(n_author == "all") {
        for (j in 1:author_len) {
          s=""
          s=paste0(result['PubmedArticle'][[1]]['MedlineCitation']['Article']['AuthorList'][j]['LastName']," ",result['PubmedArticle'][[1]]['MedlineCitation']['Article']['AuthorList'][j]['Initials'] )
          Author[j] <- s
        }
        Author <- paste(Author, sep = "", collapse = " and ")
        print(paste0(pmid[i],": Done"))
      }
    }
    bib = paste0(bib,"@Article{",cited,",\n \tAuthor={",Author,"},\n \tTitle={",Title,"},\n \tJournal={",Journal,"},\n \tYear={",Year)
    tryCatch({
      bib = paste0(bib,"},\n \tVolume={",Volume)
    }, error = function(e) e)
    tryCatch({
      bib = paste0(bib,"},\n \tNumber={",Number)
    }, error = function(e) e)
    tryCatch({
      bib = paste0(bib,"},\n \tPage={",Pages)
    }, error = function(e) e)
    bib =paste0(bib,"},\n \tPMID={",PMID,"}\n}\n")
  }
  return(bib)
}
