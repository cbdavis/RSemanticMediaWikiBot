login <- function(username, password, apiURL, myOpts){

  loginResponse1 = postForm(apiURL,
                            action="login",
                            format="xml",
                            lgname=username,
                            lgpassword=password,
                            .opts=myOpts)

  doc = xmlParse(loginResponse1, useInternalNodes=TRUE)
  token <- unlist(getNodeSet(doc, "//api/login/@token", addFinalizer=FALSE))
  free(doc)
  rm(doc)
  
  loginResponse2 = postForm(apiURL,
                            action="login",
                            format="xml",
                            lgname=username,
                            lgpassword=password, 
                            lgtoken=token,
                            .opts=myOpts)

}