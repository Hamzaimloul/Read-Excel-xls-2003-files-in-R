# Useful functions scripted in R

this repository includes some reproducible functions

## Data Collection  

### Read Excel (XML 2003) Spreadsheets in R  
While there are packages in R to read spreadsheets (`readxl::read_xlsx` and `readxl::read_xls`), they do not support XML 2003 spreadsheets, which can often be misidentified as XLS files due to their file extension. This function provides a solution to reading these files by using the read_xml function from the `xml2` package and the `xml_find_all` function from the `tidyverse` package. The function reads the spreadsheet, identifies the data in the rows and columns, and returns the data in a data frame with the column names derived from the first row of data.

```r
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
