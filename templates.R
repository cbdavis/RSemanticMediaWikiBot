#TODO issues to deal with:
#create new or overwrite info in existing template? - need some way to identify which one the user intends to edit
#Templates may or may not have underscores instead of spaces
#would be nice to be able to clean out old parameters that are not used anymore

extractTemplates <- function(pageTitle, bot){
  #read the contents of the page
  textVal = read(title=pageTitle, bot)
  
  #extract all the templates
  matchingInfo = gregexpr("\\{\\{[^\\}]+\\}\\}", textVal)
  templateStartLocs = as.numeric(matchingInfo[[1]])
  templateEndLocs = attr(matchingInfo[[1]], "match.length")
  
  allTemplateInfo = NULL
  
  #TODO what about uppercase/lowercase names for template parameters?
  #TODO what is no parameters listed in the template?
  #Check if only one parameter set also
  #Check if newline characters are preserved
  for (i in c(1:length(templateStartLocs))){
    start = templateStartLocs[i]    
    end = start + templateEndLocs[i] - 1
    text = substring(textVal, start, end)
    
    #break the template into its parts
    parametersAndValues = strsplit(text, "\\|")[[1]]
    
    #extract name of template
    templateName = gsub("\n", "", gsub("\\{\\{", "", parametersAndValues[1]))
    #replace spaces with underscores
    #this helps to make names consistent if multiple templates of the same type are included, but use both variations for the name
    templateName = gsub(" ", "_", templateName)
    
    #remove the part with the name of the template
    parametersAndValues = tail(parametersAndValues, n=-1L)
    
    #remove the }} ending the template from the last parameter
    parametersAndValues[length(parametersAndValues)] = gsub("\\}\\}", "", parametersAndValues[length(parametersAndValues)])
    
    parametersAndValues = gsub("\\n$", "", parametersAndValues)

    data = NULL
    
    if (length(parametersAndValues) > 0){
      #convert this all into a data frame
      parametersAndValues = colsplit(parametersAndValues, split="=", names=c('parameter', 'value'))
    
      #store this in a vector with names that we can reference
      #also remove leading and trailing white space
      data = gsub(" +$", "", gsub("^ +", "", as.character(parametersAndValues[,2])))
      names(data) = gsub(" +$", "", gsub("^ +", "", parametersAndValues[,1]))
  
      #When there is an empty values for a template parameter, the value shows up as the name of the template parameter
      locs = which(data == names(data)) #find entries with this issue
      data[locs] = "" #set value to empty string
      #Convert to a list.  This allows us to reference values via data$point, etc.
      data = as.list(data)
    }
    templateInfo = list(textVal, pageTitle, templateName, start, end, text, parametersAndValues, data)
    names(templateInfo) = c("pageText", "pageTitle", "name", "start", "end", "text", "parametersAndValues", "data")
    
    allTemplateInfo = c(allTemplateInfo, list(templateInfo))
  }
    
  return(allTemplateInfo)
}

#This can return multiple templates if you are using multiple instance templates
getTemplateByName <- function(templateName, pageTitle, bot){  
  allTemplateInfo = extractTemplates(pageTitle, bot)
  
  templateName = gsub(" ", "_", templateName) #spaces are converted to underscores to ensure consistent matching
  templatesToReturn = NULL
  for (templateInfo in allTemplateInfo){
    if(templateInfo$name == templateName){
      templatesToReturn = c(templatesToReturn, list(templateInfo))
    }
  }
  return(templatesToReturn)
}

writeTemplateToPage <- function(template, bot, editSummary=""){
  header = paste("{{", template$name, "\n", sep="")
  dataSection = paste(paste(paste("| ", names(template$data), sep=""), template$data, sep="="), collapse="\n")
  footer = "}}"
  
  templateText = paste(header, dataSection, footer, sep="")
  
  #now put this back in the main text  
  #get text before and after template
  textBeforeTemplate = substr(template$pageText, 1, template$start-1)
  textAfterTemplate = substr(template$pageText, template$end+1, 1000000L)
  
  #put all the text back together, with the new contents of the template
  newPageText = paste(textBeforeTemplate, templateText, textAfterTemplate, sep="")
  edit(title=template$pageTitle, summary=editSummary, text=newPageText, bot)
}