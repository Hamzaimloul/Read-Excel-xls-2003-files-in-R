# Useful functions scripted in R

this repository includes some reproducible functions

**Read-Excel-XML-2003-Spreadsheets-in-R**  
This function for reading XML Spreadsheets 2003, often they have xls extension.
the package 'readxl' can't read in most cases the XML spreadsheets in xls format.
By using this function, reading these files is possible.  

```{r}
library(tidyverse)
library(xml2)

readExcelXML =
  function(filename) {
    doc <- read_xml(filename)
    ns <- xml_ns(doc)
    rows <- xml_find_all(doc, paste0(".//ss:Worksheet/ss:Table/ss:Row"), ns = ns)
    values <- lapply(rows, . %>% xml_find_all(".//ss:Cell/ss:Data", ns = ns) %>% xml_text %>% unlist)
    
    columnNames <- values[[1]]
    
    dat <- do.call(rbind.data.frame, c(values[-1], stringsAsFactors = FALSE))
    names(dat) <- columnNames
    
    dat
  }
  ```
