# this takes a data frame and tries to write in to some sort of sensible wiki table format
getWikiTableTextForDataFrame <- function(df, headers="", tableClass="wikitable sortable"){
  # if headers aren't specified, just use the column names
  if (headers == "")  {
    headers = colnames(df)
  } else if (length(headers) != ncol(df)) {
    stop("Number of headers for the table is not equal to the number off columns in the data frame")
  }

  # clean up header names - underscore to spaces
  headers = gsub("_", " ", headers)
  
  header = paste('{| class="', tableClass, '"\n', sep="")
  headerColumnText = paste(paste("! ", # beginning of row
                                 paste(headers, collapse=" !! ") # delimiter for cells in row
                                 , sep="")
                           , "\n|-\n", sep="") # indicator to move to the next row
  header = paste(header, headerColumnText, sep="")
                 
  rows = paste(apply(df, 
                     MARGIN=1, # operate on rows
                     FUN=function(x){
                       paste(
                         paste("| ", # beginning of row
                               paste(x, collapse=" || ") # delimiter for cells in row
                               , sep="")
                         , "\n|-\n", sep="")}) # indicator to move to the next row
               , collapse="") # join all the rows together into one single string
  footer = "|}\n"
  
  wikiTable = paste(header, rows, footer, sep="")
  return(wikiTable)
}