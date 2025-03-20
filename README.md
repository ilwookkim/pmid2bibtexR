# **pmid2bibtexR**

Converting Pubmed PMID to BibTeX format in R using Pubmed RESTful API

### **Installation**

The **development** version can be installed from GitHub using:

``` r
devtools::install_github("ilwookkim/pmid2bibtexR")
```
#### **Usage**

``` r
library(pmid2bibtexR)
pmid <- c(21146710, 20364295)
bib <- pmid2bibtexR(pmid, n_author = "all")
write(bib, "./bibtex.bib")
```

bibtex.bib file contains BibTeX format as below:

```
@Article{pmid21146710,
 	Author={Kang MH, Kim IW, Lee DW, Yoo MS, Han SH, Yoon BS},
 	Title={Development of a rapid detection method to detect tdh gene in Vibrio parahaemolyticus using 2-step ultrarapid real-time polymerase chain reaction.},
 	Journal={Diagn Microbiol Infect Dis},
 	Year={2010},
 	Volume={69},
 	Number={1},
 	Page={21-29},
 	PMID={21146710}
}
@Article{pmid20364295,
 	Author={Kim IW, Kang MH, Kwon SH, Cho SH, Yoo BS, Han SH, Yoon BS},
 	Title={Rapid detection of virulence stx2 gene of Enterohemorrhagic Escherichia coli using two-step ultra-rapid real-time PCR.},
 	Journal={Biotechnol Lett},
 	Year={2010},
 	Volume={32},
 	Number={5},
 	Page={681-688},
 	PMID={20364295}
}

```

When n_author = 3.
``` r
bib <- pmid2bibtexR(pmid, n_author = 3)
write(bib, "./bibtex.bib")
```

```
@Article{pmid21146710,
 	Author={Kang MH, Kim IW, Lee DW , et al.},
 	Title={Development of a rapid detection method to detect tdh gene in Vibrio parahaemolyticus using 2-step ultrarapid real-time polymerase chain reaction.},
 	Journal={Diagn Microbiol Infect Dis},
 	Year={2010},
 	Volume={69},
 	Number={1},
 	Page={21-29},
 	PMID={21146710}
}
@Article{pmid20364295,
 	Author={Kim IW, Kang MH, Kwon SH , et al.},
 	Title={Rapid detection of virulence stx2 gene of Enterohemorrhagic Escherichia coli using two-step ultra-rapid real-time PCR.},
 	Journal={Biotechnol Lett},
 	Year={2010},
 	Volume={32},
 	Number={5},
 	Page={681-688},
 	PMID={20364295}
}

```


