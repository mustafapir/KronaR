#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
KronaR <- function(t, width = NULL, height = NULL, elementId = NULL) {
  names(t)[1] <- c('freq')

  t$freq <- as.numeric(t$freq)
  #if any sequences can not be assigned to the highest hieracial level give them a random name like "NA"
  t[t[,2]=="",2] <- "NA"
  #define the hieracy (do not include the counting var here), the first space is the root category
  t$pathString <- apply(t[, -1], 1, function(row) paste(row, collapse = "/"))
  #transform to a data.tree
  t <- as.Node(t)
  #define the sequence frequency calculations
  t$Do(function(x) x$freq <- Aggregate(x, "freq", sum), traversal = "post-order")
  print(t,"freq")
  #get all frequencies for each node
  repval <- t$Get("freq")
  #tranform into a nested list and afterwards into a xml document to get the nesting
  t <- t %>% as.list(.,mode="simple",unname=T)
  t <- as_xml_document(list(root=t))%>%as.character
  #from here it is just a bunch of regex
  #split the xml file into one line for each <
  temp <- strsplit(t,"\n")[[1]][2] %>% strsplit(.,"(?=<)",perl=T) %>% .[[1]]
  temp <- paste0(temp[c(T,F)],temp[c(F,T)]) %>% gsub("[0-9]","",.)
  #remove the names nodes and replace by krona annotation
  #replace the closing named tags by generic closing "node" tags
  temp <- gsub("</(.*)?>","</node>",temp) %>% gsub(">.*$",">",.)
  #replace the named opening tags by generic "node" tags with the "name" attribute, replace all (because they are incomplete) numeric values with a placeholder
  temp <- gsub("<(?=[^/])(.*)?>",
      '<node name="\\1"><magnitude><val>__\\1</val><val>1</val></magnitude>',temp,perl=T)
  temp %<>% gsub("root"," ",.)
  #find the placeholders to insert the frequencies and execute
  repos <- grep("__",temp)
  for (i in repos)
    temp[i] <- gsub("^(.*)(__.*?)(?=<)(.*)",paste0("\\1",repval[which(repos==i)],"\\3"),temp[i],perl=T)




  dataxml <- paste(temp, collapse = "")

  x = list(

    data =dataxml
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'KronaR2',
    x,
    width = width,
    height = height,
    package = 'KronaR2',
    elementId = elementId
  )
}

#' Shiny bindings for KronaR
#'
#' Output and render functions for using KronaR within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a KronaR
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name KronaR-shiny
#'
#' @export
KronaROutput <- function(outputId, width = '100%', height = '100%'){
  htmlwidgets::shinyWidgetOutput(outputId, 'KronaR2', width = '100%', height = '100%', package = 'KronaR2')
}

#' @rdname KronaR-shiny
#' @export
renderKronaR <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, KronaROutput, env, quoted = TRUE)
}
