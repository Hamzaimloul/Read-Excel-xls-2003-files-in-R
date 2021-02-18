# Useful functions scripted in R

this repository includes some reproducible functions

**Read Excel (XML 2003) Spreadsheets in R**  
There is packages in R to read spreadsheets: readxl::read_xlsx, readxl::read_xls. But these functions do not support xls 2003 spreadsheets, which can be tricky. because in most cases they have xls extension.
By using this function, reading these files is possible.  

## Data Collection

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
