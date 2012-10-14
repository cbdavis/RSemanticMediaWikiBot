read <- function(title, apiURL, myOpts){
  
  readResponse = postForm(apiURL,
                          action="query",
                          prop="revisions",
                          rvlimit="1",
                          rvprop="content",
                          format="xml",
                          titles=title,
                          .opts=myOpts)
  
  doc = xmlParse(readResponse, useInternalNodes=TRUE)
  pageText <- xmlValue(unlist(getNodeSet(doc, "//api/query/pages/page/revisions/rev/text()", addFinalizer=FALSE))[[1]])
  print(pageText)
  free(doc)
  rm(doc)
  return(pageText)
}