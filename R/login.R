login <- function(username, password, bot){

  loginResponse1 = postForm(bot$apiURL,
                            action="login",
                            format="xml",
                            lgname=username,
                            lgpassword=password,
                            .opts=bot$curlOpts)

  doc = xmlParse(loginResponse1, useInternalNodes=TRUE)
  token <- unlist(getNodeSet(doc, "//api/login/@token", addFinalizer=FALSE))
  free(doc)
  rm(doc)
  
  loginResponse2 = postForm(bot$apiURL,
                            action="login",
                            format="xml",
                            lgname=username,
                            lgpassword=password, 
                            lgtoken=token,
                            .opts=bot$curlOpts)

}