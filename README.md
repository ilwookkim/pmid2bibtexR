# **pmid2bibtexR**

Converting Pubmed PMID to BibTeX format in R using biopython module

## **Require**

This package needs pre-installed **python3** and python module: **Biopython**
Pubmed allows only 3 requests per second without API Key, but 10 requests per second with API Key. See the [details](https://ncbiinsights.ncbi.nlm.nih.gov/2017/11/02/new-api-keys-for-the-e-utilities). Please use API Key, if possible.

**Debian/Ubuntu**
``` colsole
sudo apt install python3-pip
pip install biopython
```

**MacOS**
``` colsole
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install biopython
```

### **Installation**

The **development** version can be installed from GitHub using:

``` r
devtools::install_github("ilwookkim/pmid2bibtexR")
```
#### **Usage**

``` r
library(pmid2bibtexR)
pmid <- c(21146710, 20364295)
bib <- pmid2bibtexR(pmid, myemail = "user@example.com", myapikey = NULL, n_author = "all")
write(bib, "./bibtex.bib")
```

bibtex.bib file contains BibTeX format as below:

```
@Article{pmid21146710,
 	Author={Kang MH and Kim IW and Lee DW and Yoo MS and Han SH and Yoon BS},
 	Title={Development of a rapid detection method to detect tdh gene in Vibrio parahaemolyticus using 2-step ultrarapid real-time polymerase chain reaction.},
 	Journal={Diagn Microbiol Infect Dis},
 	Year={2011},
 	Volume={69},
 	Number={1},
 	Pages={21-9},
 	PMID={21146710}
}
@Article{pmid20364295,
 	Author={Kim IW and Kang MH and Kwon SH and Cho SH and Yoo BS and Han SH and Yoon BS},
 	Title={Rapid detection of virulence stx2 gene of Enterohemorrhagic Escherichia coli using two-step ultra-rapid real-time PCR.},
 	Journal={Biotechnol Lett},
 	Year={2010},
 	Volume={32},
 	Number={5},
 	Pages={681-8},
 	PMID={20364295}
}

```



