edit <- function(title, summary="", minor=FALSE, text="", apiURL){

  if(is.logical(minor)){
    minor = as.character(minor)
  }
  
  editResponse1 = postForm(apiURL,
                           action="query",
                           format="xml",
                           prop="info",
                           titles=title,
                           intoken="edit",
                           .opts=myOpts)
  
  #looks like we can edit now
  
  doc = xmlParse(editResponse1, useInternalNodes=TRUE)
  edittoken <- unlist(getNodeSet(doc, "//api/query/pages/page/@edittoken", addFinalizer=FALSE))
  starttimestamp <- unlist(getNodeSet(doc, "//api/query/pages/page/@starttimestamp", addFinalizer=FALSE))
  touched <- unlist(getNodeSet(doc, "//api/query/pages/page/@touched", addFinalizer=FALSE))
  free(doc)
  rm(doc)
  
  #can pass:
  #summary
  #minor
  #title (or) pageid
  
  #TODO change minor=TRUE to "TRUE", or see 
  
  editResponse2 = postForm(apiURL,
                           action="edit",
                           format="xml",
                           prop="info",
                           title=title,
                           bot="true",
                           token=edittoken,
                           basetimestamp=touched,
                           starttimestamp=starttimestamp,
                           summary=summary,
                           minor=minor,
                           text=text,
                           .opts=myOpts)
}