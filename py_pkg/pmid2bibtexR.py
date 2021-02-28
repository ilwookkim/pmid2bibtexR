# python3 because unicode problem
import Bio.Entrez as ez
import ssl

def pmid2bibtexR(pmid, myemail = "user@example.com", myapikey = None, n_author = "all"):
    ez.email = myemail
    ssl._create_default_https_context = ssl._create_unverified_context
    bib = ""
    for i in range(len(pmid)):
        article=""
        cited = ""
        Title = ""
        Journal = ""
        Year = ""
        Volume = ""
        Number = ""
        Pages = ""
        PMID = ""
        Author = []
        # genes that associated with pancreatic cancer
        try:
            if myapikey is not None:
                pubmed_entry = ez.efetch(apikey= myapikey, db="pubmed", id=str(int(pmid[i])), retmode="xml")
            else:
                pubmed_entry = ez.efetch(db="pubmed", id=str(int(pmid[i])), retmode="xml")
                print("Run without API Key")
        except:
            print("Error: Check the Pubmed api key")
        if pubmed_entry:
            result = ez.read(pubmed_entry)
            article = result['PubmedArticle'][0]['MedlineCitation']['Article']
            cited = ("pmid" + str(int(pmid[i])))
            Title = article['ArticleTitle'] #Title
            #Abstract = article['Abstract']['AbstractText']
            Journal = article['Journal']['ISOAbbreviation'] #JournalTitleAbbr
            #Journal = article['Journal']['Title'] #JournalTitle
            Year = article['Journal']['JournalIssue']['PubDate']['Year'] #Year
            try:
                Volume = article['Journal']['JournalIssue']['Volume'] #Volume
            except:
                pass
            try:
                Number = article['Journal']['JournalIssue']['Issue'] #Number
            except:
                pass
            try:
                Pages = article['Pagination']['MedlinePgn'] #Page
            except:
                pass
            PMID = str(int(pmid[i]))
            if type(n_author) is int:
                print("n_author: ", n_author)
                if n_author < len(article['AuthorList']):
                    Author = []
                    for j in range(n_author):
                        s = ""
                        s += article['AuthorList'][j]['LastName']
                        s += " "
                        s += article['AuthorList'][j]['Initials']  # for initial of name
                        # s += article['AuthorList'][j]['ForeName']
                        s = "".join(s)
                        Author.append(s)
                        Author = " and ".join(Author)
                    Author += " and Others"
                elif n_author >= len(article['AuthorList']):
                    for j in range(len(article['AuthorList'])):
                        s = ""
                        s += article['AuthorList'][j]['LastName']
                        s += " "
                        s += article['AuthorList'][j]['Initials']  # for initial of name
                        # s += article['AuthorList'][j]['ForeName']
                        s = "".join(s)
                        Author.append(s)
                    Author = " and ".join(Author)
                    print("Only ",n_author, " authors")
            elif n_author == "all":
                for j in range(len(article['AuthorList'])):
                    s = ""
                    s += article['AuthorList'][j]['LastName']
                    s += " "
                    s += article['AuthorList'][j]['Initials']  # for initial of name
                    # s += article['AuthorList'][j]['ForeName']
                    s = "".join(s)
                    Author.append(s)
                Author = " and ".join(Author)
                print(int(pmid[i]),": Done")
            else:
                print("n_author needs arg int or \"all\".")
            bib += "@Article{"+cited+",\n \tAuthor={"+Author+"},\n \tTitle={"+Title+"},\n \tJournal={"+Journal+"},\n \tYear={"+Year
            try:
                bib += "},\n \t Volume={"+Volume
            except:
                pass
            try:
                bib += "},\n \tNumber={"+Number
            except:
                pass
            try:
                bib += "},\n \tPages={"+Pages
            except:
                pass
            bib += "},\n \tPMID={"+PMID+"}\n}\n"
        else:
            print("Error :", str(int(pmid[i])))

    return bib