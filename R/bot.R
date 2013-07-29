library(RCurl) #http POST
library(XML) #process responses
library(reshape2) #colsplit for working with template parameters and their values

#never ever convert strings to factors
options(stringsAsFactors = FALSE)

initializeBot <- function(apiURL, verbose=FALSE, userpwd = ""){
  curlOpts = curlOptions(verbose=verbose, #useful for debugging weirdness
                       header=TRUE, 
                       httpheader=c("Expect:"), # Needed if you have a proxy server such as squid set up, see http://stackoverflow.com/questions/6244578/curl-post-file-behind-a-proxy-returns-error
                       cookiefile="cookies.txt", #Cookies are required for managing sessions
                       cookiejar="cookies.txt")
  
  if (userpwd != ""){
    curlOpts[["httpauth"]] = 1L
    curlOpts[["userpwd"]] = userpwd
  }
  
  bot = list(apiURL, curlOpts)
  names(bot) = c("apiURL", "curlOpts")
  return(bot)
}