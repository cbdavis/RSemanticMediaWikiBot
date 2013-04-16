delete <- function(title, bot, reason="", minor=FALSE){
  
  if(is.logical(minor)){
    minor = as.character(minor)
  }
  
  #TODO no check is done to see if token is stale
  #get an edit token if we don't have one already
  if (is.null(bot$edittoken)){
    bot = getEditToken(bot, title)  
  }
  
  
  #can pass:
  #reason
  #minor
  #title (or) pageid
  
  deleteResponse = postForm(bot$apiURL,
                          action="delete",
                          title=title,
                          bot="true",
                          token=bot$edittoken,
                          basetimestamp=bot$touched,
                          starttimestamp=bot$starttimestamp,
                          reason=reason,
                          minor=minor,
                          .opts=bot$curlOpts)
}