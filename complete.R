# Coursera - Kamal Mishra  
# Program Assignment - 1, Part 2
# Write a function that reads a directory full of files and 
# reports the number of completely observed cases in each data file.
# The function should return a data frame where the first column is the name of the file and 
# the second column is the number of complete cases.
complete <- function (directory, id=1:332){
  
  ## Get a list of filenames
  #filenames <- list.files(path=directory,pattern="*.csv")
  
  ## Initialize variables
  #ids <- vector()
  #counts = vector()
  
  ## Loop over the passed ids
  #for (i in id){
    
    ## Pad the id to create a filename
    #filename <- sprintf("%03d.csv",i)
    #filepath <- paste(directory,filename,sep="/")
    
    ## Load the data 
    #data <- read.csv(filepath)
    
    ## Store the id
    #ids <- c(ids,i)
    
    ## Calculate and store the count of complete cases
    #completeCases <- data[complete.cases(data)]
    #counts <- c(counts,nrwo(completeCases))
    
    
  #}
  
  ## Return the data frame
  ## id - Monitor id
  ## nobs - number of complete cases
  #data.frame (id=ids,nobs=counts)
  
  nobs <- function(id) {
    path <- file.path(directory, paste(sprintf("%03d", as.numeric(id)), ".csv", sep=""))
    return (sum(complete.cases(read.csv(path))))
  }
  return (data.frame(id=id, nobs=sapply(id, nobs)))
      
}
