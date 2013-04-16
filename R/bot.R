#TODO set these up within an R package to be installed automatically if not installed yet
library(RCurl) #http POST
library(XML) #process responses
library(reshape2) #colsplit for working with template parameters and their values

#never ever convert strings to factors
options(stringsAsFactors = FALSE)

source("login.R")
source("edit.R")
source("read.R")
source("delete.R")
source("templates.R")


initializeBot <- function(apiURL, verbose=FALSE){
  curlOpts = curlOptions(verbose=verbose, #useful for debugging weirdness
                       header=TRUE, 
                       httpheader=c("Expect:"), # Needed if you have a proxy server such as squid set up, see http://stackoverflow.com/questions/6244578/curl-post-file-behind-a-proxy-returns-error
                       cookiefile="cookies.txt", #Cookies are required for managing sessions
                       cookiejar="cookies.txt")
  
  bot = list(apiURL, curlOpts)
  names(bot) = c("apiURL", "curlOpts")
  return(bot)
}