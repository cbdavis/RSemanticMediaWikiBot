getEditToken <- function(bot, title){
  editResponse = postForm(bot$apiURL,
                           action="query",
                           format="xml",
                           prop="info",
                           titles=title,
                           intoken="edit",
                           .opts=bot$curlOpts)

  doc = xmlParse(editResponse, useInternalNodes=TRUE)
  bot$edittoken <- unlist(getNodeSet(doc, "//api/query/pages/page/@edittoken", addFinalizer=FALSE))

  #TODO read documentation (http://www.mediawiki.org/wiki/API:Edit_-_Create%26Edit_pages)
  #starttimestamp and touched may only apply to a specific title
  #while the edit token may be used for editing multiple pages.  Problems may arise from this.
  bot$starttimestamp <- unlist(getNodeSet(doc, "//api/query/pages/page/@starttimestamp", addFinalizer=FALSE))
  bot$touched <- unlist(getNodeSet(doc, "//api/query/pages/page/@touched", addFinalizer=FALSE))
  free(doc)
  rm(doc)
  return(bot)
}

edit <- function(title, text="", bot, summary="", minor=FALSE){

  if(is.logical(minor)){
    minor = as.character(minor)
  }
  
  #TODO no check is done to see if token is stale
  #get an edit token if we don't have one already
  if (is.null(bot$edittoken)){
    bot = getEditToken(bot, title)  
  }
  
  
  #can pass:
  #summary
  #minor
  #title (or) pageid
  
  editResponse = postForm(bot$apiURL,
                           action="edit",
                           format="xml",
                           prop="info",
                           title=title,
                           bot="true",
                           token=bot$edittoken,
                           basetimestamp=bot$touched,
                           starttimestamp=bot$starttimestamp,
                           summary=summary,
                           minor=minor,
                           text=text,
                           .opts=bot$curlOpts)
}


#action=sfautoedit
#form=form-name
#target=page-name
#query=template-name[field-name-1]=field-value-1%26template-name[field-name-2]=field-value-2

#this should be called for each row in a data frame
sfautoedit <- function(title, formName, bot, summary="", minor=FALSE){
  
  if(is.logical(minor)){
    minor = as.character(minor)
  }
  
  #TODO no check is done to see if token is stale
  #get an edit token if we don't have one already
  if (is.null(bot$edittoken)){
    bot = getEditToken(bot, title)  
  }
  
  
  #can pass:
  #summary
  #minor
  #title (or) pageid
  
  editResponse = postForm(bot$apiURL,
                          action="sfautoedit",
                          format="xml",
                          target=title,
                          bot="true",
                          token=bot$edittoken,
                          basetimestamp=bot$touched,
                          starttimestamp=bot$starttimestamp,
                          summary=summary,
                          minor=minor,
                          text=text,
                          .opts=bot$curlOpts)
}