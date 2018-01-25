#' Heatmap Plot
#' 
#' Plots a matrix of D statistics, output from dwrapper, as a heatmap.
#' 
#' @param d_matrix A matrix of D statistics or a matrix of D statistic ratios. 
#' @param colors An optional color vector. Optionally modify the color scheme of the heatmap. If mode = 'binned', must be of length 5.
#' @param mode A string indicating desired coloring scheme. The option "linear" scales
#' colors linearly, "truncated" truncates values greater than 1, and "binned" returns
#' a discretedistribution of colors.
#' 
#' @return A color plot
#'
#' @details
#' The d_matrix input should be one of the matrices output by dwrapper. Options are d2it_mat, d2is_mat, d2st_mat, dp2st_mat, dp2is_mat, npops_mat, ratio1, and ratio2.
#' More customized plots can be developed using the "levelplot" package.
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
