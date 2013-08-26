getRollbackToken <- function(bot, title){
  rollBackResponse = postForm(bot$apiURL,
                              action="query",
                              format="xml",
                              prop="revisions",
                              rvtoken="rollback",
                              titles=title,
                              .opts=bot$curlOpts)
    
  doc = xmlParse(rollBackResponse, useInternalNodes=TRUE)
  
  # create a list where the elements are the tokens and the names are the titles
  rollbacktokens = c()
  # for every page, need to get the rollback token
  pages <- getNodeSet(doc, "//api/query/pages/page", addFinalizer=FALSE)
  for (page in pages){
    title = unlist(getNodeSet(page, "./@title", addFinalizer=FALSE))
    token = unlist(getNodeSet(page, "./revisions/rev/@rollbacktoken", addFinalizer=FALSE))
    rollbacktokens[title] = token
    if (is.null(token)){
      warning(paste("Couldn't get rollbacktoken for", title))
    }
  }
  
  bot$rollbacktokens <- rollbacktokens
  
  free(doc)
  rm(doc)
  return(bot)
}

rollback <- function(title, user="", bot, summary="", minor=FALSE){
  
  bot <- getRollbackToken(bot, title)
  for (tokenNum in c(1:length(bot$rollbacktokens))){
    print(tokenNum)
    title = names(bot$rollbacktokens)[tokenNum]
    token = bot$rollbacktokens[tokenNum]
    rollbackResponse = postForm(bot$apiURL,
                                action="rollback",
                                format="xml",
                                title=title,
                                user=user, 
                                markbot="",
                                token=token,
                                summary=summary,
                                .opts=bot$curlOpts)
  }   
}