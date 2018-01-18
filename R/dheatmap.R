#' Heatmap Plot
#' 
#' Displays results of a D statistic scan as a heatmap.
#' 
#' @param d_matrix A matrix of D statistics, given by the output of dwrapper.
#' @param colors A color vector. Optionally modify the color scheme of the heatmap. If mode = 'binned', must be of length 5.
#' @param mode A string indicating desired mode. Use "linear" for most applications including use on base D statistic matrices.
#' For either of the ratio matrices, 'truncated' is most appropriate, though "binned" may be used if you would prefer a more
#' discreet distribution of colors.
#' 
#' @return A color plot
#' 
#' @export
dheatmap <- function(d_matrix, colors = c("white", "lightblue", "blue", "darkblue", "black"), mode = "linear"){
  if (mode == 'linear'){
    heatmaps <- lattice::levelplot(d_matrix,
                          col.regions = colorRampPalette(colors),
                          space = "rgb")
  }
  else if (mode == 'truncated'){
    d_matrix[which(d_matrix > 1)] <- 1
    heatmaps <- lattice::levelplot(d_matrix,
                          col.regions = colorRampPalette(colors),
                          space = "rgb", 
                          colorkey=list(space="right", col=colors, at=c(0,0.25,0.5,0.75,1,1.1), labels=c("0","0.25","0.5","0.75","1",">1.0")))
  }
  else if (mode == 'binned'){
    if (length(colors) == 5){
    d_matrix[which(d_matrix > 1)] <- 2
    heatmaps <- lattice::levelplot(d_matrix,
                          col.regions = c(rep(colors[1], 25), rep(colors[2], 25), rep(colors[3], 25), rep(colors[4], 25), rep(colors[5], 25)),
                          space = 'rgb',
                          colorkey=list(space="right", col=colors, at=c(0,0.25,0.5,0.75,1,1.1), labels=c("0","0.25","0.5","0.75","1",">1.0")))
    }
    else{
      stop('colors must be of length 5.')
    }
  }
  else {
    stop('Please use a valid mode. "linear", "truncated", or "binned".')
  }
  return(heatmaps)
}