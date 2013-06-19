# from and to should both be titles, IDs are not supported yet
move <- function(fromTitle, toTitle, bot, reason="", minor=FALSE){
  
  if(is.logical(minor)){
    minor = as.character(minor)
  }
  
  #TODO no check is done to see if token is stale
  #get an edit token if we don't have one already
  if (is.null(bot$edittoken)){
    bot = getEditToken(bot, fromTitle)  
  }
  
  moveResponse = postForm(bot$apiURL,
                          action="move",
                          format="xml",
                          to=toTitle,
                          from=fromTitle,
                          bot="true",
                          token=bot$edittoken,
                          basetimestamp=bot$touched,
                          starttimestamp=bot$starttimestamp,
                          reason=reason,
                          minor=minor,
                          .opts=bot$curlOpts)
}