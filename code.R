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